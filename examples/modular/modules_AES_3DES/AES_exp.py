#!/usr/bin/env python
# map the AES.vhd aes design with subkeys already expanded. has therefore lower depth and area

import sys, glob
from fast_tlutmap import run, setMaxMemory

def main():
    setMaxMemory(2048)
    run('AES/AES.vhd', glob.glob('AES/*.vhd'), K=4, performCheck=False, verboseFlag=False, resynthesizeFlag=True)

if __name__=="__main__":
    main()
