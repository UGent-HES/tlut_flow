#!/usr/bin/env python

from fast_tlutmap import run
import os, sys, glob

def checkFile(filePath):
    with open(filePath,'r+') as file:
        return any("--TMAP" in s for s in file)
        
def checkXilinx(filePath):
    with open(filePath,'r+') as file:
        if any("Xilinx, Inc.  All rights reserved." in s for s in file):
            print "found Xilinx file: "+filePath
            return True
        else:
            return False

def main():
    designDir = sys.argv[1]
    softwareDir = sys.argv[2]
    virtexFamily = sys.argv[3]
    verboseFlag = False
    if len(sys.argv)>4:
        verboseFlag = sys.argv[4]=="-v"
    
    baseDir = os.getcwd()
    
    os.chdir(designDir)
    assert not os.system('mkdir -p ../hdl/vhdl')
    vhdFileList = glob.glob('*.vhd*')
    
    nonXilinxFileList = []
    for file in vhdFileList:
        if checkXilinx(file):
            assert not os.system('ln -sf "../../design/'+file+'" ../hdl/vhdl/')
            #assert not os.system('cp -f "'+file+'" ../hdl/vhdl/')
        else:
            nonXilinxFileList.append(file)

    for file in nonXilinxFileList:
        if checkFile(file):
            basename,ext = os.path.splitext(file)
            lstcpy = [item for item in nonXilinxFileList if item!=file]
            run(file, lstcpy, performCheck=True, verboseFlag=verboseFlag, virtexFamily=virtexFamily, generateImplementationFilesFlag=True)
            assert not os.system('cp -f "work/'+basename+'-simpletmap.vhd" "../hdl/vhdl/'+basename+'.vhd"')
            assert not os.system('cp -f "work/'+basename+'.c" "%s/%s/"'%(baseDir,softwareDir))
            assert not os.system('cp -f "work/'+basename+'.h" "%s/%s/"'%(baseDir,softwareDir))
        else:
            assert not os.system('ln -sf "../../design/'+file+'" "../hdl/vhdl/"')
            #assert not os.system('cp -f "'+file+'" "../hdl/vhdl/"')
    

if __name__=="__main__":
    main()
