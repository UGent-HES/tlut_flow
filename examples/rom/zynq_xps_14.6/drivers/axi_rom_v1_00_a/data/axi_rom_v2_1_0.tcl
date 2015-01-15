##############################################################################
## Filename:          /home/akulkarn/private/Desktop/git/tlut_flow/examples/rom/zynq_xps_14.6/drivers/axi_rom_v1_00_a/data/axi_rom_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Wed Oct 30 16:22:31 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "axi_rom" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
