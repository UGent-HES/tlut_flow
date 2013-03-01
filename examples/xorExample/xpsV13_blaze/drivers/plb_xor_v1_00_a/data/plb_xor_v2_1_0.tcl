##############################################################################
## Filename:          /home/todavids/private/git/tlut/examples/xorExample/xpsV13_blaze/drivers/plb_xor_v1_00_a/data/plb_xor_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue Feb 26 15:31:48 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb_xor" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
