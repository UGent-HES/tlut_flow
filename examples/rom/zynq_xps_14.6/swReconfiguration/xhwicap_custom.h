#ifndef XHWICAP_CUSTOM_H_ /* prevent circular inclusions */
#define XHWICAP_CUSTOM_H_ /* by using protection macros */

#include "xhwicap_i.h"
#include "xhwicap_custom_i.h"
#include "xhwicap_getset_clb_7series.h"

#if (XHI_FAMILY != XHI_DEV_FAMILY_7SERIES)
    #error You are using the wrong xhwicap_custom driver files. This file is specific to 7 series FPGAs only!!
#endif

/* Custom function for initializing the HWICAP, customized for Zynq and Kintex 7 fabric*/
int XHwIcap_custom_CfgInitialize(XHwIcap *InstancePtr, XHwIcap_Config *ConfigPtr, u32 EffectiveAddr);

#endif
