#!/usr/bin/env python

import sys
from fast_tlutmap import run

def main():
    try:
        run('treeMult4b.vhd', K=4, performCheck=True, verboseFlag=False, parameterFileName='treeMult4b.par')
    except Exception as e:
        print >>sys.stderr, e
        exit(1)

if __name__=="__main__":
    main()
