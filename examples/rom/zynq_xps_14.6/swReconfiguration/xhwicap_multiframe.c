/**
* Functions for reading and writing multiple configuration frames.
**/
#include "xhwicap_multiframe.h"

#define READ_FRAME_SIZE 60

/**
* Read multiple configuration frames.
* Based on the Xilinx source code to read one configuration frame.
**/
int XHwIcap_DeviceReadFrames(XHwIcap *InstancePtr, long Top, long Block,
				long HClkRow, long MajorFrame, long MinorFrame, u8 NumFrames,
				u32 *FrameBuffer)
{
	u32 Packet;
	u32 Data;
	u32 TotalWords;
	int Status;
	u32 WriteBuffer[READ_FRAME_SIZE];
	u32 Index = 0;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertNonvoid(FrameBuffer != NULL);

	/*
	 * DUMMY and SYNC
	 */
	WriteBuffer[Index++] = XHI_DUMMY_PACKET;
	WriteBuffer[Index++] = XHI_SYNC_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Reset CRC
	 */
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = XHI_CMD_RCRC;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Setup CMD register to read configuration
	 */
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = XHI_CMD_RCFG;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Setup FAR register.
	 */
	Packet = XHwIcap_Type1Write(XHI_FAR) | 1;
#if XHI_FAMILY == XHI_DEV_FAMILY_V4 /* Virtex4 */
	Data = XHwIcap_SetupFarV4(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V5) || (XHI_FAMILY == XHI_DEV_FAMILY_V6))
	Data = XHwIcap_SetupFarV5(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#elif (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
	Data = XHwIcap_Custom_SetupFar7series(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#endif

	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;

	/*
	 * Setup read data packet header.
	 * The frame will be preceeded by a dummy frame, and we need to read one
	 * extra word for V4 and V5 devices.
	 */
#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	TotalWords = (InstancePtr->WordsPerFrame * (NumFrames + 1) ) + 1;
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V6) || (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES))
	TotalWords = (InstancePtr->WordsPerFrame * (NumFrames + 1) ) + 1;
#endif

	/*
	 * Create Type one packet
	 */
	Packet = XHwIcap_Type1Read(XHI_FDRO) | 0;
	WriteBuffer[Index++] = Packet;
	/*
	 * Create Type two packet
	 */
	Packet = XHI_TYPE_2_READ | TotalWords;
	WriteBuffer[Index++] = Packet;

	u32 i;
	for(i=0; i<32; i++)
		WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Write the data to the FIFO and initiate the transfer of data
	 * present in the FIFO to the ICAP device
	 */
	Status = XHwIcap_DeviceWrite(InstancePtr, (u32 *)&WriteBuffer[0], Index);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	/*
	 * Wait till the write is done.
	 */
 	while (XHwIcap_IsDeviceBusy(InstancePtr) != FALSE);


	/*
	 * Read the frame of the data including the NULL frame.
	 */
	Status = XHwIcap_DeviceRead(InstancePtr, FrameBuffer, TotalWords);

	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	/*
	 * Send DESYNC command
	 */
	Status = XHwIcap_CommandDesync(InstancePtr);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
};

/**
* Write multiple configuration frames.
* Based on the Xilinx source code to write one configuration frame.
**/
int XHwIcap_DeviceWriteFrames(XHwIcap *InstancePtr, long Top, long Block,
				long HClkRow, long MajorFrame, long MinorFrame, u8 NumFrames,
				u32 *FrameData)
{
	u32 Packet;
	u32 Data;
	u32 TotalWords;
	int Status;
	u32 WriteBuffer[READ_FRAME_SIZE];
	u32 Index =0;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertNonvoid(FrameData != NULL);


	/*
	 * DUMMY and SYNC
	 */
	WriteBuffer[Index++] = XHI_DUMMY_PACKET;
	WriteBuffer[Index++] = XHI_SYNC_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Reset CRC
	 */
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	Data = XHI_CMD_RCRC;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;


	/*
	 * Bypass CRC
	 */
#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	Packet = XHwIcap_Type1Write(XHI_COR) | 1;
	Data = 0x10042FDD;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;
#endif
	/*
	 * ID register
	 */
	Packet = XHwIcap_Type1Write(XHI_IDCODE) | 1;
	Data = InstancePtr->DeviceIdCode;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;


	/*
	 * Setup FAR
	 */
	Packet = XHwIcap_Type1Write(XHI_FAR) | 1;
#if XHI_FAMILY == XHI_DEV_FAMILY_V4 /* Virtex 4 */
	Data = XHwIcap_SetupFarV4(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V5) || (XHI_FAMILY == XHI_DEV_FAMILY_V6)) /* Virtex 5 and Virtex 6 */
	Data = XHwIcap_SetupFarV5(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#elif (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES) /* 7 series FPGAs */
	Data = XHwIcap_Custom_SetupFar7series(Top, Block, HClkRow,  MajorFrame, MinorFrame);
#endif

	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;

	/*
	 * Setup CMD register - write configuration
	 */
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	Data = XHI_CMD_WCFG;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;

	/*
	 * Setup Packet header.
	 */
	TotalWords = InstancePtr->WordsPerFrame * (NumFrames + 1);


	if (TotalWords < XHI_TYPE_1_PACKET_MAX_WORDS)  {
		/*
		 * Create Type 1 Packet.
		 */
		Packet = XHwIcap_Type1Write(XHI_FDRI) | TotalWords;
		WriteBuffer[Index++] = Packet;
	}
	else {

		/*
		 * Create Type 2 Packet.
		 */
		Packet = XHwIcap_Type1Write(XHI_FDRI);
		WriteBuffer[Index++] = Packet;

		Packet = XHI_TYPE_2_WRITE | TotalWords;
		WriteBuffer[Index++] = Packet;
	}


	/*
	 * Write the Header data into the FIFO and initiate the transfer of
	 * data present in the FIFO to the ICAP device
	 */
	Status = XHwIcap_DeviceWrite(InstancePtr, (u32 *)&WriteBuffer[0], Index);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	/*
	 * Write the modified frame data.
	 */
#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	Status = XHwIcap_DeviceWrite(InstancePtr,
				(u32 *) &FrameData[InstancePtr->WordsPerFrame + 1],
				InstancePtr->WordsPerFrame*NumFrames);
#elif (XHI_FAMILY == XHI_DEV_FAMILY_V6) /* Virtex 6 */
	Status = XHwIcap_DeviceWrite(InstancePtr,
				(u32 *) &FrameData[InstancePtr->WordsPerFrame],
				InstancePtr->WordsPerFrame*NumFrames);
#elif (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
	Status = XHwIcap_DeviceWrite(InstancePtr,
				(u32 *) &FrameData[InstancePtr->WordsPerFrame + 1],
				InstancePtr->WordsPerFrame*NumFrames);
#endif
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Write out the pad frame. The pad frame was read from the device
	 * before the data frame.
	 */

#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	Status = XHwIcap_DeviceWrite(InstancePtr, (u32 *) &FrameData[1],
				    InstancePtr->WordsPerFrame);
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V6) || (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)) /* Virtex6 and 7 series*/
	Status = XHwIcap_DeviceWrite(InstancePtr, (u32 *) &FrameData[1],
				    InstancePtr->WordsPerFrame);
#endif
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/* Add CRC */
	Index = 0;
#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	Packet = XHwIcap_Type1Write(XHI_CRC) | 1;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = XHI_DISABLED_AUTO_CRC;
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V6) || (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)) /* Virtex6 and 7 series*/
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	Data = XHI_CMD_RCRC;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
#endif

	/* Park the FAR */
	Packet = XHwIcap_Type1Write(XHI_FAR) | 1;

#if XHI_FAMILY == XHI_DEV_FAMILY_V4 /* Virtex4 */
	Data = XHwIcap_SetupFarV4(0, 0, 3, 33, 0);
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V5) || (XHI_FAMILY == XHI_DEV_FAMILY_V6))
	Data = XHwIcap_SetupFarV5(0, 0, 3, 33, 0);
#elif (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES)
	Data = XHwIcap_Custom_SetupFar7series(0, 0, 3, 33, 0);
#endif

	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] =  Data;

	/* Add CRC */
#if ((XHI_FAMILY == XHI_DEV_FAMILY_V4) || (XHI_FAMILY == XHI_DEV_FAMILY_V5))
	Packet = XHwIcap_Type1Write(XHI_CRC) | 1;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = XHI_DISABLED_AUTO_CRC;
#elif ((XHI_FAMILY == XHI_DEV_FAMILY_V6) || (XHI_FAMILY == XHI_DEV_FAMILY_7SERIES))
	Packet = XHwIcap_Type1Write(XHI_CMD) | 1;
	Data = XHI_CMD_RCRC;
	WriteBuffer[Index++] = Packet;
	WriteBuffer[Index++] = Data;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
	WriteBuffer[Index++] = XHI_NOOP_PACKET;
#endif

	/*
	 * Intiate the transfer of data present in the FIFO to
	 * the ICAP device
	 */
	Status = XHwIcap_DeviceWrite(InstancePtr, &WriteBuffer[0], Index);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	/*
	 * Send DESYNC command
	 */
	Status = XHwIcap_CommandDesync(InstancePtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
};



