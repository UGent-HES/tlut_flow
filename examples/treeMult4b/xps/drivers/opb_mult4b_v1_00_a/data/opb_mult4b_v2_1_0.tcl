##############################################################################
## Filename:          /home/kheyse/private/tlut_flow/examples/treeMult4b/ise/drivers/opb_mult4b_v1_00_a/data/opb_mult4b_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sat Dec  8 14:00:15 2012 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "opb_mult4b" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
