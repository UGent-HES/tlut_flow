#!/usr/bin/env python

import sys
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(4000)
    designs = ["tlc2-sweep_1", "tlc2-sweep_2", "tlc2-sweep_4", "tlc2-sweep_8", "tlc2-sweep_16", "tlc2-sweep_32", "tlc2-sweep_64", "tlc2-sweep_128", "tlc2-sweep_256", "tlc2-sweep_512"]
    for module_base in designs:
        print module_base
        run(
            module_base+".aag", 
            K=4, 
            performCheck=False, 
            verboseFlag=False,
            synthesizedFileName=module_base+".aag", 
            parameterFileName=module_base+".par",
            extraArgs=["--nolutstruct"])

if __name__=="__main__":
    main()
