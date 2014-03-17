#!/usr/bin/env python

import sys, glob
from fast_tlutmap import run, setMaxMemory

def main():
    setMaxMemory(2048)
    run('3DES/tdes_top.vhd', glob.glob('3DES/*.vhd'), K=4, performCheck=True, verboseFlag=False, resynthesizeFlag=True)

if __name__=="__main__":
    main()
