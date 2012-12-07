#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('mult.v', K=4, performCheck=True, generateImplementationFilesFlag=False, verboseFlag=False)

if __name__=="__main__":
    main()
