#!/usr/bin/env python

import sys
from fast_tconmap import run

def main():
    print 'tlc2'
    module = "tlc2-sweep.blif"
    run(
        module, 
        K=4, 
        performCheck=True, 
        verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="parameters_ps.par")

if __name__=="__main__":
    main()
