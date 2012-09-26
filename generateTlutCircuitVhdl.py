#!/usr/bin/env python

import os
import sys
import re

def help():
    print "usage: generateTlutCircuitVhdl.py <in_vhdl_file.vhd> <K>"
    print "\tin_vhdl_file.vhd: file name to apply TLUTMAP to"
    print "\tK: number of inputs per LUT (integer)"
    
def main():
    if len(sys.argv)!= 3:
        help()
        exit(1)
    inVhdFile = sys.argv[1]
    try:
        K = str(int(sys.argv[2]))
    except ValueError:
        print "Error: argument K is not an integer"
        help()
        exit(1)

    baseNameIn = re.search('.*(?=.vhd)' ,inVhdFile).group(0)
    assert baseNameIn
    os.system('mkdir work')
    os.system('cp '+inVhdFile+' work/'+inVhdFile)
    os.system('cp '+inVhdFile+' '+baseNameIn+'-preprocessor.vhd')
    os.system('cp '+inVhdFile+' work/'+baseNameIn+'-old.vhd')
    
    # Generate quartus project files
    f_write = open('work/'+baseNameIn+'.qpf', 'w')
    f_write.write('PROJECT_REVISION = "'+baseNameIn+'"\n')
    f_write.close()
    
    f_write = open('work/'+baseNameIn+'.qsf', 'w')
    f_write.write('set_global_assignment -name VHDL_FILE '+baseNameIn+'.vhd\n')
    f_write.write('set_global_assignment -name FAMILY Stratix\n')
    f_write.write('set_global_assignment -name TOP_LEVEL_ENTITY '+baseNameIn+'\n')
    f_write.write('set_global_assignment -name DEVICE_FILTER_SPEED_GRADE FASTEST\n')
    f_write.write('set_global_assignment -name INI_VARS "no_add_ops=on;opt_dont_use_mac=on;dump_blif_after_lut_map=on;abort_after_dumping_blif=on"\n')
    f_write.write('set_global_assignment -name DEVICE AUTO\n')
    f_write.write('set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1')
    f_write.close()
    
    # Synthesis
    os.system('quartus_map work/'+baseNameIn+'.qpf') 
    
    # Generate the parameter file
    assert not os.system('genParameters.py work/'+baseNameIn+'.vhd > work/'+baseNameIn+'.par')
    
    # Sweep the input blif File
    assert not os.system('abc -c sweep -o work/'+baseNameIn+'-sweep.blif -t blif -T blif work/'+baseNameIn+'.blif')
    
    #Convert blif file to an aag file 
    assert not os.system('abc -c \'strash; write work/'+baseNameIn+'.aig\' work/'+baseNameIn+'-sweep.blif')
    assert not os.system('aigtoaig work/'+baseNameIn+'.aig work/'+baseNameIn+'.aag')
    
    # Generate the vhdl file with the TLUT circuit and the aag file with the tuning functions
    assert not os.system('generateTlutCircuitAag.py work/'+baseNameIn+'.aag work/'+baseNameIn+'.par '+K+' work/'+inVhdFile)
    
    # Convert parConfig aag to eqn file
    assert not os.system('aigtoaig work/'+baseNameIn+'-parconfig.aag work/'+baseNameIn+'-parconfig.aig')
    assert not os.system('abc -c \'collapse; write work/'+baseNameIn+'-parconfig.eqn\' work/'+baseNameIn+'-parconfig.aig')
    
    #os.system('cp work/'+inVhdFile+' '+inVhdFile)
    #os.system('cp work/'+baseNameIn+'.par '+baseNameIn+'.par')
    #os.system('cp work/'+baseNameIn+'-parconfig.eqn'+' '+baseNameIn+'-parconfig.eqn')

if __name__=="__main__":
    main()