#!/usr/bin/env python

import sys
from fast_tconmap import run

def main():
#    runModule("barrelshift4.blif")
#    runModule("barrelshift8.blif")
    runModule("barrelshift16.blif")

def runModule(module):
    print module
    run(module, 
        K=4, 
        performCheck=False,
        verboseFlag=False,
        synthesizedFileName=module, 
        parameterFileName="parameters_barrel.par",
        extraArgs=['--nolutstruct'])

if __name__=="__main__":
    main()
