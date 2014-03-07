#!/usr/bin/env python

import sys
from fast_tconmap import run

def main():
    module = "top_genericblock-sweep.blif"
    run(module, K=4, performCheck=True, verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="top_genericblock.par")

if __name__=="__main__":
    main()
