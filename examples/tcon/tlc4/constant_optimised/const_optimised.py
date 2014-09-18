#!/usr/bin/env python

from constant_optimisation import runVHDL, generateIntToUnsignedLogicVector

def main():
    par = {'p':map(generateIntToUnsignedLogicVector(2), xrange(0,3))}
    #par = {'p':map(generateIntToUnsignedLogicVector(2), [1])}
    runVHDL('tlc4.vhd', [], par, K=6)
    
if __name__=="__main__":
    main()
