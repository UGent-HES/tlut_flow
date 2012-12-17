#include "exorw32.h"

inline Xuint8 getBit(int word,int i) {
    return (word & (1 << i)) != 0;
}

void setParameterbits(int word, int length, Xuint8 *parameter) {
    int i;
    for(i=0;i<length;i++)
        *(parameter++) = getBit(word, i);
}

void test(XHwIcap *HwIcap_p) {
	Xuint8 i,j, flag, allFlag = 0;
	Xuint32 result, expectedResult;
	const Xuint8 numMask = 21;
	const Xuint8 numInput = 41;
    Xuint32 mask[] = {0x0000000a,1454372110u, 653633569u, 2915684295u, 4144509247u, 343569743u, 1487345061u, 2021812644u, 726218250u, 4005655701u, 4210087342u, 1692309861u, 240283320u, 3346954613u, 343451919u, 2260761855u, 1203918403u, 1348709999u, 461439274u, 1003497182u, 3676314568u};
	Xuint32 input[] = {0,1315213384u, 2029622535u, 31535344u, 350602637u, 739953251u, 1794192762u, 80034313u, 3371481055u, 258653546u, 1826970330u, 358159117u, 2237711500u, 969336453u, 472183228u, 222406172u, 3344124026u, 1232896548u, 2393820680u, 96207672u, 2884104468u, 1064176016u, 591349375u, 1925242111u, 2267340650u, 1349754991u, 3688545868u, 686511857u, 4037128844u, 472527743u, 1034717425u, 36838282u, 1504556062u, 1317414206u, 1519847596u, 1443498772u, 3267185399u, 3535834504u, 593213285u, 4835301u, 3268156592u};
	Xuint8 parameter[NUMBER_OF_PARAMETERS];
	Xuint8 output[NUMBER_OF_TLUTS_PER_INSTANCE][16];

    for(i=0; i<numMask; i++) {
        flag = 0;
        //xil_printf("Configuring the LUTs for p=x%x...\n\r",mult);
        setParameterbits(mask[i],32,parameter);
        evaluate(parameter,output);
        reconfigure(HwIcap_p,output,location_array[0]);
        //xil_printf("Configuration Complete!\n\r\n\r");
        for(j=0; j<numInput; j++) {
            //xil_printf("Writing %x to input register...\n\r",input);
            XIo_Out32(XPAR_OPB_XOR_0_BASEADDR, input[j]);
            result = XIo_In32(XPAR_OPB_XOR_0_BASEADDR+4);
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
	Xuint8 i,j;
	Xuint32 input;
    Xuint32 mask;
	Xuint8 parameter[NUMBER_OF_PARAMETERS];
	Xuint8 output[NUMBER_OF_TLUTS_PER_INSTANCE][16];

	mask = 0x0000000a;
	input = 0;
	xil_printf("Configuring the LUTs for p=x%x...\n\r",mask);
	setParameterbits(mask,32,parameter);
	evaluate(parameter,output);
	reconfigure(HwIcap_p,output,location_array[0]);
	/*for(i=0;i<12;i++) {
	    xil_printf("lut %d ",i);
	    for(j=0;j<16;j++)
	        xil_printf("%x",output[i][j]);
	    xil_printf("\n\r");
	}*/
	xil_printf("Configuration Complete!\n\r\n\r");
	xil_printf("Writing %x to input register...\n\r",input);
	XIo_Out32(XPAR_OPB_XOR_0_BASEADDR, input);
	xil_printf("Reading output register: x%x (x%x expected)\n\r\n\r",
	    XIo_In32(XPAR_OPB_XOR_0_BASEADDR+4),
	    (input^mask));
	mask = ~0xabababab;
	input = 0xffffffff;
	xil_printf("Configuring the LUTs for p=x%x...\n\r",mask);
	setParameterbits(mask,32,parameter);
	evaluate(parameter,output);
	reconfigure(HwIcap_p,output,location_array[0]);
	xil_printf("Configuration Complete!\n\r\n\r");
	xil_printf("Writing %x to input register...\n\r",input);
	XIo_Out32(XPAR_OPB_XOR_0_BASEADDR, input);
	xil_printf("Reading output register: x%x (x%x expected)\n\r\n\r",
	    XIo_In32(XPAR_OPB_XOR_0_BASEADDR+4),
	    (input^mask));}

int main(void) {
	static XHwIcap HwIcap;
	xil_printf("Starting EXOR test...\n\r\n\r");
	XHwIcap_Initialize(&HwIcap, HWICAP_DEVICEID, XHI_TARGET_DEVICEID);
    
    //manual_test(&HwIcap);
    test(&HwIcap);

	xil_printf("End EXOR test.\n\r\n\r");
	return 1;
}
