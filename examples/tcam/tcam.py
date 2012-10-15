#!/usr/bin/env python

import os
import shutil
import sys
from mapping import *   


colwidth=16
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

#copy and edit this function, or call it with your vhdl module as its argument (optional list of submodules as second argument)
def main():
    module = 'tcam.vhd'
    submodules = ['pkg.vhd']
    parameterFileName = 'tcam.par'
    
    K=4
    performCheck=True
    verboseFlag=False
    
    ext = module.split('.')[-1].lower()
    baseName = module[:-len(ext)-1]
    
    print "Stage: Creating work directory and copying design"
    try:
        os.system('mkdir -p work')
        shutil.copy(parameterFileName,'work')
        shutil.copy(module, 'work')
        for submodule in submodules:
            shutil.copy(submodule, 'work')
        shutil.copy('abc.rc','work')
    except IOError as e:
        print >> sys.stderr, e
        exit(3)
    
    os.chdir('work')
    
    # Synthesis
    print "Stage: Synthesizing"
    blifFileName = synthesize(module, submodules, verboseFlag)
    
    # Convert BLIF to aig
    aagFileName = bliftoaag(blifFileName)
    
    # Unleash TLUT mapper
    print "Stage: TLUT mapper"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
    print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
    
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

if __name__=="__main__":
    main()
