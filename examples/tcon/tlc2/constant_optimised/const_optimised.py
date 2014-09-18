#!/usr/bin/env python

from constant_optimisation import runVHDL, generateIntToUnsignedLogicVector

def main():
    par = {'p':map(generateIntToUnsignedLogicVector(3), xrange(0,7))}
    #par = {'p':map(generateIntToUnsignedLogicVector(3), [4])}
    runVHDL('tlc2.vhd', [], par, K=6)
    
if __name__=="__main__":
    main()
