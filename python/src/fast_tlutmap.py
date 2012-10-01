'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os
import shutil
import sys
from mapping import *   


colwidth=10
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

#copy and edit this function, or call it with your vhdl module as its argument (optional list of submodules as second argument)
def run(module, submodules=[], K=4, performCheck=True, verboseFlag=False):
    if not module.lower().endswith('.vhd'):
        print >> sys.stderr, "Error: Module filename does not have extension '.vhd':", module
        exit(3)
    baseName = module[:-len('.vhd')]
    
    print "Stage: Creating work directory and copying design"
    try:
        os.system('mkdir -p work')
        shutil.copy(module, 'work')
        shutil.copy('abc.rc','work')
    except IOError as e:
        print >> sys.stderr, e
        exit(3)
    
    os.chdir('work')
    
    # Automatically extract parameters from VHDL
    print "Stage: Generating parameters"
    parameterFileName = baseName+'.par'
    try:
        assert not os.system('genParameters.py '+module+' > '+baseName+'.par')
    except AssertionError:
        exit(3)
    
    # Synthesis
    print "Stage: Synthesizing"
    blifFileName = synthesize(module, submodules, verboseFlag)
    
    # Convert BLIF to aig
    aagFileName = bliftoaag(blifFileName)
    
    # Unleash TMAP
    print "Stage: TMAP"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','TLUTs','depth','check'],colwidth)
    print collumnize([numLuts,numTLUTs,depth,check],colwidth)
    
    # Run regular MAP
    print "Stage: SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName, aagFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','','depth','check'],colwidth)
    print collumnize([numLuts,'',depth,check],colwidth)
    
    # Run regular abc fpga
    print "Stage: ABC fpga"
    numLuts, depth, check = fpgaMapper(baseName, blifFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','','depth','check'],colwidth)
    print collumnize([numLuts,'',depth,check],colwidth)
    
if __name__=="__main__":
    print 'Call the function run of this file with your vhdl module as its first argument (optional list of submodule as second argument)'
    print 'or copy and edit this file to use it as a template for your experiment.'
