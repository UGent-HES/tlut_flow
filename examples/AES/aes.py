#!/usr/bin/env python

import os
import shutil
from mapping import * 

colwidth=16
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

def main():
    K = 4
    performCheck = True
    verboseFlag = False
    setMaxMemory(2048)
    
    baseName = "k_AES"
    aagFileName = baseName+".aag"
    parameterFileName = baseName+".par"
    
    print "Stage: Creating work directory and copying design"
    try:
        os.system('mkdir -p work')
        shutil.copy(aagFileName, 'work')
        shutil.copy(parameterFileName, 'work')
        shutil.copy('abc.rc','work')
    except IOError as e:
        print e
        exit(3)
    
    os.chdir('work')
    
    # Unleash TLUTMAP
    print "Stage: TLUTMAP"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, False, verboseFlag)
    print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
    print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
    
    # Run regular MAP
    print "Stage: SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName, aagFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','depth','check'],colwidth)
    print collumnize([numLuts,depth,check],colwidth)
    

if __name__=="__main__":
    main()
