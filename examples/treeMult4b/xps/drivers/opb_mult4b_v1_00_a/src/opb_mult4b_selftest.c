//////////////////////////////////////////////////////////////////////////////
// Filename:          /home/kheyse/private/tlut_flow/examples/treeMult4b/ise/drivers/opb_mult4b_v1_00_a/src/opb_mult4b_selftest.c
// Version:           1.00.a
// Description:       Contains a diagnostic self-test function for the opb_mult4b driver
// Date:              Sat Dec  8 14:00:15 2012 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////


/***************************** Include Files *******************************/

#include "opb_mult4b.h"

/************************** Constant Definitions ***************************/


/************************** Variable Definitions ****************************/


/************************** Function Definitions ***************************/

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
XStatus OPB_MULT4B_SelfTest(void * baseaddr_p)
{
   int     Index;
   Xuint32 baseaddr;
   Xuint8  Reg8Value;
   Xuint16 Reg16Value;
   Xuint32 Reg32Value;
   Xuint64 Reg64Value;

   /*
    * Assert the argument
    */
   XASSERT_NONVOID(baseaddr_p != XNULL);
   baseaddr = (Xuint32) baseaddr_p;

   xil_printf("******************************\n\r");
   xil_printf("* User Peripheral Self Test\n\r");
   xil_printf("******************************\n\n\r");

   /*
    * Write to user logic slave module register(s) and read back
    */
   xil_printf("User logic slave module test...\n\r");
   xil_printf("   - write 1 to slave register 0\n\r");
   OPB_MULT4B_mWriteSlaveReg0(baseaddr, 1);
   Reg32Value = OPB_MULT4B_mReadSlaveReg0(baseaddr);
   xil_printf("   - read %d from register 0\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 1 )
   {
      xil_printf("   - slave register 0 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - write 2 to slave register 1\n\r");
   OPB_MULT4B_mWriteSlaveReg1(baseaddr, 2);
   Reg32Value = OPB_MULT4B_mReadSlaveReg1(baseaddr);
   xil_printf("   - read %d from register 1\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 2 )
   {
      xil_printf("   - slave register 1 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - slave register write/read passed\n\n\r");

   return XST_SUCCESS;
}
