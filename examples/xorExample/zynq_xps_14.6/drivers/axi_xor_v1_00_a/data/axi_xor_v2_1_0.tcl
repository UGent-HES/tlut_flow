##############################################################################
## Filename:          /home/akulkarn/private/Desktop/git/tlut_flow/examples/xorExample/zynq_xps_14.6/drivers/axi_xor_v1_00_a/data/axi_xor_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Oct 14 11:10:16 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "axi_xor" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
