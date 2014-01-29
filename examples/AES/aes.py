#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('k_AES.aag', [], K=4, performCheck=True, verboseFlag=False, synthesizedFileName='k_AES.aag', parameterFileName='k_AES.par')

if __name__=="__main__":
    main()
