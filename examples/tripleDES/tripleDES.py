#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('tdes_top.aag', [], K=4, performCheck=False, verboseFlag=False, synthesizedFileName='tdes_top.aag', parameterFileName='tdes_top.par')

if __name__=="__main__":
    main()
