#!/usr/bin/env python

import os
import shutil
from mapping import * 
from fast_tlutmap import collumnize

colwidth=16
def main():
    K = 4
    performCheck = True
    verboseFlag = False
    
    baseName = "tdes_top"
    aagFileName = baseName+".aag"
    parameterFileName = baseName+".par"
    
    print "Stage: Creating work directory and copying design"
    os.system('mkdir -p work')
    shutil.copy(aagFileName, 'work')
    shutil.copy(parameterFileName, 'work')
    shutil.copy(os.environ['TLUTFLOW_PATH']+'/third_party/etc/abc.rc','work')
    
    os.chdir('work')
    
    # Unleash TLUTMAP
    print "Stage: TLUTMAP"
    numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(baseName, aagFileName, parameterFileName, K, performCheck, False, verboseFlag=verboseFlag)
    print collumnize(['Luts (TLUTS)','depth','check'],colwidth)
    print collumnize([str(numLuts)+' ('+str(numTLUTs)+')',depth,check],colwidth)
    
    # Run regular MAP
    print "Stage: SimpleMAP"
    numLuts, depth, check = simpleMapper(baseName, aagFileName, K, performCheck, verboseFlag)
    print collumnize(['Luts','depth','check'],colwidth)
    print collumnize([numLuts,depth,check],colwidth)
    

if __name__=="__main__":
    main()
