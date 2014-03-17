#!/usr/bin/env python

import sys
import glob
from fast_tconmap import run, setMaxMemory

def main():
    print "regex"
    setMaxMemory(5000)
    run("design/grid_tile.vhd", 
        glob.glob("design/*.vhd"), 
        K=4, 
        performCheck=True, 
        verboseFlag=False,
        resynthesizeFlag=True)

if __name__=="__main__":
    main()
