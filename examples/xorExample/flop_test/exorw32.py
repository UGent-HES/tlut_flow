#!/usr/bin/env python

import os
from fast_tlutmap import run

def main():
    run('exorw32.vhd', performCheck=True, verboseFlag=False, generateImplementationFilesFlag=True, virtexFamily='virtex5')
    assert os.system('xst -ifn exorw32_xst.scr')

if __name__=="__main__":
    main()
