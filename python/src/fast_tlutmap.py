'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os
import shutil
import sys
from mapping import *   


colwidth=16
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

#copy and edit this function, or call it with your vhdl module as its argument (optional list of submodules as second argument)
def run(module, submodules=[], K=4, virtexFamily=None, performCheck=True, generateImplementationFilesFlag=True, verboseFlag=False):
    ext = module.split('.')[-1].lower()
    baseName = module[:-len(ext)-1]
    if ext not in ('vhd','vhdl','v'):
        print >> sys.stderr, "Error: Module filename does not have extension '.vhd','.vhdl' or '.v':", module
        exit(3)
        
    if virtexFamily in ("virtex2pro",):
        K = 4
    elif virtexFamily in ("virtex5",):
        K = 6
    elif virtexFamily != None:
        print >> sys.stderr, "Error: Unsupported FPGA family:", virtexFamily
        exit(1)
    
    print "Stage: Creating work directory and copying design"
    try:
        os.system('mkdir -p work')
        shutil.copy(module, 'work')
        for submodule in submodules:
            shutil.copy(submodule, 'work')
        shutil.copy('abc.rc','work')
    except IOError as e:
        print >> sys.stderr, e
        exit(3)
    
    ret_pwd = os.getcwd()
    os.chdir('work')
    
    # Synthesis
    print "Stage: Synthesizing"
    blifFileName = synthesize(module, submodules, verboseFlag)
    
    # Automatically extract parameters from VHDL
    print "Stage: Generating parameters"
    parameterFileName = baseName+'.par'
    try:
        assert not os.system('genParameters.py %s %s > %s.par'%(module,blifFileName,baseName))
        if verboseFlag:
            print "Parameters:"
            os.system('cat %s.par'%baseName)
        else:
            print "Attention: Verify the detected parameters by inspecting work/%s.par"%baseName
    except AssertionError:
        exit(3)
    
    # Convert BLIF to aig
    aagFileName = bliftoaag(blifFileName)
    
    # Unleash TLUT mapper
    print "Stage: TLUT mapper"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, generateImplementationFilesFlag, verboseFlag)
    print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
    print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
    
    #Print C-files
    if generateImplementationFilesFlag:
        parconfFile = baseName + "-parconfig.aag"
        CFileName = baseName + '.c' 
        headerFileName = baseName + '.h' 
        assert virtexFamily, "Error: No FPGA family provided, cannot generate C functions"
        printCFunction(parconfFile, CFileName, headerFileName, virtexFamily)
    
    # Run regular MAP
    print "Stage: SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName, aagFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','depth','check'],colwidth)
    print collumnize([numLuts,depth,check],colwidth)
    
    # Run regular abc fpga
    print "Stage: ABC fpga"
    numLuts, depth, check = fpgaMapper(baseName, blifFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','depth','check'],colwidth)
    print collumnize([numLuts,depth,check],colwidth)
    
    os.chdir(ret_pwd)
    
if __name__=="__main__":
    print 'Call the function run of this file with your vhdl module as its first argument (optional list of submodule as second argument)'
    print 'or copy and edit this file to use it as a template for your experiment.'
