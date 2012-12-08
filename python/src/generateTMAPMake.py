#!/usr/bin/env python

import os, sys, glob
from textwrap import dedent

    
def generateMake(makefileName):
    with open(makefileName,'w') as makeFile:
        path = os.getcwd()
        try:
            subpath = path[path.index("pcores"):]
        except ValueError:
            print >>sys.stderr, "Error: Design directory not part of a pcore"
            exit(2)
        
        makeFile.write(dedent('''\
        #This is the make file that contains all rules for using tmap
        #You should include "%s" into your custom.make file
        
        #Include the lines below in the system.ucf file, above the IO contraints,
        #Change the name of the tmapped entity and increase the range of the group as needed by your design
        # INST "opb_xor_0/opb_xor_0/USER_LOGIC_I/EXORS/*" AREA_GROUP=group1;
        # AREA_GROUP "group1" COMPRESSION=0;
        # AREA_GROUP "group1" RANGE=SLICE_X0Y*:SLICE_X51Y*;
        \n'''%makefileName))
        
        designLine = "DESIGN_FILES = "
        genLine = "GEN_FILES = "
        for file in glob.glob('*.vhd*'):  #all vhd(l) files
            designLine += subpath+'/'+file+" "
            genLine += subpath.replace("design","hdl/vhdl/")+file+" "
        makeFile.write(designLine+"\n")
        makeFile.write(genLine+"\n\n")
        makeFile.write(dedent('''\
        SOFT_DIR = testReconfiguration
        TMAPDESIGN_DIR = %s
        LOC_FILE = $(SOFT_DIR)/locations.h
        XDL_FILE = implementation/$(SYSTEM).xdl
        NCD_FILE = implementation/$(SYSTEM).ncd
        \n'''%subpath))
        
        makeFile.write("all :\n\n")
        
        makeFile.write(dedent('''\
        #The clean-up rules
        hwclean : tmapclean
        programclean : locclean
        
        tmapclean :
        \trm -f $(GEN_FILES)
        \trm -rf "%s/work"
        
        locclean :
        \trm -f $(LOC_FILE)
        '''%subpath))
        
        makeFile.write(dedent('''\
        #The tmap rule
        $(GEN_FILES) : $(DESIGN_FILES)
        \t@echo "****************************************************"
        \t@echo "Running tmapFlow"
        \t@echo "****************************************************"
        \ttmap.py "$(TMAPDESIGN_DIR)" "$(SOFT_DIR)"
        
        $(BMM_FILE) $(WRAPPER_NGC_FILES): $(GEN_FILES)\n\n'''))
        
        makeFile.write(dedent('''\
        #The TLUT location rules
        $(NCD_FILE) : bits
        #Create XDL file
        $(XDL_FILE) : $(NCD_FILE)
        \t@echo "****************************************************"
        \t@echo "Running XDL.."
        \t@echo "****************************************************"
        \txdl -ncd2xdl -nopips "$(NCD_FILE)" "$(XDL_FILE)"
        
        #Then extract the locations from XDL file
        $(LOC_FILE) : $(XDL_FILE)
        \t@echo "****************************************************"
        \t@echo "Generating locations.h ..."
        \t@echo "****************************************************"
        \tgetLocations.sh "$(XDL_FILE)" "$(TMAPDESIGN_DIR)/work/names.txt" "$(LOC_FILE)"
        
        $(TESTRECONFIGURATION_SOURCES) : $(LOC_FILE)\n\n'''))
        
    os.system('mv '+makefileName+' ../../../')

def main():
    generateMake("tmap.make")

if __name__=="__main__":
    main()