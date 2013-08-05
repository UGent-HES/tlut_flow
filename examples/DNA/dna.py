#!/usr/bin/env python

import sys
from fast_tlutmap import run

def main():
    try:
        run('subst_row_mem.vhd', K=4, performCheck=True, verboseFlag=False)
    except Exception as e:
        print >>sys.stderr, e
        exit(1)

if __name__=="__main__":
    main()
