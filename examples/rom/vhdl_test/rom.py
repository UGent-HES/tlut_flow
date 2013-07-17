#!/usr/bin/env python

import os
from fast_tlutmap import run

def main():
    run('rom.vhd', performCheck=True, verboseFlag=False, generateImplementationFilesFlag=True, virtexFamily='virtex5')
    assert not os.system('xst -ifn rom_xst.scr')

if __name__=="__main__":
    main()
