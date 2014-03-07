#!/usr/bin/env python

import sys
from fast_tconmap import run

def main():
    module = "mux3.blif"
    print 'mux'
    run(module, 
        K=4, 
        performCheck=True, 
        verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="parameters_mux.par",
        extraArgs=['--nolutstruct'])

if __name__=="__main__":
    main()
