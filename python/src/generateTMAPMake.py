#!/usr/bin/env python

import os

def vhdlFilter(list):
	vhdlList=[]
	for string in list:
		if ".vhd" in string:
			vhdlList.append(string)
	return vhdlList
	
def generateMake(fileName):
	makeFile=open(fileName,'w')
	path=os.getcwd()
	subpath=path[path.find("pcores"):]
	fileList=vhdlFilter(os.listdir("./"))
	makeFile.write("#This is the make file that contains all rules for using tmap\n")
	makeFile.write("#You should include \""+fileName+"\" into your custom.make file\n")
	
	makeFile.write("#Include the lines below in the system.ucf file, above the IO contraints,\n") 
	makeFile.write("#change the name of the tmapped entity and increase the range of the group as needed by your design\n")
	makeFile.write("#INST \"opb_xor_0/opb_xor_0/USER_LOGIC_I/EXORS/*\" AREA_GROUP=group1;\n")
	makeFile.write("#AREA_GROUP \"group1\" COMPRESSION=0;\n")
	makeFile.write("#AREA_GROUP \"group1\" RANGE=SLICE_X0Y*:SLICE_X51Y*;\n")
	
	designLine="DESIGN_FILES = "
	genLine="GEN_FILES = "
	for file in fileList:
		designLine +=subpath+'/'+file+" "
		genLine +=subpath.replace("design","hdl/vhdl/")+file+" "
	makeFile.write(designLine+"\n")
	makeFile.write(genLine+"\n\n")
	makeFile.write("XDL_FILE = implementation/$(SYSTEM).xdl\nNCD_FILE = implementation/$(SYSTEM).ncd\n")
	makeFile.write("SOFT_DIR = testReconfiguration\n")
	makeFile.write("LOC_FILE = testReconfiguration/locations.h\n\n")
	makeFile.write("#Below are the added rules\n\n")
	makeFile.write("#The clean-up rule\n\n")
	makeFile.write("hwclean : tmapclean\n\n")
	makeFile.write("tmapclean:\n\trm -f $(GEN_FILES)\n\trm -rf "+subpath+"/work\n\n")
	makeFile.write("programclean : locclean\n\n")
	makeFile.write("locclean:\n\trm -f $(LOC_FILE)\n\n")
	rule="$(GEN_FILES): $(DESIGN_FILES) \n"
	rule+="\t@echo \"****************************************************\"\n"
	rule+="\t@echo \"Running tmapFlow\"\n"
	rule+="\t@echo \"****************************************************\"\n"
	rule+="\trunFlow.sh "+path+"\n\n"
	makeFile.write(rule)
	makeFile.write("$(BMM_FILE) $(WRAPPER_NGC_FILES): $(GEN_FILES)\n\n")
	makeFile.write("$(XDL_FILE): $(NCD_FILE) \n")
	makeFile.write("\t@echo \"****************************************************\"\n")
	makeFile.write("\t@echo \"Running XDL..\"\n")
	makeFile.write("\t@echo \"****************************************************\"\n")
	makeFile.write("\txdl -ncd2xdl -nopips $(NCD_FILE) $(XDL_FILE)\n\n")
	makeFile.write("# Then extract the locations from this file\n\n")
	makeFile.write("$(LOC_FILE): $(XDL_FILE) \n")
	makeFile.write("\t@echo \"****************************************************\"\n")
	makeFile.write("\t@echo \"Generating locations.h ...\"\n")
	makeFile.write("\t@echo \"****************************************************\"\n")
	makeFile.write("\tgetLocations.sh $(XDL_FILE) "+path+"/work/names.txt $(LOC_FILE)\n\n")
	makeFile.close()
	os.system('mv '+fileName+' ../../../')

def main():
	generateMake("tmap.make")

if __name__=="__main__":
    main()