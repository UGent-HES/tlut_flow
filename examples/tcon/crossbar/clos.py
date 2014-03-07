#!/usr/bin/env python

import sys
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(4000)
    module = "switch16x16-sweep-sclean.blif"
    print module
    run(module, 
        K=4, 
        performCheck=False, 
        verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="parameters_clos16.par", 
        extraArgs=['--nolutstruct'])

if __name__=="__main__":
    main()
