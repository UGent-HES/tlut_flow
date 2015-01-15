/**
* Replacement for the XHwIcap_GetClbBits and XHwIcap_SetClbBits functions for the Zynq.
**/

#include <xhwicap.h>
#include "xhwicap_custom.h"

#if (XHI_FAMILY != XHI_DEV_FAMILY_7SERIES)
    #error You are using the wrong xhwicap_getset_clb driver files. This file is specific to 7 series FPGAs only!!
#endif

/**
* Sets bits contained in a LUT specified by the CLB row and col
* coordinates.  The coordinate system lables the upper left CLB as (1,1).
*
* @param	InstancePtr is a pointer to the XHwIcap instance to be worked on.
* @param	Row is the CLB row. (1,1) is the upper left CLB.
* @param	Col is the CLB col. (1,1) is the upper left CLB.
* @param	Resource is the target bits data from XHI_CLB_LUT_replacement.
* @param	Value is the values to set each of the targets bits to.
*		The size of this array must be equal to NumBits.
* @param	NumBits is the number of Bits to change in this method.
*
* @return	XST_SUCCESS or XST_FAILURE.
**/
int XHwIcap_Custom_SetClbBits(XHwIcap *InstancePtr, long clb_row, long clb_col,
		const u8 Resource[][2], const u8 Value[], long NumBits);


/**
* Get bits contained in a LUT specified by the CLB row and col
* coordinates.  The coordinate system lables the upper left CLB as (1,1).
*
* @param	InstancePtr is a pointer to the XHwIcap instance to be worked on.
* @param	Row is the CLB row. (1,1) is the upper left CLB.
* @param	Col is the CLB col. (1,1) is the upper left CLB.
* @param	Resource is the target bits data from XHI_CLB_LUT_replacement.
* @param	Value is the values to set each of the targets bits to.
*		The size of this array must be equal to NumBits.
* @param	NumBits is the number of Bits to read in this method.
*
* @return	XST_SUCCESS or XST_FAILURE.
**/
int XHwIcap_Custom_GetClbBits(XHwIcap *InstancePtr, long clb_row, long clb_col,
        const u8 Resource[][2], u8 Value[], long NumBits);
