#!/usr/bin/env python

import sys, glob, os, unittest, shutil, random, itertools, re
from mapping import *
from genParameters import extract_parameter_signals, extract_parameter_names 

workDirBase="work_VhdlGeneration"
colwidth=16
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

#Warning: Every run of VhdlGenerationTest tests a different random combination of parameter values
class VhdlGenerationTest(unittest.TestCase):
    def test_test1(self):
        self.build('test1/test1.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
        
    def test_test2(self):
        self.build('test2/test2.vhd', [], K=6, virtexFamily='virtex5', containsLatches=True, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
    
    def test_test3(self):
        self.build('test3/test3.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_test4(self):
        self.build('test4/test4.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_const(self):
        self.build('const/const.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_vector(self):
        self.build('vector/vector.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_matrix(self):
        self.build('matrix/matrix.vhd', ['matrix/matrix_type_pkg.vhd'], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
    
    @unittest.expectedFailure
    def test_matrix2(self):
        self.build('matrix2/matrix2.vhd', ['matrix2/matrix_type_pkg.vhd'], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    @unittest.skip('The toolflow currently can\'t handle reset signals') 
    def test_sbox(self):
        self.build('sbox/sbox.vhd', ['sbox/aes_pkg.vhd'], K=6, virtexFamily='virtex5', containsLatches=True, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
        
    def test_rom_noparam(self):
        self.build('rom/rom.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False, parameterFileName='empty.par')

    @unittest.skip('Out of memory: to fix') 
    def test_rom(self):
        self.build('rom/rom.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
        
    def test_fir_noparam(self):
        self.build('FIRTree32Tap8Bit/firTree32tap.vhd', ['FIRTree32Tap8Bit/mult8bit.vhd', 'FIRTree32Tap8Bit/treeMult4b.vhd'], K=4, virtexFamily='virtex2pro', containsLatches=True, resynthesizeFlag=False, targetDepth=None, verboseFlag=False, parameterFileName='empty.par')
    
    def test_fir(self):
        self.build('FIRTree32Tap8Bit/firTree32tap.vhd', ['FIRTree32Tap8Bit/mult8bit.vhd', 'FIRTree32Tap8Bit/treeMult4b.vhd'], K=6, virtexFamily='virtex5', containsLatches=True, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_treeMult4b(self):
        self.build('treeMult4b/treeMult4b.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    
    def setUp(self):
        self.ret_pwd = os.getcwd()
        self.stdout = sys.stdout
        self.stderr = sys.stderr
        setMaxMemory(4000)
        
    def tearDown(self):
        os.chdir(self.ret_pwd)
        sys.stdout = self.stdout
        sys.stderr = self.stderr
        
    def build(self, module, submodules, K, virtexFamily, containsLatches, resynthesizeFlag, targetDepth, verboseFlag, parameterFileName=None, extraArgs=[]):
        if not verboseFlag:
            sys.stdout = open(os.devnull, 'w')
            sys.stderr = sys.stdout
        performCheck = True
        generateImplementationFilesFlag = True
    
        baseName, ext = getBasenameAndExtension(os.path.basename(module))
    
        # First part: generate vhdl
    
        # Setup working directory
        workDir = workDirBase + "/" + baseName
        if verboseFlag:
            print "Stage: Creating %s directory and copying design"%workDir
        workFiles = [module] + submodules
        if parameterFileName: workFiles.append(parameterFileName)
        try:
            shutil.rmtree(workDir)
        except:
            pass
        createWorkDirAndCopyFiles(workDir, workFiles)
    
        os.chdir(workDir)
    
        # Synthesis
        if verboseFlag:
            print "Stage: Synthesizing"
        qsfFileName = generateQSF(module, submodules)
        blifFileName = synthesize(module, qsfFileName, verboseFlag)
    
        # Automatically extract parameters from VHDL
        if verboseFlag:
            print "Stage: Generating parameters"
        if parameterFileName == None:
            parameterFileName = baseName+'.par'
            with open(parameterFileName, "w") as parameterFile:
                parameter_names = extract_parameter_names(module)
                parameter_signals = extract_parameter_signals(parameter_names, blifFileName)
                print >>parameterFile, '\n'.join(parameter_signals)
        if verboseFlag:
            print "Parameters:"
            os.system('cat %s'%parameterFileName)
        
        # Resynthesize blif (and convert to aag)
        if resynthesizeFlag:
            aagFileName = resynthesize(baseName, blifFileName)
        else:
        # Convert blif to aag
            aagFileName = toaag(blifFileName)
    
        # Unleash TLUT mapper
        if verboseFlag:
            print "Stage: TLUT mapper"
        numLuts, numTLUTs, numTCONs, depth, avDup, origAnds, paramAnds, check = \
            simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, generateImplementationFilesFlag, module, verboseFlag, extra_args = extraArgs)
        self.assertEqual(check, 'PASSED', 'lutstruct+parconfig equivalence check failed')
        if verboseFlag:
            print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
            print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
            
        # Second part: verify generated VHDL
    
        # Verifying generated VHDL
        if verboseFlag:
            print "Starting verification of generated VHDL"
        os.chdir(self.ret_pwd)
    
        # Setup working directory
        verificationWorkDir = workDirBase + "/" + baseName + "_vhd_check"
        if verboseFlag:
            print "Stage: Creating %s directory and copying design"%verificationWorkDir
        verificationModule = "%s.vhd"%baseName
        verificationSubModules = glob.glob('primitives/*.vhd') + submodules
        verificationWorkFiles = glob.glob('primitives/*')  + submodules
        try:
            shutil.rmtree(verificationWorkDir)
        except:
            pass
        createWorkDirAndCopyFiles(verificationWorkDir, verificationWorkFiles)
        
        namesFileName = "%s-names.txt"%baseName
        lutstructFileName = '%s-lutstruct.aag'%baseName
        parconfigFileName = '%s-parconfig.aag'%baseName
        shutil.copy("%s/%s"%(workDir, namesFileName), verificationWorkDir)
        shutil.copy("%s/%s"%(workDir, lutstructFileName), verificationWorkDir)
        shutil.copy("%s/%s"%(workDir, parconfigFileName), verificationWorkDir)
        shutil.copy("%s/%s"%(workDir, parameterFileName), verificationWorkDir)

        # Copy vhdl and remove some attributes from vhdl file that quartus can't handle
        assert not os.system('pcregrep -v -e "^attribute lock_pins" -e "^attribute INIT" %s > %s'%(workDir+"/%s-simpletmap.vhd"%baseName, verificationWorkDir+"/"+verificationModule))

        os.chdir(verificationWorkDir)
        
        tlutNames = readTLUTnames(namesFileName)
        tlutNames.sort()
        paramNames = readParamNames(parameterFileName)
        
        # Generate configuration.vhd
        configurationFileName = 'configuration.vhd'
        generateVhdConfiguration(baseName, tlutNames, open(configurationFileName, 'w'))
        verificationSubModules.append(configurationFileName)
    
        # Verification
        parvaluationFileName = '%s-parvaluation.aag'%baseName
        evaluatedlutconfigFileName = '%s-evaluatedlutconfig.aag'%baseName
        baseFileName = '%s-evaluatedlutstruct.aag'%baseName

        # create a random param valuation aig
        generateParamValuation(parvaluationFileName, paramNames)
        # evaluate the lutconfiguration using these parameter values
        mergeaag(parvaluationFileName, parconfigFileName, evaluatedlutconfigFileName, verboseFlag)
        # use this lutconfiguration with the lutstruct
        mergeaag(evaluatedlutconfigFileName, lutstructFileName, baseFileName, verboseFlag)

        # use the same lutconfiguration to generate configured lut vhdl implementations
        tlutConfigurations = extractTLUTConfigurations(evaluatedlutconfigFileName, tlutNames)
        os.mkdir('tluts')
        for tlutName in tlutNames:
            verificationSubModules.append(generateEvaluatedTLUT(tlutName, getTLUTConfiguration(tlutName, tlutConfigurations)))

        # Synthesis
        if verboseFlag:
            print "Stage: Synthesizing"
        qsfFileName = generateQSF(verificationModule, verificationSubModules)
        verificationBlifFileName = synthesize(verificationModule, qsfFileName, verboseFlag)
        
        if containsLatches:
            check = sequentialMiter(verificationBlifFileName, baseFileName, verboseFlag)
        else:
            check = miter(verificationBlifFileName, baseFileName, verboseFlag)
        self.assertEqual(check, 'PASSED', 'vhdl equivalence check failed')


def readTLUTnames(filename):
    stream = open(filename, 'r')
    names = stream.readlines()
    stream.close()
    names = map(lambda s:s.strip('\n\r'), names)
    names = filter(bool, names)
    return names
    
    
def readParamNames(filename):
    stream = open(filename, 'r')
    names = stream.readlines()
    stream.close()
    names = map(lambda s:s.strip('\n\r'), names)
    names = filter(bool, names)
    return names
    

def generateParamValuation(paramconfigFileName, paramNames):
    stream = open(paramconfigFileName, 'w')
    print >>stream, 'aag %d 0 0 %d 0'%(len(paramNames), len(paramNames))
    for param in paramNames:
        print >>stream, random.randint(0, 1)
    for literal, param in enumerate(paramNames):
        print >>stream, 'o%d %s'%(literal, param)


def extractTLUTConfigurations(evaluatedlutconfigFileName, tlutNames):
    stream = open(evaluatedlutconfigFileName, 'r')
    elms = stream.readline().split()
    assert elms[0] == 'aag'
    ninputs = int(elms[1])
    nlatches = int(elms[3])
    assert nlatches == 0
    noutputs = int(elms[4])
    assert noutputs == len(tlutNames) * 64
    nands = int(elms[5])
    assert nands == 0
    
    #skip inputs
    for _ in xrange(ninputs):
        stream.readline()
    
    values = []
    for _ in xrange(noutputs):
        values.append(int(stream.readline()))
   
    #read the names of the outputs in the form of:
    #o12 shortlutname_1
    lines = stream.readlines()
    lines = itertools.dropwhile(lambda s:not s.startswith('o'), lines)
    lines = itertools.takewhile(lambda s:s.startswith('o'), lines)
    lines = itertools.imap(lambda s:s.split()[-1], lines) #drop the o12
    lines = itertools.imap(lambda s:s.rsplit('_', 1), lines) #split shortlutname from 1 (lutconfig index)
    lines = itertools.imap(lambda (n,i):(n,int(i)), lines)
    lines = list(lines)
    assert len(lines) == noutputs
    
    values = zip(lines, values)
    
    convert = lambda text: int(text) if text.isdigit() else text.lower() 
    alphanum_key = lambda ((a, b), c): [ convert(c) for c in re.split('([0-9]+)', a) ] + [ b ]
    values.sort(key=alphanum_key)
    
    n = 64
    ret = dict()
    for tlutName, i in zip(tlutNames, range(0, len(values), n)):
        lutvalues = values[i:i + n]
        assert all(map(lambda s: s[0][0]==lutvalues[0][0][0], lutvalues))
        ret[lutvalues[0][0][0]] = map(lambda e:e[1], lutvalues)
    
    return ret
    

def getTLUTConfiguration(tlutName, tlutConfigurations):
    for shortTlutName, tlutConfiguration in tlutConfigurations.items():
        if tlutName.endswith(shortTlutName):
            return tlutConfiguration
    assert False
    

def generateVhdConfiguration(baseName, tlutNames, stream):
    print >>stream, "configuration tlut_configuration of %s is"%baseName
    print >>stream, "for rtl"
    for tlutName in tlutNames:
        print >>stream, "    for %s : LUT6_2 use entity work.LUT6_2(%s); end for;"% \
            (tlutName, tlutName)
    print >>stream, "end for;"
    print >>stream, "end configuration tlut_configuration;"


def generateEvaluatedTLUT(tlutName, config):
    assert len(config) == 64
    assert not os.system('sed -e "s/####/%s/" -e "s/&&&&/%s/" "%s" > "%s"'% \
        (''.join(map(str, config)), tlutName, 'primitives/LUT6_2_template.vhd_templ', 'tluts/LUT6_2_%s.vhd'%tlutName))
    return 'tluts/LUT6_2_%s.vhd'%tlutName


def main():
    #CompileTest().build()
    unittest.main()

if __name__=="__main__":
    main()
