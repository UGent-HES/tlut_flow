import os
import sys
import commands
import subprocess

def check_setup(path):
    if not os.path.exists('abc.rc'):
        print 'Error: No abc.rc file found at path: '+path
        exit(3)

def simpleMapper(path, fname,K, checkFunctionality,verboseFlag=False):
    ext = fname.split('.')[-1]
    basename = '.'.join(fname.split('.')[:-1])
    assert ext
    assert basename
    
    blifFile = path + "/" + basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    outFile =  basename + "-simple.blif"
    
    if ext == 'blif':
        subprocess.check_call(['abc', '-c', 'strash; write '+aigFile, blifFile])
        subprocess.check_call(['aigtoaig', aigFile, aagFile])
    elif ext == 'aig':
        subprocess.check_call(['aigtoaig', aigFile, aagFile])
    elif ext == 'aag':
        subprocess.check_call(['aigtoaig', aagFile, aigFile])
    
    cmd  = ['java','-server','-Xms1024m','-Xmx2048m','be.ugent.elis.recomp.mapping.simple.SimpleMapper']
    args = [aagFile, str(K), outFile]
    if verboseFlag:
        print ' '.join(cmd + args)
    output = subprocess.check_output(cmd + args)
    if verboseFlag:
        print output
    
    data = output.splitlines()[-1].split()
    numLuts = float(data[0])
    depth   = float(data[1])
    
    if checkFunctionality:
        check = miter(aigFile, outFile, verboseFlag)
    else:
        check = "SKIPPED"
    return (numLuts, depth, check)

def simpleTMapper(path, fname, paramFileName, K, checkFunctionality, verboseFlag=False):
    ext = fname.split('.')[-1]
    basename = '.'.join(fname.split('.')[:-1])
    assert basename
    assert ext
    
    blifFile = basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    
    if ext == 'blif':
        subprocess.check_call(['abc', '-c', 'strash; write '+aigFile, blifFile])
        subprocess.check_call(['aigtoaig', aigFile, aagFile])
    elif ext == 'aig':
        subprocess.check_call(['aigtoaig', aigFile, aagFile])
    elif ext == 'aag':
        subprocess.check_call(['aigtoaig', aagFile, aigFile])
        
    outFile =  basename + "-simpletmap.blif"
    parconfFile = basename + "-parconfig.aag"
    lutstructFile = basename + "-lutstruct.blif"
    vhdFile = basename[:-len('-sweep-ordered')] + ".vhd"
    assert basename.endswith('-sweep-ordered')
    
    # Using TMAP to map the circuit
    cmd  = ['java','-server','-Xms1024m','-Xmx2048m','be.ugent.elis.recomp.mapping.tmapSimple.TMapSimple']
    args = [aagFile, paramFileName, str(K), outFile, parconfFile, lutstructFile, vhdFile]
    if verboseFlag:
        print ' '.join(cmd + args)
    output = subprocess.check_output(cmd + args)
    if verboseFlag:
        print output
    
    data = output.splitlines()[-1].split()
    numLuts = float(data[0])
    depth   = float(data[1])
    numTLuts =  float(data[2])
    avDup = float(data[3])
    
    # Parameterizable Configuration
    cmd = ['abc','-c','resyn3; print_stats',aagtoaig(aagFile)]
    # print cmd
    output = subprocess.check_output(cmd)
    if verboseFlag:
        print ' '.join(cmd)
        print output,
    data = output.splitlines()[-1].split()
    # print data
    try:
        origAnds = float(data[data.index('and')+2])
    except ValueError:
        if not verboseFlag:
            print ' '.join(cmd)
            print output,
        print "Error: unexpected output from abc print_stats."
        exit(2)

    cmd = ['abc','-c','resyn3; print_stats',aagtoaig(parconfFile)]
    # print cmd
    output = subprocess.check_output(cmd)
    if verboseFlag:
        print ' '.join(cmd)
        print output,
    data = output.splitlines()[-1].split()
    # print data
    try:
        paramAnds = float(data[data.index('and')+2])
    except ValueError:
        if not verboseFlag:
            print ' '.join(cmd)
            print output,
        print "Error: unexpected output from abc print_stats."
        exit(2)
    
    if checkFunctionality:
        # Merging the LUT-structure and the parameterizable configuration.
        mergedFile =  basename + "-merge.aag"
        cmd  = ['java','be.ugent.elis.recomp.aig.MergeAag']
        args = [parconfFile, bliftoaag(lutstructFile), mergedFile]
        if verboseFlag:
            print ' '.join(cmd + args)
        output = subprocess.check_output(cmd + args);
        #print output
    
        # Check if the merge of the LUT-structure and the parameterizable 
        # configuration have the same functionality as the input circuit.    
        mergedAigFile = aagtoaig(mergedFile)
        check = miter(aigFile, mergedAigFile, verboseFlag)
    else:
        check = "SKIPPED"
    return (numLuts, numTLuts, depth, avDup, origAnds, paramAnds, check)    


def aagtoaig(aagFileName):
    ext = '.aag'
    basename = aagFileName[:-len(ext)]
    aigFileName = basename + '.aig'
    assert aagFileName.endswith(ext)
    assert aigFileName
    subprocess.check_call(['aigtoaig',aagFileName,aigFileName])
    return aigFileName

def aigtoaag(aigFileName):
    ext = '.aig'
    basename = aigFileName[:-len(ext)]
    aagFileName = basename + '.aag'
    assert aigFileName.endswith(ext)
    assert aagFileName
    subprocess.check_call(['aigtoaig',aigFileName,aagFileName])
    return aagFileName
 
def bliftoaag(blifFileName):
    ext = '.blif'
    basename = blifFileName[:-len(ext)]
    aigFileName = basename + '.aig'
    assert blifFileName.endswith(ext)
    assert basename

    # There seems to be a bug in bliftoaig when input file is large.
#    subprocess.check_call('bliftoaig',blifFileName,aagFileName])

    cmd = ['abc', '-c', 'strash; zero; write '+aigFileName, blifFileName]
    subprocess.check_call(cmd)
    print 'Please ignore the error message "Error: The current network is combinational".'
    
    aagFileName = aigtoaag(aigFileName)
    return aagFileName


def fpgaMapper(path, fname, verboseFlag=False):
    ext = '.blif'
    basename = fname[:-len(ext)]
    assert fname.endswith(ext)
    assert basename
    inFile = path + "/" + fname
    outFile =  basename + "-fpga.blif"
    
    cmd = ['abc', '-c', 'strash; fpga; print_stats; write '+outFile, inFile]
    if verboseFlag:
        print cmd
    output = subprocess.check_output(cmd)
    if verboseFlag:
        print output
    
    numLuts = float(output.split()[-10])
    depth   = float(output.split()[-1])
    check   = miter(inFile, outFile, verboseFlag)
    return (numLuts, depth, check)
    
def miter(circuit0, circuit1, verboseFlag=False):
    cmd = ['abc', '-c', 'miter ' + circuit0 + ' ' + circuit1 + '; prove']
    if verboseFlag:
        print ' '.join(cmd)
    try:
        output = subprocess.check_output(cmd,stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as ex:
        print ex.output
        exit(2)
    if verboseFlag:
        print output,
    if "UNSATISFIABLE" in output:
        return "PASSED"
    elif " SATISFIABLE" in output:
        return "FAILED"
    else:
        assert "SATISFIABLE" in output or "UNSATISFIABLE" in output
    
def synthesize(top, submodules, verboseFlag=False):
    ext = '-preprocessor.vhd'
    assert top.endswith(ext)
    basename = top[:-len(ext)]
    assert basename
    currentFileName = basename+'.vhd'
    assert not os.system('cp '+ top +' '+ currentFileName)

    
    qsfFileName = basename + ".qsf"
    fout = open(qsfFileName, "w")

    fout.write('set_global_assignment -name VHDL_FILE ' + top + '\n')
    for file in submodules:
        fout.writelines('set_global_assignment -name VHDL_FILE ' + file + '\n')

    fout.write('set_global_assignment -name FAMILY Stratix\n');
    fout.write('set_global_assignment -name TOP_LEVEL_ENTITY ' + basename + '\n');
    fout.write('set_global_assignment -name DEVICE_FILTER_SPEED_GRADE FASTEST\n');

    fout.write('set_global_assignment -name INI_VARS \"no_add_ops=on\;opt_dont_use_mac=on\;dump_blif_after_lut_map=on\;abort_after_dumping_blif=on\"\n');

    fout.write('set_global_assignment -name DEVICE AUTO\n');
    fout.write('set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1\n');

    fout.close()

    cmd = 'quartus_map ' + qsfFileName
    if verboseFlag:
        print cmd
    output = commands.getoutput(cmd);
    print output
    assert output.index(' 0 errors')!=-1
    print 'Please ignore the error message "Error: Quartus II Analysis & Synthesis was unsuccessful" if 0 errors and 0 warnings are found.'
    
    blifFileName  = basename + ".blif"
    sweepFileName = basename + "-sweep.blif"
    orderedSweepFileName = basename + "-sweep-ordered.blif"
    cmd = ['abc', '-c', 'sweep', '-o', sweepFileName, '-t', 'blif', '-T', 'blif', blifFileName]
    if verboseFlag:
        print ' '.join(cmd)
    subprocess.check_call(cmd);
    orderedSweepFileName = orderInputs(sweepFileName)
    
    return orderedSweepFileName  

def orderInputs(sweepFileName):
    ext = '-sweep.blif'
    basename = sweepFileName[:-len(ext)]
    assert sweepFileName.endswith(ext)
    assert basename
    
    orderedSweepFileName = basename + "-sweep-ordered.blif"
    paramFileName = basename + ".par"
    
    # read parameter.par
    paramInputs = list()
    regularInputs = list()
    tempList = list()
    for line in file(paramFileName):
        line = line.rstrip('\n')
        paramInputs.append(line)
    
    
    new_file = open(orderedSweepFileName,'w')
    old_file = open(sweepFileName)
    var = 0
    for line in old_file:
        if ('.outputs' in line):
            var = 0
            tempList = list()
            tempList.extend(regularInputs)
            tempList.extend(paramInputs)
            new_file.write('.inputs ')
            # write first line
            while(len(tempList) != 0):
               if (len(tempList) > 5):
                   newLine = ''
                   for i in range(0, 5):
                       newLine = newLine + ' ' + tempList.pop(0)
                   new_file.write(newLine + ' \\' + '\n')
               elif (len(tempList) == 5):
                   newLine = ''
                   for i in range(0, 5):
                       newLine = newLine + ' ' + tempList.pop(0)
                   new_file.write(newLine + '\n')
               else:
                   newLine = ''
                   while (len(tempList) != 0):
                       newLine = newLine + ' ' + tempList.pop(0)
                   new_file.write(newLine + '\n')
            # write .outputs line
            new_file.write(line)
        elif ('.inputs' in line) or (var == 1):
           if ('.inputs' in line):
               var = 1
           line = line.rstrip('\n').rstrip('\\').strip();
           tempList = line.split(' ')
           for item in tempList:
               if ((item in paramInputs) == 0) and item != '.inputs' :
                   regularInputs.append(item)
        else:
           new_file.write(line)
    new_file.close()
    old_file.close()
    
    return orderedSweepFileName