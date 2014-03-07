#!/usr/bin/env python

import sys
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(4000)
    module = "cross16-sweep.blif"
    print module
    run(module, 
        K=4, 
        performCheck=True, 
        verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="parameters_cross16.par",
        extraArgs=['--nolutstruct'])

if __name__=="__main__":
    main()
