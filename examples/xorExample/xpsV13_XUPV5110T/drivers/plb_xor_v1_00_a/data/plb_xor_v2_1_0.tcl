##############################################################################
## Filename:          /home/akulkarn/private/Desktop/git_try/tlut_flow/examples/xorExample/xps_xupV5/drivers/plb_xor_v1_00_a/data/plb_xor_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Jun 17 18:14:10 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb_xor" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
