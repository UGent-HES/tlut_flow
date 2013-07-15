#!/usr/bin/env python

from fast_tlutmap import run

def main():
    run('exorw32.vhd', performCheck=True, verboseFlag=False, generateImplementationFilesFlag=True, virtexFamily='virtex5')

if __name__=="__main__":
    main()
