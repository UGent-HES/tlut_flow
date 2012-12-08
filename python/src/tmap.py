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
    
    baseDir = os.getcwd()
    
    os.chdir(designDir)
    vhdFileList = glob.glob('*.vhd*')
    
    nonXilinxFileList = []
    for file in vhdFileList:
        if checkXilinx(file):
            os.system('cp -f '+file+' ../hdl/vhdl/')
        else:
            nonXilinxFileList.append(file)

    for file in nonXilinxFileList:
        if checkFile(file):
            ext = file.split('.')[-1].lower()
            basename = file[:-len(ext)-1]
            lstcpy = [item for item in nonXilinxFileList if item!=file]
            run(file, lstcpy ,K=4, performCheck=True, verboseFlag=False)
            os.system('cp -f "work/'+basename+'-simpletmap.vhd" "../hdl/vhdl/'+basename+'.vhd"')
            os.system('cp -f "work/'+basename+'.c" "%s/%s/"'%(baseDir,softwareDir))
            os.system('cp -f "work/'+basename+'.h" "%s/%s/"'%(baseDir,softwareDir))
        else:
            os.system('cp -f "'+file+'" "../hdl/vhdl/"')
    

if __name__=="__main__":
    main()
