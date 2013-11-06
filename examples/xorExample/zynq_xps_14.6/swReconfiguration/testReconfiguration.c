#include "exorw32.h"
#include "stdio.h"
#include "xil_io.h"

#include "xparameters.h"	/* XPAR parameters */
#include "xhwicap.h"		/* HwIcap device driver */
#include "xscugic.h"        /* Interrupts driver */
#include "xdevcfg.h"
#include "xdevcfg_hw.h"


#define HWICAP_DEVICE_ID		XPAR_HWICAP_0_DEVICE_ID
#define INTC_DEVICE_ID			XPAR_PS7_SCUGIC_0_DEVICE_ID
#define HWICAP_IRPT_INTR		XPAR_FABRIC_AXI_HWICAP_0_IP2INTC_IRPT_INTR
#define DCFG_DEVICE_ID			XPAR_XDCFG_0_DEVICE_ID

static XDcfg DcfgInstance;   /* Device Configuration Interface Instance */

inline u8 getBit(int word,int i) {
    return (word & (1 << i)) != 0;
}

void setParameterbits(int word, int length, u8 *parameter) {
    int i;
    for(i=0;i<length;i++)
        *(parameter++) = getBit(word, i);
}

void test(XHwIcap *HwIcap_p) {
	u8 i,j, flag, allFlag = 0;
	u32 result, expectedResult;
	const u8 numMask = 21;
	const u8 numInput = 41;
    u32 mask[] = {0x0000000a,1454372110u, 653633569u, 2915684295u, 4144509247u, 343569743u, 1487345061u, 2021812644u, 726218250u, 4005655701u, 4210087342u, 1692309861u, 240283320u, 3346954613u, 343451919u, 2260761855u, 1203918403u, 1348709999u, 461439274u, 1003497182u, 3676314568u};
	u32 input[] = {0,1315213384u, 2029622535u, 31535344u, 350602637u, 739953251u, 1794192762u, 80034313u, 3371481055u, 258653546u, 1826970330u, 358159117u, 2237711500u, 969336453u, 472183228u, 222406172u, 3344124026u, 1232896548u, 2393820680u, 96207672u, 2884104468u, 1064176016u, 591349375u, 1925242111u, 2267340650u, 1349754991u, 3688545868u, 686511857u, 4037128844u, 472527743u, 1034717425u, 36838282u, 1504556062u, 1317414206u, 1519847596u, 1443498772u, 3267185399u, 3535834504u, 593213285u, 4835301u, 3268156592u};
	u8 parameter[NUMBER_OF_PARAMETERS];
	u8 output[NUMBER_OF_TLUTS_PER_INSTANCE][LUT_CONFIG_WIDTH];

    for(i=0; i<numMask; i++) {
        flag = 0;
        //xil_printf("Configuring the LUTs for p=x%x...\n\r",mult);
        setParameterbits(mask[i],32,parameter);
        evaluate(parameter,output);
        reconfigure(HwIcap_p,output,location_array[0]);
        //xil_printf("Configuration Complete!\n\r\n\r");
        for(j=0; j<numInput; j++) {
            //xil_printf("Writing %x to input register...\n\r",input);
            Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, input[j]);
            result = Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4);
            expectedResult = input[j]^mask[i];
            /*xil_printf("Reading output register: x%x (x%x expected)\n\r",
                result,
                expectedResult);*/
            if(result != expectedResult)
                xil_printf("Test %d.%d failed\n\r",i,j);
            flag |= (result != expectedResult);
        }
        if(!flag)
            xil_printf("Test %d succeeded\n\r",i);
        allFlag |= flag;
    }
    if(!allFlag)
        xil_printf("All tests succeeded\n\r",i);
    else
        xil_printf("Some test failed\n\r",i);
}

void manual_test(XHwIcap *HwIcap_p) {
	u32 input = 0;
    u32 mask = 0;
	u8 parameter[NUMBER_OF_PARAMETERS];
	u8 output[NUMBER_OF_TLUTS_PER_INSTANCE][LUT_CONFIG_WIDTH];

	xil_printf("Starting Manual test. . . \n\r\n\r");
	xil_printf("Writing x%08x to the register. \n\r", input);
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, input); 							//Writing a value to the Register

	xil_printf("Reading output register: x%08x (x%08x expected)\n\r\n\r",
	Xil_In32(XPAR_AXI_XOR_0_BASEADDR + 4), (input^mask));				//Reading the value from the Register

	xil_printf("Writing x%08x to the register. \n\r", ~input);
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, ~input); 						//Writing a value to the Register

	xil_printf("Reading output register: x%08x (x%08x expected)\n\r\n\r",
	    Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4),
	    (~input^mask));

	mask = ~0;//~0x0000000a;
	input = 0;
	xil_printf("Configuring the LUTs for p=x%x...\n\r",mask);
	setParameterbits(mask,NUMBER_OF_PARAMETERS,parameter);
	xil_printf("Set Parameters Complete!\n\r\n\r");
	evaluate(parameter,output);
	xil_printf("Evaluation Complete!\n\r\n\r");

	reconfigure(HwIcap_p,output,location_array[0]);//,output_read);

	/*u8 i,j;
	for(i=0;i<NUMBER_OF_TLUTS_PER_INSTANCE;i++) {
	    xil_printf("lut %d ",i);
	    for(j=0;j<LUT_CONFIG_WIDTH;j++)
	        xil_printf("%x",output[i][j]);
	    xil_printf("\n\r");
	}*/

	xil_printf("Configuration Complete!\n\r\n\r");
	xil_printf("Writing %x to input register...\n\r",input);
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, input);
	xil_printf("Reading output register: x%08x (x%08x expected)\n\r",
	    Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4),
	    (input^mask));
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, ~input);
	xil_printf("Reading output register: x%08x (x%08x expected)\n\r\n\r",
	    Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4),
	    (~input^mask));
	mask = 0;//0xabababab;
	input = 0;//0xffffffff;
	xil_printf("Configuring the LUTs for p=x%x...\n\r",mask);
	setParameterbits(mask,NUMBER_OF_PARAMETERS,parameter);
	evaluate(parameter,output);
	reconfigure(HwIcap_p,output,location_array[0]);//,output_read);
	xil_printf("Configuration Complete!\n\r\n\r");
	xil_printf("Writing %x to input register...\n\r",input);
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, input);
	xil_printf("Reading output register: x%08x (x%08x expected)\n\r",
	    Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4),
	    (input^mask));
	Xil_Out32(XPAR_AXI_XOR_0_BASEADDR, ~input);
	xil_printf("Reading output register: x%08x (x%08x expected)\n\r\n\r",
	    Xil_In32(XPAR_AXI_XOR_0_BASEADDR+4),
	    (~input^mask));
}

void remove_pcap(void)
{
	int Status;
	XDcfg_Config *ConfigPtr0;

	ConfigPtr0 = XDcfg_LookupConfig(DCFG_DEVICE_ID);

	Status = XDcfg_CfgInitialize(&DcfgInstance, ConfigPtr0,
					ConfigPtr0->BaseAddr);
	if (Status != XST_SUCCESS) {
		print("DevConfig - Fail !\n\r");
	}

	/*
	 * Run the Self Test.
	 */
	Status = XDcfg_SelfTest(&DcfgInstance);
	if (Status != XST_SUCCESS) {
		print("SelftTest - Fail !\n\r");
	}

	XDcfg_SelectIcapInterface(&DcfgInstance);
}

int main(void) {
	remove_pcap();
	static XHwIcap HwIcap;

	u8 user_test = 1; /*User Switch for 0-Manual/1-Automated test */

	/*Test case selection*/
	if(user_test == 0){
		xil_printf("Starting EXOR test(Manual)...\n\r\n\r");
	}
	else{
		xil_printf("Starting EXOR test...\n\r\n\r");
	}

	/* Instantiate the HWICAP */
	XHwIcap_Config *CfgPtr = XHwIcap_LookupConfig(HWICAP_DEVICEID);
	if (CfgPtr == NULL) {
		xil_printf("Config PTR failure!!!!\n\r\n\r");
		return XST_FAILURE;
	}
	else{
		xil_printf("Config PTR Success...\n\r\n\r");
	}

	/*Initialize the HWICAP*/
	int Status = XHwIcap_custom_CfgInitialize(&HwIcap, CfgPtr, CfgPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Config Initialization failure!!!!\n\r\n\r");
		return XST_FAILURE;
	}
	else{
		xil_printf("Config Initialization Success...\n\r\n\r");
	}

	//XDcfg_SelectIcapInterface((XDcfg*)&HwIcap);
	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XHwIcap_SelfTest(&HwIcap);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	if(user_test == 0){
		manual_test(&HwIcap);
	}
	else{
		test(&HwIcap);
	}

	xil_printf("End EXOR test.\n\r\n\r");
	return 0;
}

