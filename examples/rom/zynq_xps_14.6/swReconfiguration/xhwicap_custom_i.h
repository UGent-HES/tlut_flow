#ifndef XHWICAP_CUSTOM_I_H_ /* prevent circular inclusions */
#define XHWICAP_CUSTOM_I_H_ /* by using protection macros */


/* Macro definitions for 7 series FGPA */
#if (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
	#define XHI_NUM_FRAME_BYTES		404
	#define XHI_NUM_FRAME_WORDS		101
	#define XHI_NUM_WORDS_FRAME_INCL_NULL_FRAME  202
#endif

/*FAR bit locations, specific to 7 series FPGA family*/
#if(XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
	#define XHI_FAR_BLOCK_SHIFT_7 			23
	#define XHI_FAR_TOP_BOTTOM_SHIFT_7 		22
	#define XHI_FAR_ROW_ADDR_SHIFT_7 		17
	#define XHI_FAR_COLUMN_ADDR_SHIFT_7 	 7
	#define XHI_FAR_MINOR_ADDR_SHIFT_7 		 0
	#define UNUSED_BITS						26
#endif

/**
 *FAR setup for 7 series FPGA family
 */
#if(XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
#define XHwIcap_Custom_SetupFar7series(Top, Block, Row, ColumnAddress, MinorAddress)  \
		(Block << XHI_FAR_BLOCK_SHIFT_7) | \
		((Top << XHI_FAR_TOP_BOTTOM_SHIFT_7) | \
		(Row << XHI_FAR_ROW_ADDR_SHIFT_7) | \
		(ColumnAddress << XHI_FAR_COLUMN_ADDR_SHIFT_7) | \
		(MinorAddress << XHI_FAR_MINOR_ADDR_SHIFT_7))
#endif
#endif
