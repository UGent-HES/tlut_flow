/**
* Replacement for the XHwIcap_GetClbBits and XHwIcap_SetClbBits functions for the 7 series FPGA.
**/

#ifndef XHWICAP_GETSET_CLB_H_
#define XHWICAP_GETSET_CLB_H_

#include <assert.h>
#include "xhwicap_getset_clb_7series.h"
#include "xhwicap_multiframe.h"
#include "xhwicap.h"
#include "xhwicap_custom.h"

/**
*Prepares the configuration of the Frame address for a given slice co-ordinates.
*
* @param	InstancePtr is a pointer to the XHwIcap instance to be worked on.
* @param	slice_row is row number of the Slice (Y co-ordinate).
* @param	slice_col is column number of the Slice (X co-ordinate).
* @param	*bottom_ntop_p pointer to a variable where top/bottom bit is to be stored.
* @param	*clock_row_p pointer to a variable where row address is to be stored.
* @param	*major_frame_address_p pointer to a variable where CLB column/major address is to be stored.
* @param	*word_offset_p pointer to a variable where word offset is to be stored.
*
**/
void XHwIcap_Custom_GetConfigurationCoordinates(XHwIcap *InstancePtr, long slice_row, long slice_col,
        u8 *bottom_ntop_p, int *clock_row_p, u32 *major_frame_address_p, u32 *word_offset_p) {

    u32 num_clock_rows = InstancePtr->HClkRows;
    u32 num_clb_rows = InstancePtr->Rows;
    u32 num_clb_rows_per_clock_row = num_clb_rows / num_clock_rows;
    u32 num_clb_cols = InstancePtr->Cols;

    assert(slice_row >= 0 && slice_row < num_clb_rows);
    assert(slice_col >= 0 && slice_col < 2*num_clb_cols);

	/* Translation of Slice X-coordinate to CLB X-coordinate */
    u32 major_frame_address = slice_col/2;
    u32 i;
    for (i = 0; major_frame_address >= InstancePtr->SkipCols[i] ; i++);
    major_frame_address += i;

	/* Top or Bottom bit and the row address*/
    u8 mid_line;
    u8 bottom_ntop;
    u8 slice_grp = slice_row / num_clb_rows_per_clock_row + 1;
    int clock_row = 0;

    if(num_clock_rows % 2 == 0)
#if (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_ZYNQ)
    	mid_line = num_clock_rows / 2;
#elif (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_K7)
		mid_line = num_clock_rows / 2 + 1;
#endif
    else
#if (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_ZYNQ)
    	mid_line = num_clock_rows / 2 + 1;
#elif (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_K7)
		mid_line = num_clock_rows / 2;
#endif

	if(slice_grp > mid_line){
		bottom_ntop = 0;
		clock_row = slice_grp - mid_line - 1;
	}
	else {
		clock_row = mid_line - slice_grp;
		bottom_ntop = 1;
	}

  	/* Calculating word offset */
    u32 word_offset = 0;
	slice_row = slice_row % num_clb_rows_per_clock_row;
		  
	if (slice_row >= num_clb_rows_per_clock_row/2){
		word_offset = slice_row * 2 + 1;
	}
	else {
		word_offset = slice_row * 2;
	}

    *bottom_ntop_p = bottom_ntop;
    *clock_row_p = clock_row;
    *major_frame_address_p = major_frame_address;
    *word_offset_p = word_offset;
}

/**
* Sets bits contained in a LUT specified by the Slice row and col
* coordinates.
*
* @param	InstancePtr is a pointer to the XHwIcap instance to be worked on.
* @param	slice_row is row number of the Slice (Y co-ordinate).
* @param	slice_col is column number of the Slice (X co-ordinate).
* @param	Resource is the target bits data from XHI_CLB_LUT_replacement.
* @param	Value is the values to set each of the targets bits to.
*			The size of this array must be equal to NumBits.
* @param	NumBits is the number of Bits to change in this method.
*
* @return	XST_SUCCESS or XST_FAILURE.
**/
int XHwIcap_Custom_SetClbBits(XHwIcap *InstancePtr, long slice_row, long slice_col,
		const u8 Resource[][2], const u8 Value[], long NumBits) {
    u8 bottom_ntop;
    int Status;
    int clock_row;
    u32 major_frame_address;
    u32 word_offset;

    XHwIcap_Custom_GetConfigurationCoordinates(InstancePtr, slice_row, slice_col,
        &bottom_ntop, &clock_row, &major_frame_address, &word_offset);
    
    u32 frame_num = 4;
    u32 frame_number_offset;
    if(Resource[0][1] < 32)
        frame_number_offset = 26;
    else
        frame_number_offset = 32;

	u32 buffer[InstancePtr->WordsPerFrame * (frame_num + 1) + 1];

	Status = XHwIcap_DeviceReadFrames(InstancePtr, bottom_ntop, XHI_FAR_CLB_BLOCK,
			clock_row, major_frame_address, frame_number_offset, frame_num, buffer);

    if (Status != XST_SUCCESS)
        return XST_FAILURE;

    u32 *configuration = buffer + InstancePtr->WordsPerFrame + 1;

    u32 i;
    for(i = 0; i < NumBits; i++) {
    	u32 frame_number = Resource[i][1];
    	u32 frame_number_relative = frame_number - frame_number_offset;
    	assert(frame_number >= frame_number_offset && frame_number_relative < frame_num);

        u8 bit_nr = Resource[i][0];
        u16 word_nr = frame_number_relative * InstancePtr->WordsPerFrame + word_offset;

        if(bit_nr >= 32) {
            bit_nr -= 32;
        }else {
        	word_nr++;
        }

        assert(bit_nr < 32);
    	u32 word = configuration[word_nr];
    	u32 bit = 1 << bit_nr;
    	if(Value[i])
    	    word |= bit;
    	else
    	    word &= ~bit;
    	configuration[word_nr] = word;
    }

    Status = XHwIcap_DeviceWriteFrames(InstancePtr, bottom_ntop, XHI_FAR_CLB_BLOCK,
				clock_row, major_frame_address, frame_number_offset, frame_num, buffer);

    if (Status != XST_SUCCESS)
        return XST_FAILURE;

	return XST_SUCCESS;
}


/**
* Get bits contained in a LUT specified by the Slice row and col
* coordinates.
*
* @param	InstancePtr is a pointer to the XHwIcap instance to be worked on.
* @param	slice_row is row number of the Slice (Y co-ordinate).
* @param	slice_col is column number of the Slice (X co-ordinate).
* @param	Resource is the target bits data from XHI_CLB_LUT_replacement.
* @param	Value is the values that are read each of the targets bits to.
*		    The size of this array must be equal to NumBits.
* @param	NumBits is the number of Bits to read in this method.
*
* @return	XST_SUCCESS or XST_FAILURE.
**/
int XHwIcap_Custom_GetClbBits(XHwIcap *InstancePtr, long slice_row, long slice_col,
        const u8 Resource[][2], u8 Value[], long NumBits) {
    u8 bottom_ntop;
    int Status;
    int clock_row;
    u32 major_frame_address;
    u32 word_offset;

    XHwIcap_Custom_GetConfigurationCoordinates(InstancePtr, slice_row, slice_col,
        &bottom_ntop, &clock_row, &major_frame_address, &word_offset);
    
    u32 frame_num = 4;
    u32 frame_number_offset;
    if(Resource[0][1] < 32)
        frame_number_offset = 26;
    else
        frame_number_offset = 32;
        
	u32 buffer[InstancePtr->WordsPerFrame * (frame_num + 1) + 1];

	Status = XHwIcap_DeviceReadFrames(InstancePtr, bottom_ntop, XHI_FAR_CLB_BLOCK,
				clock_row, major_frame_address, frame_number_offset, frame_num, buffer);

	if (Status != XST_SUCCESS)
        return XST_FAILURE;

    u32 *configuration = buffer + InstancePtr->WordsPerFrame + 1;

    u32 i;
    for(i = 0; i < NumBits; i++) {
    	u32 frame_number = Resource[i][1];
    	u32 frame_number_relative = frame_number - frame_number_offset;
    	assert(frame_number >= frame_number_offset && frame_number_relative < frame_num);

        u8 bit_nr = Resource[i][0];
        u16 word_nr = frame_number_relative * InstancePtr->WordsPerFrame + word_offset;

        if(bit_nr >= 32) {
            bit_nr -= 32;
        }else {
        	word_nr++;
        }
        assert(bit_nr < 32);
    	u32 word = configuration[word_nr];
    	u8 bit = word >> bit_nr & 1;
    	Value[i] = bit;
    }
	return XST_SUCCESS;
}

#endif
