//////////////////////////////////////////////////////////////////////////////
// Filename:          /home/kheyse/private/tlut_flow/examples/treeMult4b/ise/drivers/opb_mult4b_v1_00_a/src/opb_mult4b.h
// Version:           1.00.a
// Description:       opb_mult4b Driver Header File
// Date:              Sat Dec  8 14:00:15 2012 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////

#ifndef OPB_MULT4B_H
#define OPB_MULT4B_H

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xio.h"

/************************** Constant Definitions ***************************/


/**
 * User Logic Slave Space Offsets
 * -- SLAVE_REG0 : user logic slave module register 0
 * -- SLAVE_REG1 : user logic slave module register 1
 */
#define OPB_MULT4B_USER_SLAVE_SPACE_OFFSET (0x00000000)
#define OPB_MULT4B_SLAVE_REG0_OFFSET (OPB_MULT4B_USER_SLAVE_SPACE_OFFSET + 0x00000000)
#define OPB_MULT4B_SLAVE_REG1_OFFSET (OPB_MULT4B_USER_SLAVE_SPACE_OFFSET + 0x00000004)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a OPB_MULT4B register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the OPB_MULT4B device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void OPB_MULT4B_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define OPB_MULT4B_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a OPB_MULT4B register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the OPB_MULT4B device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 OPB_MULT4B_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define OPB_MULT4B_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read value to/from OPB_MULT4B user logic slave registers.
 *
 * @param   BaseAddress is the base address of the OPB_MULT4B device.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 OPB_MULT4B_mReadSlaveRegn(Xuint32 BaseAddress)
 *
 */
#define OPB_MULT4B_mWriteSlaveReg0(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (OPB_MULT4B_SLAVE_REG0_OFFSET), (Xuint32)(Value))
#define OPB_MULT4B_mWriteSlaveReg1(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (OPB_MULT4B_SLAVE_REG1_OFFSET), (Xuint32)(Value))

#define OPB_MULT4B_mReadSlaveReg0(BaseAddress) \
 	XIo_In32((BaseAddress) + (OPB_MULT4B_SLAVE_REG0_OFFSET))
#define OPB_MULT4B_mReadSlaveReg1(BaseAddress) \
 	XIo_In32((BaseAddress) + (OPB_MULT4B_SLAVE_REG1_OFFSET))

/************************** Function Prototypes ****************************/


/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the OPB_MULT4B instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus OPB_MULT4B_SelfTest(void * baseaddr_p);

#endif // OPB_MULT4B_H
