/**
* Functions for reading and writing multiple configuration frames.
**/
/***************************** Include Files ********************************/

#include <xil_types.h>
#include <xil_assert.h>
#include "xhwicap.h"
#include "xparameters.h"
#include "xhwicap_custom.h"

/************************** Constant Definitions ****************************/

static void StubStatusHandler(void *, u32 , u32 );
/*
 * This is a list of arrays that contain information about columns interspersed
 * into the CLB columns.  These are DSP, IOB, DCM, and clock tiles.  When these
 * are crossed, the frame address must be incremeneted by an additional count
 * from the CLB column index.  The center tile is skipped twice because it
 * contains both a DCM and a GCLK tile that must be skipped.
 * CXT SKIP column definitions are removed for the V6 devices as the existig
 * V6 Lx definitions are valid for CXT devices also.
 */

/* Zynq XC7Z020*/ /*The convention used here is specific to 7 series FPGA only!!*/
#if (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_ZYNQ)
/* Zynq XC7Z020*/ /*The convention used here is specific to 7 series FPGA only!!*/
u16 XHI_XC7Z020_SKIP_COLS[] = {0-1+1, 1-2+1, 6-3+1, 9-4+1, 14-5+1, 17-6+1, 22-7+1, 25-8+1,
				33-9+1, 36-10+1, 50-11+1/*invisible column*/, 56-12+1, 59-13+1, 64-14+1, 67-15+1, 0xFFFF};
#elif(XHI_FPGA_FAMILY == XHI_DEV_FAMILY_K7)
/* Kintex7 XC7K325*/ /*The convention used here is specific to 7 series FPGA only!!*/
u16 XHI_XC7K325T_SKIP_COLS[] = {0-1+1,1-2+1,6-3+1, 9-4+1, 14-5+1, 17-6+1, 24-7+1, 32-8+1, 35-9+1, 49-10+1,
						 62-11+1, 65-12+1, 71-13+1, 74-14+1, 80-15+1, 83-16+1, 89-17+1, 0xFFFF};
#endif


const DeviceDetails DeviceDetaillkup_custom[] = {
#if (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_ZYNQ)
		  {XHI_XC7Z020, 25 + 32, 50 + 100, 2 + 4, 2 + 3, 2, 0 , 3, XHI_XC7Z020_SKIP_COLS }
#elif (XHI_FPGA_FAMILY == XHI_DEV_FAMILY_K7)
		  {XHI_XC7K325T, 40+37, 350, 7, 6, 0, 0, 7, XHI_XC7K325T_SKIP_COLS}
#endif

};


/****************************************************************************/
/**
*
* This function initializes a specific XHwIcap instance.
* The IDCODE is read from the FPGA and based on the IDCODE the information
* about the resources in the FPGA is filled in the instance structure.
*
* The HwIcap device will be in put in a reset state before exiting this
* function.
*
* @param	InstancePtr is a pointer to the XHwIcap instance.
* @param	ConfigPtr points to the XHwIcap device configuration structure.
* @param	EffectiveAddr is the device base address in the virtual memory
*		address space. If the address translation is not used then the
*		physical address is passed.
*		Unexpected errors may occur if the address mapping is changed
*		after this function is invoked.
*
* @return	XST_SUCCESS else XST_FAILURE
*
* @note		None.
*
*****************************************************************************/
int XHwIcap_custom_CfgInitialize(XHwIcap *InstancePtr, XHwIcap_Config *ConfigPtr,
				u32 EffectiveAddr)
{
	int Status;
	u32 DeviceIdCode;
	u32 TempDevId;
	u8 DeviceIdIndex;
	u8 NumDevices;
	u8 IndexCount;
	int DeviceFound = FALSE;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(ConfigPtr != NULL);

	/*
	 * Set some default values.
	 */
	InstancePtr->IsReady = FALSE;
	InstancePtr->IsTransferInProgress = FALSE;
	InstancePtr->IsPolled = TRUE; /* Polled Mode */

	/*
	 * Set the device base address and stub handler.
	 */
	InstancePtr->HwIcapConfig.BaseAddress = EffectiveAddr;
	InstancePtr->StatusHandler = (XHwIcap_StatusHandler) StubStatusHandler;

	/** Set IcapWidth **/

	InstancePtr->HwIcapConfig.IcapWidth = ConfigPtr->IcapWidth;

	/** Set IsLiteMode **/
	InstancePtr->HwIcapConfig.IsLiteMode = ConfigPtr->IsLiteMode;

	/*
	 * Read the IDCODE from ICAP.
	 */

	/*
	 * Setting the IsReady of the driver temporarily so that
	 * we can read the IdCode of the device.
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

	/*
	 * Dummy Read of the IDCODE as the first data read from the
	 * ICAP has to be discarded (Due to the way the HW is designed).
	 */
	Status = XHwIcap_GetConfigReg(InstancePtr, XHI_IDCODE, &TempDevId);
	if (Status != XST_SUCCESS) {
		InstancePtr->IsReady = 0;
		return XST_FAILURE;
	}

	/*
	 * Read the IDCODE and mask out the version section of the DeviceIdCode.
	 */
	Status = XHwIcap_GetConfigReg(InstancePtr, XHI_IDCODE, &DeviceIdCode);
	if (Status != XST_SUCCESS) {
		InstancePtr->IsReady = 0;
		return XST_FAILURE;
	}

	DeviceIdCode = DeviceIdCode & XHI_DEVICE_ID_CODE_MASK;

#if (XHI_FAMILY != XHI_DEV_FAMILY_S6)
	Status = XHwIcap_CommandDesync(InstancePtr);
	InstancePtr->IsReady = 0;
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
#endif

#if XHI_FAMILY == XHI_DEV_FAMILY_V4 /* Virtex4 */

	DeviceIdIndex = 0;
	NumDevices = XHI_V4_NUM_DEVICES;

#elif XHI_FAMILY == XHI_DEV_FAMILY_V5 /* Virtex5 */

	DeviceIdIndex = XHI_V4_NUM_DEVICES;
	NumDevices = XHI_V5_NUM_DEVICES;

#elif XHI_FAMILY == XHI_DEV_FAMILY_V6 /* Virtex6 */

	DeviceIdIndex = XHI_V4_NUM_DEVICES +  XHI_V5_NUM_DEVICES;
	NumDevices = XHI_V6_NUM_DEVICES;

#elif XHI_FAMILY == XHI_DEV_FAMILY_S6 /* Spartan6 */

	DeviceIdIndex = XHI_V4_NUM_DEVICES +  XHI_V5_NUM_DEVICES +
			XHI_V6_NUM_DEVICES;
	NumDevices = XHI_S6_NUM_DEVICES;

#elif XHI_FAMILY == XHI_DEV_FAMILY_7SERIES /* 7Series */

	DeviceIdIndex = 0; /*specific to zynq*/
	NumDevices = 1;    /* Number of devices defined in DeviceDetaillkup_custom[]*/

#endif
	/*
	 * Find the device index
	 */
	for (IndexCount = 0; IndexCount < NumDevices; IndexCount++) {

		if (DeviceIdCode == DeviceDetaillkup_custom[DeviceIdIndex +
					IndexCount]. DeviceIdCode) {
			DeviceIdIndex += IndexCount;
			DeviceFound = TRUE;
			break;
		}
	}

	if (DeviceFound != TRUE) {
		return XST_FAILURE;
	}
	InstancePtr->DeviceIdCode = DeviceDetaillkup_custom[DeviceIdIndex].DeviceIdCode;
	InstancePtr->Rows = DeviceDetaillkup_custom[DeviceIdIndex].Rows;
	InstancePtr->Cols = DeviceDetaillkup_custom[DeviceIdIndex].Cols;
	InstancePtr->BramCols = DeviceDetaillkup_custom[DeviceIdIndex].BramCols;
	InstancePtr->DSPCols = DeviceDetaillkup_custom[DeviceIdIndex].DSPCols;
	InstancePtr->IOCols = DeviceDetaillkup_custom[DeviceIdIndex].IOCols;
	InstancePtr->MGTCols = DeviceDetaillkup_custom[DeviceIdIndex].MGTCols;
	InstancePtr->HClkRows = DeviceDetaillkup_custom[DeviceIdIndex].HClkRows;
	InstancePtr->SkipCols = DeviceDetaillkup_custom[DeviceIdIndex].SkipCols;
	InstancePtr->BytesPerFrame = XHI_NUM_FRAME_BYTES;

#if (XHI_FAMILY == XHI_DEV_FAMILY_S6)
	/*
	 * In Spartan6 devices the word is defined as 16 bit
	 */
	InstancePtr->WordsPerFrame = (InstancePtr->BytesPerFrame/2);
#else
	InstancePtr->WordsPerFrame = (InstancePtr->BytesPerFrame/4);
#endif
	InstancePtr->ClbBlockFrames = (4 +22*2 + 4*2 + 22*InstancePtr->Cols);
	InstancePtr->BramBlockFrames = (64*InstancePtr->BramCols);
	InstancePtr->BramIntBlockFrames = (22*InstancePtr->BramCols);

	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

	/*
	 * Reset the device.
	 */
	XHwIcap_Reset(InstancePtr);

	return XST_SUCCESS;
} /* end XHwIcap_custom_CfgInitialize() */

/*****************************************************************************/
/**
*
* This is a stub for the status callback. The stub is here in case the upper
* layers forget to set the handler.
*
* @param	CallBackRef is a pointer to the upper layer callback reference
* @param	StatusEvent is the event that just occurred.
* @param	WordCount is the number of words (32 bit) transferred up until
*		the event occurred.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void StubStatusHandler(void *CallBackRef, u32 StatusEvent, u32 ByteCount)
{
	Xil_AssertVoidAlways();
}

