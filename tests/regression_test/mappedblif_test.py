#!/usr/bin/env python

import sys, glob, os, unittest, shutil
from mapping import *
from genParameters import extract_parameter_signals, extract_parameter_names 

workDirBase="work_MappedBlif"
colwidth=16
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])


class MappedBlifTest(unittest.TestCase):
    def test_test1(self):
        self.build('test1/test1.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
        
    def test_test2(self):
        self.build('test2/test2.vhd', [], K=6, virtexFamily='virtex5', containsLatches=True, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
    
    def test_test3(self):
        self.build('test3/test3.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_test4(self):
        self.build('test4/test4.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_tcon(self):
        self.build('tcon/tcon.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False, extraArgs=['--tcon'])

    def test_tlc(self):
        self.build('tlc/tlc.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False, extraArgs=['--tcon', '--tlc'])

    def test_const(self):
        self.build('const/const.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_vector(self):
        self.build('vector/vector.vhd', [], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)

    def test_matrix(self):
        self.build('matrix/matrix.vhd', ['matrix/matrix_type_pkg.vhd'], K=6, virtexFamily='virtex5', containsLatches=False, resynthesizeFlag=False, targetDepth=None, verboseFlag=False)
    
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
        generateImplementationFilesFlag = False
    
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
        mappedblifFileName = "mapped.blif"
        numLuts, numTLUTs, numTCONs, depth, avDup, origAnds, paramAnds, check = \
            simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, generateImplementationFilesFlag, module, verboseFlag, extra_args = extraArgs + ['--mappedblif='+mappedblifFileName])
        self.assertEqual(check, 'PASSED', 'lutstruct+parconfig equivalence check failed')
        if verboseFlag:
            print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
            print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
        self.assertEqual(miter(mappedblifFileName, aagFileName, verboseFlag), 'PASSED', 'mappedblif verification failed')


def generateEvaluatedTLutconfig(lutconfig, stream):
    aag_file = open(lutconfig,'r')
    inputs = []
    for line in aag_file:
        if line.rstrip('\r\n') == 'c': break
        if line.startswith('o'): inputs.append(line.rstrip('\r\n').split())

    print >>stream, 'aag %d 0 0 %d 0'%(len(inputs), len(inputs))
    literal = 1
    values = [0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1]
    for input in inputs:
        bit_nr = int(input[1].split('_')[-1])
        print >>stream, values[bit_nr]
    for literal, input in enumerate(inputs):
        print >>stream, 'o%d %s'%(literal, input[1])



def main():
    #CompileTest().build()
    unittest.main()

if __name__=="__main__":
    main()
