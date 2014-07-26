#!/usr/bin/env python

import sys
from fast_tconmap import run, setMaxMemory

def main():
    setMaxMemory(4000)
    designs = ["top_genericblock_1", "top_genericblock_4", "top_genericblock_8", "top_genericblock_16", "top_genericblock_32", "top_genericblock_64", "top_genericblock_128", "top_genericblock_256", "top_genericblock_512", "top_genericblock_1024"]
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
