#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('mult16bit.vhd',['treeMult4b.vhd'], K=4, performCheck=True, verboseFlag=False)

if __name__=="__main__":
    main()
