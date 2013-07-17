#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('rom.vhd', K=6, performCheck=True, verboseFlag=False)

if __name__=="__main__":
    main()
