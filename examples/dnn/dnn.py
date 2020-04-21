#!/usr/bin/env python

import sys
from fast_tlutmap import run

def main():
    try:
        run('accelerator.vhd', ['LAYER_1.vhd', 'LAYER_2.vhd', 'LAYER_3.vhd', 'LAYER_4.vhd', 'LAYER_5.vhd', 'LAYER_6.vhd'], K=4, performCheck=False, verboseFlag=False)
    except Exception as e:
        print >>sys.stderr, e
        exit(1)

if __name__=="__main__":
    main()
