/**
* Functions for reading and writing multiple configuration frames.
**/

#ifndef XHWICAP_MULTIFRAME_H_
#define XHWICAP_MULTIFRAME_H_


#include <xhwicap.h>
#include "xhwicap_custom.h"

/**
* Read multiple configuration frames.
* Based on the Xilinx source code to read one configuration frame.
**/
int XHwIcap_DeviceReadFrames(XHwIcap *InstancePtr, long Top, long Block,
				long HClkRow, long MajorFrame, long MinorFrame, u8 NumFrames,
				u32 *FrameBuffer);

/**
* Write multiple configuration frames.
* Based on the Xilinx source code to write one configuration frame.
**/
int XHwIcap_DeviceWriteFrames(XHwIcap *InstancePtr, long Top, long Block,
				long HClkRow, long MajorFrame, long MinorFrame, u8 NumFrames,
				u32 *FrameData);


#endif
