import os
import sys
import commands
import subprocess
import re
from itertools import islice


maxMemory = 1024
#set maximum memory usage of Java tools, in MB
def setMaxMemory(mm):
    global maxMemory
    assert isinstance(mm,int)
    maxMemory = mm

def simpleMapper(basename, fname, K, checkFunctionality,verboseFlag=False):
    try:
        ext = fname.split('.')[-1]
        basefname = fname[:-len(ext)-1]
        assert ext
        assert basename
        
        blifFile = basefname + ".blif"
        aigFile  = basefname + ".aig"
        aagFile  = basefname + ".aag"
        outFile =  basename + "-simple.blif"
        
        if ext == 'blif':
            subprocess.check_call(['abc', '-c', 'strash; write '+aigFile, blifFile])
            subprocess.check_call(['aigtoaig', aigFile, aagFile])
        elif ext == 'aig':
            subprocess.check_call(['aigtoaig', aigFile, aagFile])
        elif ext == 'aag':
            subprocess.check_call(['aigtoaig', aagFile, aigFile])
        
        if not os.path.exists(aagFile):
            print >> sys.stderr, 'Error: missing input file: %s'%aagFile
            exit(3)
        
        # Actual mapping using Java tool
        cmd  = ['java','-server','-Xms%dm'%maxMemory,'-Xmx%dm'%maxMemory,'be.ugent.elis.recomp.mapping.simple.SimpleMapper']
        # args: input aag file, inputs per LUT, output blif file
        args = [aagFile, str(K), outFile]
        if verboseFlag:
            print ' '.join(cmd + args)
        output = subprocess.check_output(cmd + args)
        if verboseFlag:
            print output
        
        # Extracting results
        data = output.splitlines()[-1].split()
        numLuts = int(data[0])
        depth   = int(float(data[1]))
        
        # Verification of resulting mapping using satsolver
        if checkFunctionality:
            check = miter(aigFile, outFile, verboseFlag)
        else:
            check = "SKIPPED"
    except subprocess.CalledProcessError as e:
        print >> sys.stderr, e
        #raise
        exit(2)
    return (numLuts, depth, check)

def simpleTMapper(basename, fname, paramFileName, K, checkFunctionality, generateImplementationFilesFlag, verboseFlag=False):
    try:
        ext = fname.split('.')[-1]
        basefname = fname[:-len(ext)-1]
        assert basename, fname
        assert ext, fname
        
        blifFile = basefname + ".blif"
        aigFile  = basefname + ".aig"
        aagFile  = basefname + ".aag"
        
        if ext == 'blif':
            subprocess.check_call(['abc', '-c', 'strash; write '+aigFile, blifFile])
            subprocess.check_call(['aigtoaig', aigFile, aagFile])
        elif ext == 'aig':
            subprocess.check_call(['aigtoaig', aigFile, aagFile])
        elif ext == 'aag':
            subprocess.check_call(['aigtoaig', aagFile, aigFile])
        else:
            assert ext in ('blif','aig','aag')
            
        outFile =  'dummy' #basename + "-simpletmap.blif"
        parconfFile = basename + "-parconfig.aag"
        lutstructFile = basename + "-lutstruct.blif"
        vhdFile = basename + ".vhd"
        outVhdFile = basename + "-simpletmap.vhd"
        nameFile= "names.txt"
        requiredFiles = [aagFile]
        if generateImplementationFilesFlag: requiredFiles.append(vhdFile)
        for f in requiredFiles:
            if not os.path.exists(f):
                print >> sys.stderr, 'Error: missing input file: %s'%f
                exit(3)
        
        # Using TMAP to map the circuit
        cmd  = ['java','-server','-Xms%dm'%maxMemory,'-Xmx%dm'%maxMemory,'be.ugent.elis.recomp.mapping.tmapSimple.TMapSimple']
        # args: input aag of design, input file with parameters, number of inputs per LUT, unused, output parameterised configuration bits as aag, output lutstructure as blif, optional: input vhdl to copy header from, output vhdl with lutstructure
        args = [aagFile, paramFileName, str(K), outFile, parconfFile, lutstructFile]
        if generateImplementationFilesFlag: args.extend([vhdFile, outVhdFile, nameFile])
        if verboseFlag:
            print ' '.join(cmd + args)
        output = subprocess.check_output(cmd + args)
        if verboseFlag:
            print output
        
        # Extracting results
        data = output.splitlines()[-1].split()
        try:
            numLuts = int(data[0])
            depth   = int(float(data[1]))
            numTLuts =  int(data[2])
            avDup = float(data[3])
        except (ValueError, IndexError):
            if not verboseFlag:
                print ' '.join(cmd + args)
                print output,
            print >> sys.stderr, "Error: unexpected output from java TMapSimple."
            exit(2)
        
        # Extracting results
        cmd = ['abc','-c','resyn3; print_stats',aagtoaig(aagFile)]
        output = subprocess.check_output(cmd)
        if verboseFlag:
            print ' '.join(cmd)
            print output,
        try:
            res = re.search(r'\band\s*=\s*(?P<origAnds>\d+)\b',output.splitlines()[-1])
            if not res: raise ValueError
            origAnds = int(res.group('origAnds'))
        except (ValueError, IndexError):
            if not verboseFlag:
                print ' '.join(cmd)
                print output,
            print >> sys.stderr, "Error: unexpected output from abc print_stats (1)."
            exit(2)
    
    
        # Extracting results: Parameterizable Configuration
        cmd = ['abc','-c','resyn3; print_stats',aagtoaig(parconfFile)]
        output = subprocess.check_output(cmd)
        if verboseFlag:
            print ' '.join(cmd)
            print output,
        try:
            res = re.search(r'\band\s*=\s*(?P<paramAnds>\d+)\b',output.splitlines()[-1])
            if not res: raise ValueError
            paramAnds = int(res.group('paramAnds'))
        except (ValueError, IndexError):
            if not verboseFlag:
                print ' '.join(cmd)
                print output,
            print >> sys.stderr, "Error: unexpected output from abc print_stats (2)."
            exit(2)
        
        # Verification of resulting mapping using satsolver
        if checkFunctionality:
            # Merging the LUT-structure and the parameterizable configuration.
            mergedFile =  basename + "-merge.aag"
            cmd  = ['java',
                        '-server',
                        '-Xms%dm'%maxMemory,
                        '-Xmx%dm'%maxMemory,
                        'be.ugent.elis.recomp.aig.MergeAag']
            # args: input parameterized configuration in aag, input lut structure, output aag
            args = [parconfFile, bliftoaag(lutstructFile), mergedFile]
            if verboseFlag:
                print ' '.join(cmd + args)
            output = subprocess.check_output(cmd + args);
        
            # Check if the merge of the LUT-structure and the parameterizable 
            # configuration have the same functionality as the input circuit.    
            mergedAigFile = aagtoaig(mergedFile)
            check = miter(aigFile, mergedAigFile, verboseFlag)
        else:
            check = "SKIPPED"
    except subprocess.CalledProcessError as e:
        print >> sys.stderr, e
        #raise
        exit(2)
    return (numLuts, numTLuts, depth, avDup, origAnds, paramAnds, check)    

def fpgaMapper(basename, fname, K, checkFunctionality, verboseFlag=False):
    try:
        ext = '.blif'
        assert fname.endswith(ext)
        assert basename
        inFile = fname
        outFile =  basename + "-fpga.blif"
        
        cmd = ['abc', '-c', 'strash; fpga -K '+str(K)+'; write '+outFile+'; print_stats', inFile]
        if verboseFlag:
            print cmd
        output = subprocess.check_output(cmd)
        if verboseFlag:
            print output
        
        try:
            res = re.search(r'\bnd\s*=\s*(?P<numLuts>\d+)\b.*\blev\s*=\s*(?P<depth>\d+)\b',output)
            if not res: raise ValueError
            numLuts = int(res.group('numLuts'))
            depth   = int(res.group('depth'))
        except (ValueError, IndexError) as e:
            if not verboseFlag:
                print cmd
                print output
            print >> sys.stderr, "Error: unexpected output from abc print_stats (3)."
            exit(2)
        if checkFunctionality:
            check   = miter(inFile, outFile, verboseFlag)
        else:
            check = "SKIPPED"
    except subprocess.CalledProcessError as e:
        print >> sys.stderr, e
        #raise
        exit(2)
    return (numLuts, depth, check)

def aagtoaig(aagFileName):
    ext = '.aag'
    basename = aagFileName[:-len(ext)]
    aigFileName = basename + '.aig'
    assert aagFileName.endswith(ext)
    assert aigFileName
    os.system("rm -f "+aigFileName)
    subprocess.check_call(['aigtoaig',aagFileName,aigFileName])
    if not os.path.exists(aigFileName):
        print >> sys.stderr, "Error: aigtoaig unsuccesful, file %s was not created"%aigFileName
        exit(3)
    return aigFileName

def aigtoaag(aigFileName):
    ext = '.aig'
    basename = aigFileName[:-len(ext)]
    aagFileName = basename + '.aag'
    assert aigFileName.endswith(ext)
    assert aagFileName
    os.system("rm -f "+aagFileName)
    subprocess.check_call(['aigtoaig',aigFileName,aagFileName])
    if not os.path.exists(aagFileName):
        print >> sys.stderr, "Error: aigtoaag unsuccesful, file %s was not created"%aagFileName
        exit(3)
    return aagFileName
 
def bliftoaag(blifFileName):
    ext = '.blif'
    basename = blifFileName[:-len(ext)]
    aigFileName = basename + '.aig'
    assert blifFileName.endswith(ext)
    assert basename

    # There seems to be a bug in bliftoaig when input file is large.
    # subprocess.check_call(['bliftoaig',blifFileName,basename+'.aag'])
    # return basename+'.aag'

    os.system("rm -f "+aigFileName)
    cmd = ['abc', '-c', 'strash; zero; write '+aigFileName, blifFileName]
    subprocess.check_call(cmd)
    if not os.path.exists(aigFileName):
        print >> sys.stderr, "Error: bliftoaig unsuccesful, file %s was not created"%aigFileName
        exit(3)
    print 'Please ignore the error message "Error: The current network is combinational".'
    
    aagFileName = aigtoaag(aigFileName)
    return aagFileName

def miter(circuit0, circuit1, verboseFlag=False):
    cmd = ['abc', '-c', 'miter ' + circuit0 + ' ' + circuit1 + '; prove']
    if verboseFlag:
        print ' '.join(cmd)
    try:
        output = subprocess.check_output(cmd,stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as ex:
        print >> sys.stderr, ex.output
        print >> sys.stderr, 'Error: verification failed'
        exit(2)
    if verboseFlag:
        print output,
    if "UNSATISFIABLE" in output:
        return "PASSED"
    elif " SATISFIABLE" in output:
        return "FAILED"
    else:
        if not verboseFlag:
            print ' '.join(cmd)
            print output,
        print >> sys.stderr, "Error: unexpected output from miter computation (verification)"
        exit(2)
    
def synthesize(top, submodules, verboseFlag=False):
    ext = top.split('.')[-1].lower()
    basename = top[:-len(ext)-1]
    assert basename

    qsfFileName = basename + ".qsf"
    with open(qsfFileName, "w") as fout:
        if ext in ('vhd','vhdl'):
            fout.write('set_global_assignment -name VHDL_FILE ' + top + '\n')
        else:
            fout.write('set_global_assignment -name VERILOG_FILE ' + top + '\n')
        for file in submodules:
            if file.split('.')[-1].lower() in ('vhd','vhdl'):
                fout.writelines('set_global_assignment -name VHDL_FILE ' + file + '\n')
            else:
                fout.write('set_global_assignment -name VERILOG_FILE ' + file + '\n')
    
        fout.write('set_global_assignment -name FAMILY Stratix\n');
        fout.write('set_global_assignment -name TOP_LEVEL_ENTITY ' + basename + '\n');
        fout.write('set_global_assignment -name DEVICE_FILTER_SPEED_GRADE FASTEST\n');
    
        fout.write('set_global_assignment -name INI_VARS \"no_add_ops=on\;opt_dont_use_mac=on\;dump_blif_after_lut_map=on\;abort_after_dumping_blif=on\"\n');
    
        fout.write('set_global_assignment -name DEVICE AUTO\n');
        fout.write('set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1\n');


    cmd = 'quartus_map ' + qsfFileName
    if verboseFlag:
        print cmd
    output = commands.getoutput(cmd);
    print output
    if output.find(' 0 errors')==-1:
        print >> sys.stderr, 'Error: quartus_map unsuccesful'
        exit(3)
    print 'Please ignore the error message "Error: Quartus II Analysis & Synthesis was unsuccessful" if 0 errors and 0 warnings are found.'
    
    blifFileName  = basename + ".blif"
    sweepFileName = basename + "-sweep.blif"
    cmd = ['abc', '-c', 'sweep', '-o', sweepFileName, '-t', 'blif', '-T', 'blif', blifFileName]
    if verboseFlag:
        print ' '.join(cmd)
    subprocess.check_call(cmd);
    
    return sweepFileName

def group_per(iterable,n):
    for i in xrange(0,len(iterable),n):
        yield islice(iterable,i,i+n)
    
def printCFunction(aagFileName,CFileName,headerFileName,verboseFlag=False):
    cmd  = ['java','-server','-Xms%dm'%maxMemory,'-Xmx%dm'%maxMemory,'be.ugent.elis.recomp.aig.MakeCEvaluator']
    args = [aagFileName, CFileName, headerFileName]
    if verboseFlag:
    	print ' '.join(cmd +args)
    output = subprocess.check_output(cmd + args);
    if verboseFlag:
    	print output
