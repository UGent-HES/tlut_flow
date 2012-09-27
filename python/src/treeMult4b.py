'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os
import shutil
import sys
import commands
from mapping import *   

colwidth=10
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

def main():
    baseName = "treeMult4b"
    
    try:
        os.system('mkdir -p work')
        shutil.copy(baseName+'.vhd', 'work')
        shutil.copy('abc.rc','work')
    except IOError as e:
        print e
        exit(3)
    
    os.chdir('work')
    
    # Automatically extract parameters from VHDL
    parameterFileName = baseName+'.par'
    try:
        assert not os.system('genParameters.py '+baseName+'.vhd > '+baseName+'.par')
    except AssertionError:
        exit(3)
    
    # Synthesis
    blifFileName = synthesize(baseName+'.vhd', [])
    
    # Convert BLIF to aig
    aagFileName = bliftoaag(blifFileName)
    
    # Unleash TMAP
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName,aagFileName, parameterFileName, 4, True)
    print "TMAP"
    print collumnize(['Luts','TLUTs','depth','check'],colwidth)
    print collumnize([numLuts,numTLUTs,depth,check],colwidth)
    
    # Run regular MAP
    print "SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName,aagFileName, 4, True)
    print collumnize(['Luts','','depth','check'],colwidth)
    print collumnize([numLuts,'',depth,check],colwidth)
    
    # Run regular abc fpga
    print "ABC fpga"
    numLuts, depth, check = fpgaMapper(baseName,blifFileName, 4, True)
    print collumnize(['Luts','','depth','check'],colwidth)
    print collumnize([numLuts,'',depth,check],colwidth)
    
if __name__=="__main__":
    main()
