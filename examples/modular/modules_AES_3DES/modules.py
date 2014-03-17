#!/usr/bin/env python

import sys, glob
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(2048)
    run('modules_exp.vhd', glob.glob('*/*.vhd'), K=4, performCheck=False, verboseFlag=True, resynthesizeFlag=True)

if __name__=="__main__":
    main()
