#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('subst_row_mem.vhd', performCheck=True)

if __name__=="__main__":
    main()
