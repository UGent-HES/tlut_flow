import os;
import sys;
import commands;

def simpleMapper(classPath, path, fname,K, checkFunctionality):
#    ext = '.blif'
#    basename = fname[:-len(ext)]
#    blifFile = path + "/" + fname
#    aigFile = basename + ".aig"
#    aagFile = basename + ".aag"
#    outFile =  basename + "-simple.blif"
#    
#    output = commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
#    output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)

    ext = fname.split('.')[1]
    basename = fname.split('.')[0]
    
    blifFile = path + "/" + basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    outFile =  basename + "-simple.blif"
    
    if ext == 'blif':
        output = commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aig':
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aag':
        output = commands.getoutput('aigtoaig '+ aagFile +' '+ aigFile)
    
    cmd  = 'java -server -Xms1024m -Xmx2048m -cp ' + classPath + ' be.ugent.elis.recomp.mapping.simple.SimpleMapper '
    args = aagFile + ' ' + str(K) +' ' + outFile
    output = commands.getoutput(cmd + args);

    print output
    
    data = output.splitlines()[-1].split()
    numLuts = float(data[0])
    depth   = float(data[1])
    
    if checkFunctionality:
        check   = miter(aigFile, outFile)
    else :
        check = "SKIPPED"
    return (numLuts, depth, check)

def simpleTMapper(classPath, path, fname, paramFileName, K, checkFunctionality):
    
    ext = fname.split('.')[1]
    basename = fname.split('.')[0]
    
    blifFile = basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    
    if ext == 'blif':
        output = commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aig':
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aag':
        output = commands.getoutput('aigtoaig '+ aagFile +' '+ aigFile)
        
    outFile =  basename + "-simpletmap.blif"
    parconfFile = basename + "-parconfig.aag"
    lutstructFile = basename + "-lutstruct.blif"
    vhdFile = basename[:-len('-sweep-ordered')] + ".vhd"
    
    # Using TMAP to map the circuit
    cmd  = 'java -server -Xms1024m -Xmx2048m -cp ' + classPath + ' be.ugent.elis.recomp.mapping.tmapSimple.TMapSimple '
    args = aagFile+ ' ' + paramFileName + ' ' + str(K) + ' ' + outFile + ' ' + parconfFile + ' ' + lutstructFile + ' ' + vhdFile
    print cmd + args
    output = commands.getoutput(cmd + args);
    
    print output
    
    
    data = output.splitlines()[-1].split()
    numLuts = float(data[0])
    depth   = float(data[1])
    numTLuts =  float(data[2])
    avDup = float(data[3])
    
    # Parameterizable Configuration
    cmd = 'abc -c \'resyn3; print_stats;\' ' + aagtoaig(aagFile)
    print cmd
    output = commands.getoutput(cmd);
    print output
    data = output.splitlines()[-1].split()
    print data
    origAnds = float(data[data.index('and')+2])
                
    cmd = 'abc -c \'resyn3; print_stats;\' ' + aagtoaig(parconfFile)
    output = commands.getoutput(cmd);
    data = output.splitlines()[-1].split()
    print data
    paramAnds = float(data[data.index('and')+2])
    
    if checkFunctionality:
        # Merging the LUT-structure and the parameterizable configuration.
        mergedFile =  basename + "-merge.aag"
        cmd  = 'java -cp ' + classPath + ' be.ugent.elis.recomp.aig.MergeAag '
        print cmd
        args = parconfFile + ' ' + bliftoaag(lutstructFile) + ' ' + mergedFile
        output = commands.getoutput(cmd + args);
        print output
    
        # Check if the merge of the LUT-structure and the parameterizable 
        # configuration have the same functionality as the input circuit.    
        mergedAigFile = aagtoaig(mergedFile)
        check = miter(aigFile,mergedAigFile)
    else :
        check = "SKIPPED"
    
    
    return (numLuts, numTLuts, depth, avDup, origAnds, paramAnds, check)

def simpleTMapper2(classPath, path, fname, paramFileName, K, checkFunctionality, inVhdFile):
    
    ext = fname.split('.')[1]
    basename = fname.split('.')[0]
    
    blifFile = basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    
    if ext == 'blif':
        output = commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aig':
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aag':
        output = commands.getoutput('aigtoaig '+ aagFile +' '+ aigFile)
        
    outFile =  basename + "-simpletmap.blif"
    parconfFile = basename + "-parconfig.aag"
    lutstructFile = basename + "-lutstruct.blif"
    
    
    # Using TMAP to map the circuit
    cmd  = 'java -server -Xms1024m -Xmx2048m -cp ' + classPath + ' be.ugent.elis.recomp.mapping.tmapSimple.TMapSimple '
    args = aagFile+ ' ' + paramFileName + ' ' + str(K) + ' ' + outFile + ' ' + parconfFile + ' ' + lutstructFile + ' ' + inVhdFile 
    output = commands.getoutput(cmd + args);
    
    print output
    
    data = output.splitlines()[-1].split()
    numLuts = float(data[0])
    depth   = float(data[1])
    
    if checkFunctionality:
        # Merging the LUT-structure and the parameterizable configuration.
        mergedFile =  basename + "-merge.aag"
        cmd  = 'java -cp ' + classPath + ' be.ugent.elis.recomp.aig.MergeAag '
        args = parconfFile + ' ' + bliftoaag(lutstructFile) + ' ' + mergedFile
        output = commands.getoutput(cmd + args);
    
        # Check if the merge of the LUT-structure and the parameterizable 
        # configuration have the same functionality as the input circuit.    
        mergedAigFile = aagtoaig(mergedFile)
        check = miter(aigFile,mergedAigFile)
    else :
        check = "SKIPPED"
    
    
    return (numLuts, depth, check)

def simpleTIMapper(classPath, path, fname, paramFileName):
    ext = '.blif'
    basename = fname[:-len(ext)]
    blifFile = path + "/" + fname
    aigFile = basename + ".aig"
    aagFile = basename + ".aag"
    outFile =  basename + "-simpletmap.blif"
    parconfFile = basename + "-parconfig.aag"
    lutstructFile = basename + "-lutstruct.blif"
    
    commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
    commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    
    cmd  = 'java -cp ' + classPath + ' be.ugent.elis.recomp.mapping.imap.TIMAP '
    args = aagFile+ ' ' + paramFileName + ' 4 ' + outFile + ' ' + parconfFile + ' ' + lutstructFile
    output = commands.getoutput(cmd + args);
     
    numLuts = float(output.split()[0])
    depth   = float(output.split()[1])
    
    mergedFile =  basename + "-merge.aag"
    cmd  = 'java -cp ' + classPath + ' be.ugent.elis.recomp.aig.MergeAag '
    #args = parconfFile + ' ' + bliftoaag(lutstructFile) + ' ' + mergedFile
    args = parconfFile + ' ' + basename + "-lutstruct.aag" + ' ' + mergedFile
    commands.getoutput(cmd + args);
    
    mergedAigFile = aagtoaig(mergedFile)
    check = miter(fname,mergedAigFile)
    
    return (numLuts, depth, check)


def abcTMapper (path, fname, paramFileName):
    ext = fname.split('.')[1]
    basename = fname.split('.')[0]
    
    blifFile = basename + ".blif"
    aigFile  = basename + ".aig"
    aagFile  = basename + ".aag"
    

    # Creates at least aag and aig
    if ext == 'blif':
        output = commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aig':
        output = commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    elif ext == 'aag':
        output = commands.getoutput('aigtoaig '+ aagFile +' '+ aigFile)

    tmapFile = basename + '-tmap.blif'
    abc = '~/recomp/tools/abc/trunk/abc'
    
    commands.getoutput('cp ' + path + "/" + paramFileName + ' '  + path + "/parameters.par")
    output = commands.getoutput(abc + ' -c \'tmap2; print_stats\' -o '+ tmapFile + ' ' + aigFile)
    
    numLuts = float(output.split()[-7])
    depth   = float(output.split()[-1])
    
    check = miter(aigFile, tmapFile)
    return (numLuts, depth,check)
    
    

def aagtoaig(aagFileName):
    ext = '.aag'
    basename = aagFileName[:-len(ext)]
    aigFileName = basename + '.aig'
    commands.getoutput('aigtoaig '+ aagFileName +' '+ aigFileName)
    return aigFileName

def aigtoaag(aigFileName):
    ext = '.aig'
    basename = aigFileName[:-len(ext)]
    aagFileName = basename + '.aag'
    commands.getoutput('aigtoaig '+ aigFileName +' '+ aagFileName)
    return aagFileName

    
def bliftoaag(blifFileName):
    ext = '.blif'
    basename = blifFileName[:-len(ext)]
    aigFileName = basename + '.aig'

    # There seems to be a bug in bliftoaig when input file is large.
#    commands.getoutput('bliftoaig '+ blifFileName +' '+ aagFileName)

    #output = commands.getoutput('abc -c \'strash; zero; write '+aigFileName+'\' ' + blifFileName)
    output = commands.getoutput('abc -c \'strash; write '+aigFileName+'\' ' + blifFileName)
    print 'abc -c \'strash; zero; write '+aigFileName+'\' ' + blifFileName + output
    

    aagFileName = aigtoaag(aigFileName)
    

    return aagFileName

def imapMapper(classPath, path, fname):
    ext = '.blif'
    basename = fname[:-len(ext)]
    blifFile = path + "/" + fname
    aigFile = basename + ".aig"
    aagFile = basename + ".aag"
    outFile =  basename + "-imap.blif"
    
    commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + blifFile)
    commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)
    
    cmd  = 'java -cp ' + classPath + ' be.ugent.elis.recomp.mapping.imap.IMAP '
    args = aagFile + ' 4 ' + outFile
    output = commands.getoutput(cmd + args);
    
    numLuts = float(output.split()[0])
    depth   = float(output.split()[1])
    check   = miter(blifFile, outFile)
    return (numLuts, depth, check)

def fpgaMapper(path, fname):
    ext = '.blif'
    basename = fname[:-len(ext)]
    inFile = path + "/" + fname
    outFile =  basename + "-fpga.blif"
    
    cmd = 'abc -c \'strash; fpga; print_stats; write '+outFile+'\' ' + inFile
    output = commands.getoutput(cmd);
    
#    print output
    
    numLuts = float(output.split()[-10])
    depth   = float(output.split()[-1])
    check   = miter(inFile, outFile)
    return (numLuts, depth, check)
    
def miter(circuit0, circuit1 ):
    cmd = 'abc -c \'miter ' + circuit0 + ' ' + circuit1 + '; prove\''
    output = commands.getoutput(cmd)
    if "UNSATISFIABLE" in output:
        return "PASSED"
    else:
        return "FAILED"
    
def synthesize(top, submodules):
    ext = '.vhd'
    basename = top[:-len(ext)]
    assert basename
    currentFileName = basename+'.vhd'
    commands.getoutput('cp '+ top +' '+ currentFileName)

    
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
    output = commands.getoutput(cmd);
    print output
    
    blifFileName  = basename + ".blif"
    sweepFileName = basename + "-sweep.blif"
    orderedSweepFileName = basename + "-sweep-ordered.blif"
    cmd = 'abc -c sweep -o ' + sweepFileName + ' -t blif -T blif ' + blifFileName
    output = commands.getoutput(cmd);
    orderedSweepFileName = orderInputs(sweepFileName)
    
    return orderedSweepFileName  

def orderInputs(sweepFileName):

   ext = '-sweep.blif'
   basename = sweepFileName[:-len(ext)]
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