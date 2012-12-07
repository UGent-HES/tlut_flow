#!/usr/bin/env python

from fast_tlutmap import run
import os, sys

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

def vhdlFilter(list):
    return [item for item in list if '.vhd' in item]

def main():
    os.chdir(sys.argv[1])
    vhdFileList = vhdlFilter(os.listdir("./"))
    
    nonXilinxFileList = []
    for file in vhdFileList:
        if checkXilinx(file):
            os.system('cp -rf '+file+' ../hdl/vhdl/')
        else:
            nonXilinxFileList.append(file)

    for file in nonXilinxFileList:
        if checkFile(file):
            ext = file.split('.')[-1].lower()
            basename = file[:-len(ext)-1]
            lstcpy = [item for item in nonXilinxFileList if item!=file]
            run(file, lstcpy ,K=4, performCheck=True, verboseFlag=False) #for some reason, run stays in the workdir
            os.system('cp -rf '+basename+'-simpletmap.vhd ../../hdl/vhdl/'+basename+'.vhd')
            os.system('cp -rf '+basename+'.c ../../../../testReconfiguration/')
        else:
            os.system('cp -rf '+file+' ../hdl/vhdl/')
    

if __name__=="__main__":
    main()
