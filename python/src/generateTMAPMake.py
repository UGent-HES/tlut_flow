#!/usr/bin/env python

import os, sys, glob
from textwrap import dedent

def isTMAPfile(filePath):
    with open(filePath,'r+') as file:
        return any("--TMAP" in s for s in file)    
    
def generateMake(makefileName, virtexFamily):
    with open(makefileName,'w') as makeFile:
        path = os.getcwd()
        try:
            subpath = path[path.index("pcores"):]
            pcoreName = subpath[len("pcores/"):]    #"pcores/<pcoreName>/design"
            pcoreName = pcoreName[:pcoreName.index('/')]
        except ValueError:
            print >>sys.stderr, "Error: Design directory not part of a pcore"
            exit(2)
        
        makeFile.write(dedent('''\
        #This is the make file that contains all rules for using tmap
        #You should include "%s" into your custom.make file
        \n'''%makefileName))
        
        driverFiles = ['$(SOFT_DIR)/%s'%os.path.splitext(file)[0] for file in glob.glob('*.vhd*') if isTMAPfile(file)]
        driverFiles = [file+'.c' for file in driverFiles] + [file+'.h' for file in driverFiles]
        makeFile.write(dedent('''\
        SOFT_DIR = swReconfiguration
        PCORE_NAME = %s
        TMAPDESIGN_DIR = %s
        TMAPHDL_DIR = %s
        DRIVER_FILES = %s
        LOC_FILES = $(SOFT_DIR)/locations.c $(SOFT_DIR)/locations.h
        XDL_FILE = implementation/$(SYSTEM).xdl
        NCD_FILE = implementation/$(SYSTEM).ncd
        VIRTEX_FAMILY = %s
        \n'''%(pcoreName, subpath, subpath[:subpath.rindex('/')]+'/hdl/vhdl', ' '.join(driverFiles),virtexFamily)))
        
        designLine = "DESIGN_FILES = "  #all vhdl files in design directory
        genLine = "GEN_FILES = "        #vhdl files in hdl/vhdl directory that are generated by tmap
        linkLine = "LN_FILES = "        #vhdl links in hdl/vhdl directory that link to vhdl files in design directory
        for file in glob.glob('*.vhd*'):  #all vhd(l) files
            designLine += '$(TMAPDESIGN_DIR)/'+file+" "
            if isTMAPfile(file):
                genLine += '$(TMAPHDL_DIR)/'+file+" "
            else:
                linkLine += '$(TMAPHDL_DIR)/'+file+" "
        makeFile.write(designLine+"\n")
        makeFile.write(genLine+"\n")
        makeFile.write(linkLine+"\n\n")
                
        makeFile.write("all :\n\n")
        
        makeFile.write(dedent('''\
        #The clean-up rules
        hwclean : tmapclean
        
        tmapclean :
        \trm -f $(GEN_FILES)
        \trm -rf $(TMAPDESIGN_DIR)/work
        \trm -f $(LOC_FILES) $(XDL_FILE)
        \trm -f $(DRIVER_FILES)
        
        $(TMAPDESIGN_DIR)/abc.rc :
        \tln -s $(TLUTFLOW_PATH)/third_party/etc/abc.rc $(TMAPDESIGN_DIR)/abc.rc
        \n'''))
        
        makeFile.write(dedent('''\
        #The tmap rule
        $(DRIVER_FILES) $(GEN_FILES) : $(DESIGN_FILES) $(TMAPDESIGN_DIR)/abc.rc
        \tmkdir -p $(SOFT_DIR)
        \t@echo "****************************************************"
        \t@echo "Running tmapFlow"
        \t@echo "****************************************************"
        \ttmapXilinx.py $(TMAPDESIGN_DIR) $(SOFT_DIR) $(VIRTEX_FAMILY)
        
        $(BMM_FILE) $(WRAPPER_NGC_FILES) : $(GEN_FILES) $(LN_FILES)\n\n'''))
        
        makeFile.write(dedent('''\
        #The TLUT location rules
        $(NCD_FILE) : $(SYSTEM_BIT)
        #Create XDL file
        $(XDL_FILE) : $(NCD_FILE)
        \t@echo "****************************************************"
        \t@echo "Running XDL.."
        \t@echo "****************************************************"
        \txdl -ncd2xdl -nopips $(NCD_FILE) $(XDL_FILE)
        
        #Then extract the locations from XDL file
        $(LOC_FILES) : $(XDL_FILE)
        \t@echo "****************************************************"
        \t@echo "Generating locations.h ..."
        \t@echo "****************************************************"
        \tjava be.ugent.elis.recomp.util.ExtractInfo $(XDL_FILE) $(TMAPDESIGN_DIR)/work/names.txt $(LOC_FILES)
        \n'''))
        if virtexFamily=='virtex2pro':
            makeFile.write('bits : $(LOC_FILES)\n')
        else:
            makeFile.write('exporttosdk bits : $(LOC_FILES)\n')
        
        
    os.system('mv '+makefileName+' ../../../')

def main():
    if len(sys.argv)!=2:
        print >>sys.stderr, "Error: No virtex family argument. Possibilities: virtex2Pro, virtex5"
        exit(1)
    virtexFamily = sys.argv[1].lower()
    if virtexFamily not in ("virtex2pro","virtex5"):
        print >> sys.stderr, "Error: Unsupported FPGA family:", virtexFamily
        print >> sys.stderr, "Supported FPGA families: virtex2pro, virtex5"
        exit(1)
        
    if not glob.glob('*.vhd*'):
        print >>sys.stderr, "Error: No vhdl files found in this directory"
        exit(1)
    generateMake("tmap.make", virtexFamily)

if __name__=="__main__":
    main()