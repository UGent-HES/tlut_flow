#!/usr/bin/env python

import sys
from fast_tconmap import run, setMaxMemory

verboseFlag = False
performCheck = True
def main():
    setMaxMemory(2048)
    runModule("combined_blocks_gen1-sweep.blif")
    runModule("combined_blocks_gen2-sweep.blif")
#    runModule("combined_blocks_gen3-sweep.blif")
#    runModule("combined_blocks_gen4-sweep.blif")
def runModule(module):
    print module
    run(module, 
        K=4, 
        performCheck=performCheck, 
        verboseFlag=verboseFlag,
        synthesizedFileName=module, 
        parameterFileName="parameters_combinedblock.par",
        extraArgs=[]) #'--nolutstruct'])

if __name__=="__main__":
    main()
