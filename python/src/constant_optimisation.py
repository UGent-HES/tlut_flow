#!/usr/bin/env python

import os, shutil, sys
from itertools import product
from fast_tlutmap import generateQSF, synthesize, fpgaMapper, simpleMapper, resynthesize, collumnize, colwidth, getBasenameAndExtension, createWorkDirAndCopyFiles
from itertools import islice
from collections import Counter

maxFailedAllowed = 16

def group_per(iterable,n):
    for i in xrange(0,len(iterable),n):
        yield islice(iterable,i,i+n)
    
def intToUnsignedLogicVector(i,width):
    assert 0 <= i < 2**width
    return ("{:0%db}"%width).format(i)

def generateIntToUnsignedLogicVector(width):
    return lambda i: intToUnsignedLogicVector(i, width)

def parseParameters(par_filename):
    return [line.rstrip('\r\n') for line in open(par_filename).readlines()]

def removeBlifComments(line):
    comment_index = line.find('#')  #remove comments
    if comment_index != -1:
        line = line[:comment_index]
    return line
    
def prepareBlif(blif_filename, parameters):
    basename, ext = getBasenameAndExtension(blif_filename)
    oblif_filename = basename+"_prep."+ext

    file = open(blif_filename, 'rU')
    ofile = open(oblif_filename, 'w')
    
    #copy part before input section
    line = file.readline()
    while not line.lstrip().startswith('.inputs '):
        print >>ofile, line,
        line = file.readline()
    
    #read input section
    line = removeBlifComments(line).rstrip('\r\n').lstrip()
    while line.endswith('\\'): #multi-line inputs section
        line = line[:-1] + ' ' + removeBlifComments(file.readline()).rstrip('\r\n').lstrip()
        
    #filter inputs that correspond to parameters
    parameters = map(str.lower, parameters)
    inputs = line.split()[1:]
    def input_not_in_parameters(input):
        return input.lower() not in parameters
    non_param_inputs = filter(input_not_in_parameters, inputs)
    
    #write new inputs section
    print >>ofile, '.inputs ',
    print >>ofile, ' \\\n\t'.join(' '.join(l) for l in group_per(non_param_inputs, 8))
    
    #copy part after input section
    line = file.readline()
    while line and not line.startswith('.end'):
        print >>ofile, line,
        line = file.readline()
        
    file.close()
    ofile.close()
    
    return oblif_filename
    
def configureBlif(prep_blif_filename, parameters, par_configuration):
    basename, ext = getBasenameAndExtension(prep_blif_filename)
    oblif_filename = "%s_%X.%s"%(basename, hash(par_configuration), ext)
    
    shutil.copy(prep_blif_filename, oblif_filename)
    
    file = open(oblif_filename, 'a')
    
    assert len(parameters) == len(par_configuration)
    for parameter, conf in zip(parameters, par_configuration):
        print >>file, '.names', parameter
        print >>file, conf
    
    print >>file, '.end'
    
    file.close()
    return oblif_filename
    

def run_Blif_configuration(id, par_configuration, prep_blif_filename, parameters, K, verboseFlag=False):
    baseName, ext = getBasenameAndExtension(prep_blif_filename)
    
    #print "Parameter configuration: %s (%X)"%(par_configuration, hash(par_configuration))

    conf_blif_filename = configureBlif(prep_blif_filename, parameters, par_configuration)
    conf_blif_filename = resynthesize(baseName, conf_blif_filename)
    
    # Run regular abc fpga
    #print "Stage: ABC fpga",
    numLuts, depth, check = fpgaMapper(baseName, conf_blif_filename, K, False, verboseFlag)
    #print collumnize(['Luts', 'depth', 'check'], colwidth)
    print collumnize([id, numLuts, depth], colwidth)
    
    os.system('rm -f '+conf_blif_filename)
    
    return (numLuts, depth)


def runBlif(blif_filename, par_filename, K=4, verboseFlag=False):
    baseName, ext = getBasenameAndExtension(blif_filename)
    if ext not in ('blif'):
        raise Exception("Module filename does not have extension '.blif':%s"%blif_filename)
    print "Stage: Creating work/"+baseName+" directory and copying design"
    workDir = 'work/'+baseName
    createWorkDirAndCopyFiles(workDir, [blif_filename, par_filename])
   
    parameters = parseParameters(par_filename)
        
    ret_pwd = os.getcwd()
    os.chdir(workDir)
    
    prep_blif_filename = prepareBlif(blif_filename, parameters)

    results = Counter()
    try:
        for id, par_configuration in enumerate(product((0,1), repeat=len(parameters))):
            res = run_Blif_configuration(id, par_configuration, prep_blif_filename, parameters, K, verboseFlag)
            results[res] += 1
    except:
        print results
        raise
    print results



def configureVHDL(baseName, vhdl_filename, par_configuration):
    conf_vhdl_filename = baseName + '.vhd'
    cmd = 'perl'
    for k,v in par_configuration:
        cmd += r" -pe 's/\$%s\$/%s/g;'"%(k,v)
    cmd += ' ' + vhdl_filename + '>' + conf_vhdl_filename
    assert not os.system(cmd)
    return conf_vhdl_filename

def run_VHDL_configuration(id, par_configuration, baseName, vhdl_filename, submodules, K, verboseFlag=False):
    par_configuration = tuple(par_configuration)
    
    print "Parameter configuration: %s (%X)"%(par_configuration, hash(par_configuration))

    conf_vhdl_filename = configureVHDL(baseName, vhdl_filename, par_configuration)
    
    qsfFileName = generateQSF(conf_vhdl_filename, submodules)
    
    conf_blif_filename = synthesize(conf_vhdl_filename, qsfFileName, verboseFlag)
    conf_blif_filename = resynthesize(baseName, conf_blif_filename)
    
    # Run regular abc fpga
    #print "Stage: ABC fpga",
    #numLuts, depth, check = fpgaMapper(baseName, conf_blif_filename, K, False, verboseFlag)
    numLuts, depth, check = simpleMapper(baseName, conf_blif_filename, K, False, verboseFlag)

    #print collumnize(['Luts', 'depth', 'check'], colwidth)
    print collumnize([id, numLuts, depth], colwidth)
    
    os.system('rm -f '+conf_blif_filename)
    
    return (numLuts, depth)

def runVHDL(vhdl_filename, submodules, parameter_values, K=4, verboseFlag=False):
    baseName, ext = getBasenameAndExtension(vhdl_filename)
    vhdl_templ_filename = baseName + '_templ.' + ext
    if ext not in ('vhd','vhdl'):
        raise Exception("Module filename does not have extension '.vhd' or '.vhdl': %s"%vhdl_filename)
    print "Stage: Creating work/"+baseName+" directory and copying design"
    workDir = 'work/'+baseName
    createWorkDirAndCopyFiles(workDir, submodules)
    shutil.copy(vhdl_filename, workDir + '/' + vhdl_templ_filename)
    
        
    ret_pwd = os.getcwd()
    os.chdir(workDir)

    results = Counter()
    failed = []
    try:
        parameter_names, parameter_ranges = zip(*parameter_values.items())
        for id, configuration in enumerate(product(*parameter_ranges)):
            par_configuration = zip(parameter_names, configuration)
            print par_configuration
            try:
                res = run_VHDL_configuration(id, par_configuration, baseName, vhdl_templ_filename, submodules, K, verboseFlag)
                results[res] += 1
            except Exception as e:
                print e
                failed.append((par_configuration, e))
                if len(failed) > maxFailedAllowed:
                    raise Exception("Too many failures")
                #raise
    #except:
    #    raise
    finally:
        print results
        print 'failed (%d): %s'%(len(failed), failed)
    
    os.chdir(ret_pwd)

