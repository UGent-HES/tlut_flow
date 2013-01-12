#include "treeMult4b.h"

inline Xuint8 getBit(int word,int i) {
    return (word & (1 << i)) != 0;
}

void setParameterbits(int word, int length, Xuint8 *parameter) {
    int i;
    for(i=0;i<length;i++)
        *(parameter++) = getBit(word, i);
}

void test(XHwIcap *HwIcap_p) {
	Xuint8 i,j, result, expectedResult, flag, allFlag = 0;
	const Xuint8 numMult = 13;
	const Xuint8 numInput = 9;
    Xuint8 mult[] = {0,1,3,7,15,31,63,127,255,20,40,80,160};
	Xuint8 input[] = {0,1,3,7,15,2,5,10,12};
	Xuint8 parameter[NUMBER_OF_PARAMETERS];
	Xuint8 output[NUMBER_OF_TLUTS_PER_INSTANCE][16];

    for(i=0; i<numMult; i++) {
        flag = 0;
        //xil_printf("Configuring the LUTs for p=x%x...\n\r",mult);
        setParameterbits(mult[i],8,parameter);
        evaluate(parameter,output);
        reconfigure(HwIcap_p,output,location_array[0]);
        //xil_printf("Configuration Complete!\n\r\n\r");
        for(j=0; j<numInput; j++) {
            //xil_printf("Writing %d to input register...\n\r",input);
            XIo_Out32(XPAR_OPB_MULT4B_0_BASEADDR, input[j]);
            result = XIo_In32(XPAR_OPB_MULT4B_0_BASEADDR+4);
            expectedResult = (input[j]*mult[i])&0xfff;
            /*xil_printf("Reading output register: x%03x (x%03x expected)\n\r",
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
    Xuint8 mult;
	Xuint8 parameter[NUMBER_OF_PARAMETERS];
	Xuint8 output[NUMBER_OF_TLUTS_PER_INSTANCE][16];

    mult = 0xff;
	xil_printf("Configuring the LUTs for p=x%x...\n\r",mult);
	setParameterbits(mult,8,parameter);
	evaluate(parameter,output);
	reconfigure(HwIcap_p,output,location_array[0]);
	/*for(i=0;i<12;i++) {
	    xil_printf("lut %d ",i);
	    for(j=0;j<16;j++)
	        xil_printf("%x",output[i][j]);
	    xil_printf("\n\r");
	}*/
	xil_printf("Configuration Complete!\n\r\n\r");
	input = 0xf;
	xil_printf("Writing %d to input register...\n\r",input);
	XIo_Out32(XPAR_OPB_MULT4B_0_BASEADDR, input);
	xil_printf("Reading output register: x%03x (x%03x expected)\n\r\n\r",
	    XIo_In32(XPAR_OPB_MULT4B_0_BASEADDR+4),
	    (input*mult)&0xfff);
}

int main(void) {
	static XHwIcap HwIcap;
	xil_printf("Starting mult4b test...\n\r");
	XHwIcap_Initialize(&HwIcap, HWICAP_DEVICEID, XHI_TARGET_DEVICEID);

    //manual_test(&HwIcap);
	test(&HwIcap);

	xil_printf("End mult4b test.\n\r\n\r");
	return 1;
}
