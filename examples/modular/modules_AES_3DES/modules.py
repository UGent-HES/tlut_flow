#!/usr/bin/env python

import sys, glob
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(1024)
    run('modules_exp.vhd', glob.glob('*/*.vhd'), K=6, 
        performCheck=False, verboseFlag=False, resynthesizeFlag=True)

if __name__=="__main__":
    main()
