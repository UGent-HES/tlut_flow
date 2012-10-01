#!/usr/bin/env python

import os
import shutil
from mapping import * 

colwidth=10
def collumnize(items,width):
    return ''.join([str(item).ljust(width) for item in items])

def main():
    K = 4
    performCheck = False
    
    baseName = "tdes_top"
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
    
    # Unleash TMAP
    print "Stage: TMAP"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck)
    print collumnize(['Luts','TLUTs','depth','check'],colwidth)
    print collumnize([numLuts,numTLUTs,depth,check],colwidth)
    
    # Run regular MAP
    print "Stage: SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName, aagFileName, K, performCheck)
    print collumnize(['Luts','','depth','check'],colwidth)
    print collumnize([numLuts,'',depth,check],colwidth)
    

if __name__=="__main__":
    main()
