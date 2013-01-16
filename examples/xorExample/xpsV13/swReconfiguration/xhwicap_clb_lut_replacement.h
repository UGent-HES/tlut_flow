/******************************************************************************
*
* (c) Copyright 2003-2010 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/****************************************************************************/
/**
*
* @file xhwicap_clb_lut_replacement.h
*
* Replacement for xhwicap_clb_lut.h for Virtex-5 FPGAs
* Created by Ghent University
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a kh   01/16/13 First release
* </pre>
*
*****************************************************************************/
#ifndef XHWICAP_CLB_LUT_REPLACEMENT_H_  /* prevent circular inclusions */
#define XHWICAP_CLB_LUT_REPLACEMENT_H_  /* by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

#if XHI_FAMILY == XHI_DEV_FAMILY_V5 /* Virtex5 */



/**************************** Type Definitions ******************************/

typedef struct {
	const u8 CONTENTS[3][4][64][2];
} XHwIcap_ClbLut_replacement;

#define L_OFFSET 32
#define M_OFFSET 26
	const XHwIcap_ClbLut_replacement XHI_CLB_LUT =
	{
	   /* CONTENTS*/
	   {
	      /* Type 0, Slice M. */
	      {
	         /* LE 0. LUTA*/
	         {
				/* Icle_ll.ISL.LUTA */

				/* LSb to MSb, offset, minor */
				 {15,1+L_OFFSET}, {15,0+L_OFFSET}, {15,3+L_OFFSET}, {15,2+L_OFFSET}, {14,0+L_OFFSET}, {14,1+L_OFFSET}, {14,2+L_OFFSET}, {14,3+L_OFFSET},
				 {13,1+L_OFFSET}, {13,0+L_OFFSET}, {13,3+L_OFFSET}, {13,2+L_OFFSET}, {12,0+L_OFFSET}, {12,1+L_OFFSET}, {12,2+L_OFFSET}, {12,3+L_OFFSET},
				 {11,1+L_OFFSET}, {11,0+L_OFFSET}, {11,3+L_OFFSET}, {11,2+L_OFFSET}, {10,0+L_OFFSET}, {10,1+L_OFFSET}, {10,2+L_OFFSET}, {10,3+L_OFFSET},
				 {9,1+L_OFFSET}, {9,0+L_OFFSET}, {9,3+L_OFFSET}, {9,2+L_OFFSET}, {8,0+L_OFFSET}, {8,1+L_OFFSET}, {8,2+L_OFFSET}, {8,3+L_OFFSET},
				 {7,1+L_OFFSET}, {7,0+L_OFFSET}, {7,3+L_OFFSET}, {7,2+L_OFFSET}, {6,0+L_OFFSET}, {6,1+L_OFFSET}, {6,2+L_OFFSET}, {6,3+L_OFFSET},
				 {5,1+L_OFFSET}, {5,0+L_OFFSET}, {5,3+L_OFFSET}, {5,2+L_OFFSET}, {4,0+L_OFFSET}, {4,1+L_OFFSET}, {4,2+L_OFFSET}, {4,3+L_OFFSET},
				 {3,1+L_OFFSET}, {3,0+L_OFFSET}, {3,3+L_OFFSET}, {3,2+L_OFFSET}, {2,0+L_OFFSET}, {2,1+L_OFFSET}, {2,2+L_OFFSET}, {2,3+L_OFFSET},
				 {1,1+L_OFFSET}, {1,0+L_OFFSET}, {1,3+L_OFFSET}, {1,2+L_OFFSET}, {0,0+L_OFFSET}, {0,1+L_OFFSET}, {0,2+L_OFFSET}, {0,3+L_OFFSET}
	  	 },
	         /* LE 1. LUTB*/
	         {
				/* Icle_ll.ISL.LUTB */

				/* LSb to MSb, offset, minor */
				 {31,1+L_OFFSET}, {31,0+L_OFFSET}, {31,3+L_OFFSET}, {31,2+L_OFFSET}, {30,0+L_OFFSET}, {30,1+L_OFFSET}, {30,2+L_OFFSET}, {30,3+L_OFFSET},
				 {29,1+L_OFFSET}, {29,0+L_OFFSET}, {29,3+L_OFFSET}, {29,2+L_OFFSET}, {28,0+L_OFFSET}, {28,1+L_OFFSET}, {28,2+L_OFFSET}, {28,3+L_OFFSET},
				 {27,1+L_OFFSET}, {27,0+L_OFFSET}, {27,3+L_OFFSET}, {27,2+L_OFFSET}, {26,0+L_OFFSET}, {26,1+L_OFFSET}, {26,2+L_OFFSET}, {26,3+L_OFFSET},
				 {25,1+L_OFFSET}, {25,0+L_OFFSET}, {25,3+L_OFFSET}, {25,2+L_OFFSET}, {24,0+L_OFFSET}, {24,1+L_OFFSET}, {24,2+L_OFFSET}, {24,3+L_OFFSET},
				 {23,1+L_OFFSET}, {23,0+L_OFFSET}, {23,3+L_OFFSET}, {23,2+L_OFFSET}, {22,0+L_OFFSET}, {22,1+L_OFFSET}, {22,2+L_OFFSET}, {22,3+L_OFFSET},
				 {21,1+L_OFFSET}, {21,0+L_OFFSET}, {21,3+L_OFFSET}, {21,2+L_OFFSET}, {20,0+L_OFFSET}, {20,1+L_OFFSET}, {20,2+L_OFFSET}, {20,3+L_OFFSET},
				 {19,1+L_OFFSET}, {19,0+L_OFFSET}, {19,3+L_OFFSET}, {19,2+L_OFFSET}, {18,0+L_OFFSET}, {18,1+L_OFFSET}, {18,2+L_OFFSET}, {18,3+L_OFFSET},
				 {17,1+L_OFFSET}, {17,0+L_OFFSET}, {17,3+L_OFFSET}, {17,2+L_OFFSET}, {16,0+L_OFFSET}, {16,1+L_OFFSET}, {16,2+L_OFFSET}, {16,3+L_OFFSET}
	         },
	         /* LE 2. LUTC*/
	         {
				/* Icle_ll.ISL.LUTC */

				/* LSb to MSb, offset, minor */
				 {47,1+L_OFFSET}, {47,0+L_OFFSET}, {47,3+L_OFFSET}, {47,2+L_OFFSET}, {46,0+L_OFFSET}, {46,1+L_OFFSET}, {46,2+L_OFFSET}, {46,3+L_OFFSET},
				 {45,1+L_OFFSET}, {45,0+L_OFFSET}, {45,3+L_OFFSET}, {45,2+L_OFFSET}, {44,0+L_OFFSET}, {44,1+L_OFFSET}, {44,2+L_OFFSET}, {44,3+L_OFFSET},
				 {43,1+L_OFFSET}, {43,0+L_OFFSET}, {43,3+L_OFFSET}, {43,2+L_OFFSET}, {42,0+L_OFFSET}, {42,1+L_OFFSET}, {42,2+L_OFFSET}, {42,3+L_OFFSET},
				 {41,1+L_OFFSET}, {41,0+L_OFFSET}, {41,3+L_OFFSET}, {41,2+L_OFFSET}, {40,0+L_OFFSET}, {40,1+L_OFFSET}, {40,2+L_OFFSET}, {40,3+L_OFFSET},
				 {39,1+L_OFFSET}, {39,0+L_OFFSET}, {39,3+L_OFFSET}, {39,2+L_OFFSET}, {38,0+L_OFFSET}, {38,1+L_OFFSET}, {38,2+L_OFFSET}, {38,3+L_OFFSET},
				 {37,1+L_OFFSET}, {37,0+L_OFFSET}, {37,3+L_OFFSET}, {37,2+L_OFFSET}, {36,0+L_OFFSET}, {36,1+L_OFFSET}, {36,2+L_OFFSET}, {36,3+L_OFFSET},
				 {35,1+L_OFFSET}, {35,0+L_OFFSET}, {35,3+L_OFFSET}, {35,2+L_OFFSET}, {34,0+L_OFFSET}, {34,1+L_OFFSET}, {34,2+L_OFFSET}, {34,3+L_OFFSET},
				 {33,1+L_OFFSET}, {33,0+L_OFFSET}, {33,3+L_OFFSET}, {33,2+L_OFFSET}, {32,0+L_OFFSET}, {32,1+L_OFFSET}, {32,2+L_OFFSET}, {32,3+L_OFFSET}
	         },
	         /* LE 3. LUTD*/
	         {
				/* Icle_ll.ISL.LUTD */

				/* LSb to MSb, offset, minor */
				 {63,1+L_OFFSET}, {63,0+L_OFFSET}, {63,3+L_OFFSET}, {63,2+L_OFFSET}, {62,0+L_OFFSET}, {62,1+L_OFFSET}, {62,2+L_OFFSET}, {62,3+L_OFFSET},
				 {61,1+L_OFFSET}, {61,0+L_OFFSET}, {61,3+L_OFFSET}, {61,2+L_OFFSET}, {60,0+L_OFFSET}, {60,1+L_OFFSET}, {60,2+L_OFFSET}, {60,3+L_OFFSET},
				 {59,1+L_OFFSET}, {59,0+L_OFFSET}, {59,3+L_OFFSET}, {59,2+L_OFFSET}, {58,0+L_OFFSET}, {58,1+L_OFFSET}, {58,2+L_OFFSET}, {58,3+L_OFFSET},
				 {57,1+L_OFFSET}, {57,0+L_OFFSET}, {57,3+L_OFFSET}, {57,2+L_OFFSET}, {56,0+L_OFFSET}, {56,1+L_OFFSET}, {56,2+L_OFFSET}, {56,3+L_OFFSET},
				 {55,1+L_OFFSET}, {55,0+L_OFFSET}, {55,3+L_OFFSET}, {55,2+L_OFFSET}, {54,0+L_OFFSET}, {54,1+L_OFFSET}, {54,2+L_OFFSET}, {54,3+L_OFFSET},
				 {53,1+L_OFFSET}, {53,0+L_OFFSET}, {53,3+L_OFFSET}, {53,2+L_OFFSET}, {52,0+L_OFFSET}, {52,1+L_OFFSET}, {52,2+L_OFFSET}, {52,3+L_OFFSET},
				 {51,1+L_OFFSET}, {51,0+L_OFFSET}, {51,3+L_OFFSET}, {51,2+L_OFFSET}, {50,0+L_OFFSET}, {50,1+L_OFFSET}, {50,2+L_OFFSET}, {50,3+L_OFFSET},
				 {49,1+L_OFFSET}, {49,0+L_OFFSET}, {49,3+L_OFFSET}, {49,2+L_OFFSET}, {48,0+L_OFFSET}, {48,1+L_OFFSET}, {48,2+L_OFFSET}, {48,3+L_OFFSET},
	         }
	      },
	      /* Type 1. Slice L odd */
	      {
	         /* LE 0. LUTA*/
	         {
				/* Icle_lm.ISL.LUTA */

				/* LSb to MSb, offset, minor */
				 {15,3+M_OFFSET}, {15,2+M_OFFSET}, {15,0+M_OFFSET}, {15,1+M_OFFSET}, {14,2+M_OFFSET}, {14,3+M_OFFSET}, {14,1+M_OFFSET}, {14,0+M_OFFSET},
				 {13,3+M_OFFSET}, {13,2+M_OFFSET}, {13,0+M_OFFSET}, {13,1+M_OFFSET}, {12,2+M_OFFSET}, {12,3+M_OFFSET}, {12,1+M_OFFSET}, {12,0+M_OFFSET},
				 {11,3+M_OFFSET}, {11,2+M_OFFSET}, {11,0+M_OFFSET}, {11,1+M_OFFSET}, {10,2+M_OFFSET}, {10,3+M_OFFSET}, {10,1+M_OFFSET}, {10,0+M_OFFSET},
				 {9,3+M_OFFSET}, {9,2+M_OFFSET}, {9,0+M_OFFSET}, {9,1+M_OFFSET}, {8,2+M_OFFSET}, {8,3+M_OFFSET}, {8,1+M_OFFSET}, {8,0+M_OFFSET},
				 {7,3+M_OFFSET}, {7,2+M_OFFSET}, {7,0+M_OFFSET}, {7,1+M_OFFSET}, {6,2+M_OFFSET}, {6,3+M_OFFSET}, {6,1+M_OFFSET}, {6,0+M_OFFSET},
				 {5,3+M_OFFSET}, {5,2+M_OFFSET}, {5,0+M_OFFSET}, {5,1+M_OFFSET}, {4,2+M_OFFSET}, {4,3+M_OFFSET}, {4,1+M_OFFSET}, {4,0+M_OFFSET},
				 {3,3+M_OFFSET}, {3,2+M_OFFSET}, {3,0+M_OFFSET}, {3,1+M_OFFSET}, {2,2+M_OFFSET}, {2,3+M_OFFSET}, {2,1+M_OFFSET}, {2,0+M_OFFSET},
				 {1,3+M_OFFSET}, {1,2+M_OFFSET}, {1,0+M_OFFSET}, {1,1+M_OFFSET}, {0,2+M_OFFSET}, {0,3+M_OFFSET}, {0,1+M_OFFSET}, {0,0+M_OFFSET}
			},
	         /* LE 1. LUTB*/
	         {
				/* Icle_lm.ISL.LUTB */

				/* LSb to MSb, offset, minor */
	        	{31,3+M_OFFSET}, {31,2+M_OFFSET}, {31,0+M_OFFSET}, {31,1+M_OFFSET}, {30,2+M_OFFSET}, {30,3+M_OFFSET}, {30,1+M_OFFSET}, {30,0+M_OFFSET},
				{29,3+M_OFFSET}, {29,2+M_OFFSET}, {29,0+M_OFFSET}, {29,1+M_OFFSET}, {28,2+M_OFFSET}, {28,3+M_OFFSET}, {28,1+M_OFFSET}, {28,0+M_OFFSET},
				{27,3+M_OFFSET}, {27,2+M_OFFSET}, {27,0+M_OFFSET}, {27,1+M_OFFSET}, {26,2+M_OFFSET}, {26,3+M_OFFSET}, {26,1+M_OFFSET}, {26,0+M_OFFSET},
				{25,3+M_OFFSET}, {25,2+M_OFFSET}, {25,0+M_OFFSET}, {25,1+M_OFFSET}, {24,2+M_OFFSET}, {24,3+M_OFFSET}, {24,1+M_OFFSET}, {24,0+M_OFFSET},
				{23,3+M_OFFSET}, {23,2+M_OFFSET}, {23,0+M_OFFSET}, {23,1+M_OFFSET}, {22,2+M_OFFSET}, {22,3+M_OFFSET}, {22,1+M_OFFSET}, {22,0+M_OFFSET},
				{21,3+M_OFFSET}, {21,2+M_OFFSET}, {21,0+M_OFFSET}, {21,1+M_OFFSET}, {20,2+M_OFFSET}, {20,3+M_OFFSET}, {20,1+M_OFFSET}, {20,0+M_OFFSET},
				{19,3+M_OFFSET}, {19,2+M_OFFSET}, {19,0+M_OFFSET}, {19,1+M_OFFSET}, {18,2+M_OFFSET}, {18,3+M_OFFSET}, {18,1+M_OFFSET}, {18,0+M_OFFSET},
				{17,3+M_OFFSET}, {17,2+M_OFFSET}, {17,0+M_OFFSET}, {17,1+M_OFFSET}, {16,2+M_OFFSET}, {16,3+M_OFFSET}, {16,1+M_OFFSET}, {16,0+M_OFFSET},
	         },
	         /* LE 2. LUTC*/
	         {
				/* Icle_lm.ISL.LUTC */

				/* LSb to MSb, offset, minor */
				 {47,3+M_OFFSET}, {47,2+M_OFFSET}, {47,0+M_OFFSET}, {47,1+M_OFFSET}, {46,2+M_OFFSET}, {46,3+M_OFFSET}, {46,1+M_OFFSET}, {46,0+M_OFFSET},
				 {45,3+M_OFFSET}, {45,2+M_OFFSET}, {45,0+M_OFFSET}, {45,1+M_OFFSET}, {44,2+M_OFFSET}, {44,3+M_OFFSET}, {44,1+M_OFFSET}, {44,0+M_OFFSET},
				 {43,3+M_OFFSET}, {43,2+M_OFFSET}, {43,0+M_OFFSET}, {43,1+M_OFFSET}, {42,2+M_OFFSET}, {42,3+M_OFFSET}, {42,1+M_OFFSET}, {42,0+M_OFFSET},
				 {41,3+M_OFFSET}, {41,2+M_OFFSET}, {41,0+M_OFFSET}, {41,1+M_OFFSET}, {40,2+M_OFFSET}, {40,3+M_OFFSET}, {40,1+M_OFFSET}, {40,0+M_OFFSET},
				 {39,3+M_OFFSET}, {39,2+M_OFFSET}, {39,0+M_OFFSET}, {39,1+M_OFFSET}, {38,2+M_OFFSET}, {38,3+M_OFFSET}, {38,1+M_OFFSET}, {38,0+M_OFFSET},
				 {37,3+M_OFFSET}, {37,2+M_OFFSET}, {37,0+M_OFFSET}, {37,1+M_OFFSET}, {36,2+M_OFFSET}, {36,3+M_OFFSET}, {36,1+M_OFFSET}, {36,0+M_OFFSET},
				 {35,3+M_OFFSET}, {35,2+M_OFFSET}, {35,0+M_OFFSET}, {35,1+M_OFFSET}, {34,2+M_OFFSET}, {34,3+M_OFFSET}, {34,1+M_OFFSET}, {34,0+M_OFFSET},
				 {33,3+M_OFFSET}, {33,2+M_OFFSET}, {33,0+M_OFFSET}, {33,1+M_OFFSET}, {32,2+M_OFFSET}, {32,3+M_OFFSET}, {32,1+M_OFFSET}, {32,0+M_OFFSET}
	         },
	         /* LE 3. LUTD*/
	         {
				/* Icle_lm.ISL.LUTD */

				/* LSb to MSb, offset, minor */
				 {63,3+M_OFFSET}, {63,2+M_OFFSET}, {63,0+M_OFFSET}, {63,1+M_OFFSET}, {62,2+M_OFFSET}, {62,3+M_OFFSET}, {62,1+M_OFFSET}, {62,0+M_OFFSET},
				 {61,3+M_OFFSET}, {61,2+M_OFFSET}, {61,0+M_OFFSET}, {61,1+M_OFFSET}, {60,2+M_OFFSET}, {60,3+M_OFFSET}, {60,1+M_OFFSET}, {60,0+M_OFFSET},
				 {59,3+M_OFFSET}, {59,2+M_OFFSET}, {59,0+M_OFFSET}, {59,1+M_OFFSET}, {58,2+M_OFFSET}, {58,3+M_OFFSET}, {58,1+M_OFFSET}, {58,0+M_OFFSET},
				 {57,3+M_OFFSET}, {57,2+M_OFFSET}, {57,0+M_OFFSET}, {57,1+M_OFFSET}, {56,2+M_OFFSET}, {56,3+M_OFFSET}, {56,1+M_OFFSET}, {56,0+M_OFFSET},
				 {55,3+M_OFFSET}, {55,2+M_OFFSET}, {55,0+M_OFFSET}, {55,1+M_OFFSET}, {54,2+M_OFFSET}, {54,3+M_OFFSET}, {54,1+M_OFFSET}, {54,0+M_OFFSET},
				 {53,3+M_OFFSET}, {53,2+M_OFFSET}, {53,0+M_OFFSET}, {53,1+M_OFFSET}, {52,2+M_OFFSET}, {52,3+M_OFFSET}, {52,1+M_OFFSET}, {52,0+M_OFFSET},
				 {51,3+M_OFFSET}, {51,2+M_OFFSET}, {51,0+M_OFFSET}, {51,1+M_OFFSET}, {50,2+M_OFFSET}, {50,3+M_OFFSET}, {50,1+M_OFFSET}, {50,0+M_OFFSET},
				 {49,3+M_OFFSET}, {49,2+M_OFFSET}, {49,0+M_OFFSET}, {49,1+M_OFFSET}, {48,2+M_OFFSET}, {48,3+M_OFFSET}, {48,1+M_OFFSET}, {48,0+M_OFFSET},
	         }
	      },
	      /* Type 1. Slice L even */
	      {
	         /* LE 0. LUTA*/
	         {
				/* Icle_lm.ISL.LUTA */

				/* LSb to MSb, offset, minor */
				 {15,3+L_OFFSET}, {15,2+L_OFFSET}, {15,0+L_OFFSET}, {15,1+L_OFFSET}, {14,2+L_OFFSET}, {14,3+L_OFFSET}, {14,1+L_OFFSET}, {14,0+L_OFFSET},
				 {13,3+L_OFFSET}, {13,2+L_OFFSET}, {13,0+L_OFFSET}, {13,1+L_OFFSET}, {12,2+L_OFFSET}, {12,3+L_OFFSET}, {12,1+L_OFFSET}, {12,0+L_OFFSET},
				 {11,3+L_OFFSET}, {11,2+L_OFFSET}, {11,0+L_OFFSET}, {11,1+L_OFFSET}, {10,2+L_OFFSET}, {10,3+L_OFFSET}, {10,1+L_OFFSET}, {10,0+L_OFFSET},
				 {9,3+L_OFFSET}, {9,2+L_OFFSET}, {9,0+L_OFFSET}, {9,1+L_OFFSET}, {8,2+L_OFFSET}, {8,3+L_OFFSET}, {8,1+L_OFFSET}, {8,0+L_OFFSET},
				 {7,3+L_OFFSET}, {7,2+L_OFFSET}, {7,0+L_OFFSET}, {7,1+L_OFFSET}, {6,2+L_OFFSET}, {6,3+L_OFFSET}, {6,1+L_OFFSET}, {6,0+L_OFFSET},
				 {5,3+L_OFFSET}, {5,2+L_OFFSET}, {5,0+L_OFFSET}, {5,1+L_OFFSET}, {4,2+L_OFFSET}, {4,3+L_OFFSET}, {4,1+L_OFFSET}, {4,0+L_OFFSET},
				 {3,3+L_OFFSET}, {3,2+L_OFFSET}, {3,0+L_OFFSET}, {3,1+L_OFFSET}, {2,2+L_OFFSET}, {2,3+L_OFFSET}, {2,1+L_OFFSET}, {2,0+L_OFFSET},
				 {1,3+L_OFFSET}, {1,2+L_OFFSET}, {1,0+L_OFFSET}, {1,1+L_OFFSET}, {0,2+L_OFFSET}, {0,3+L_OFFSET}, {0,1+L_OFFSET}, {0,0+L_OFFSET}
			},
	         /* LE 1. LUTB*/
	         {
				/* Icle_lm.ISL.LUTB */

				/* LSb to MSb, offset, minor */
	        	{31,3+L_OFFSET}, {31,2+L_OFFSET}, {31,0+L_OFFSET}, {31,1+L_OFFSET}, {30,2+L_OFFSET}, {30,3+L_OFFSET}, {30,1+L_OFFSET}, {30,0+L_OFFSET},
				{29,3+L_OFFSET}, {29,2+L_OFFSET}, {29,0+L_OFFSET}, {29,1+L_OFFSET}, {28,2+L_OFFSET}, {28,3+L_OFFSET}, {28,1+L_OFFSET}, {28,0+L_OFFSET},
				{27,3+L_OFFSET}, {27,2+L_OFFSET}, {27,0+L_OFFSET}, {27,1+L_OFFSET}, {26,2+L_OFFSET}, {26,3+L_OFFSET}, {26,1+L_OFFSET}, {26,0+L_OFFSET},
				{25,3+L_OFFSET}, {25,2+L_OFFSET}, {25,0+L_OFFSET}, {25,1+L_OFFSET}, {24,2+L_OFFSET}, {24,3+L_OFFSET}, {24,1+L_OFFSET}, {24,0+L_OFFSET},
				{23,3+L_OFFSET}, {23,2+L_OFFSET}, {23,0+L_OFFSET}, {23,1+L_OFFSET}, {22,2+L_OFFSET}, {22,3+L_OFFSET}, {22,1+L_OFFSET}, {22,0+L_OFFSET},
				{21,3+L_OFFSET}, {21,2+L_OFFSET}, {21,0+L_OFFSET}, {21,1+L_OFFSET}, {20,2+L_OFFSET}, {20,3+L_OFFSET}, {20,1+L_OFFSET}, {20,0+L_OFFSET},
				{19,3+L_OFFSET}, {19,2+L_OFFSET}, {19,0+L_OFFSET}, {19,1+L_OFFSET}, {18,2+L_OFFSET}, {18,3+L_OFFSET}, {18,1+L_OFFSET}, {18,0+L_OFFSET},
				{17,3+L_OFFSET}, {17,2+L_OFFSET}, {17,0+L_OFFSET}, {17,1+L_OFFSET}, {16,2+L_OFFSET}, {16,3+L_OFFSET}, {16,1+L_OFFSET}, {16,0+L_OFFSET},
	         },
	         /* LE 2. LUTC*/
	         {
				/* Icle_lm.ISL.LUTC */

				/* LSb to MSb, offset, minor */
				 {47,3+L_OFFSET}, {47,2+L_OFFSET}, {47,0+L_OFFSET}, {47,1+L_OFFSET}, {46,2+L_OFFSET}, {46,3+L_OFFSET}, {46,1+L_OFFSET}, {46,0+L_OFFSET},
				 {45,3+L_OFFSET}, {45,2+L_OFFSET}, {45,0+L_OFFSET}, {45,1+L_OFFSET}, {44,2+L_OFFSET}, {44,3+L_OFFSET}, {44,1+L_OFFSET}, {44,0+L_OFFSET},
				 {43,3+L_OFFSET}, {43,2+L_OFFSET}, {43,0+L_OFFSET}, {43,1+L_OFFSET}, {42,2+L_OFFSET}, {42,3+L_OFFSET}, {42,1+L_OFFSET}, {42,0+L_OFFSET},
				 {41,3+L_OFFSET}, {41,2+L_OFFSET}, {41,0+L_OFFSET}, {41,1+L_OFFSET}, {40,2+L_OFFSET}, {40,3+L_OFFSET}, {40,1+L_OFFSET}, {40,0+L_OFFSET},
				 {39,3+L_OFFSET}, {39,2+L_OFFSET}, {39,0+L_OFFSET}, {39,1+L_OFFSET}, {38,2+L_OFFSET}, {38,3+L_OFFSET}, {38,1+L_OFFSET}, {38,0+L_OFFSET},
				 {37,3+L_OFFSET}, {37,2+L_OFFSET}, {37,0+L_OFFSET}, {37,1+L_OFFSET}, {36,2+L_OFFSET}, {36,3+L_OFFSET}, {36,1+L_OFFSET}, {36,0+L_OFFSET},
				 {35,3+L_OFFSET}, {35,2+L_OFFSET}, {35,0+L_OFFSET}, {35,1+L_OFFSET}, {34,2+L_OFFSET}, {34,3+L_OFFSET}, {34,1+L_OFFSET}, {34,0+L_OFFSET},
				 {33,3+L_OFFSET}, {33,2+L_OFFSET}, {33,0+L_OFFSET}, {33,1+L_OFFSET}, {32,2+L_OFFSET}, {32,3+L_OFFSET}, {32,1+L_OFFSET}, {32,0+L_OFFSET}
	         },
	         /* LE 3. LUTD*/
	         {
				/* Icle_lm.ISL.LUTD */

				/* LSb to MSb, offset, minor */
				 {63,3+L_OFFSET}, {63,2+L_OFFSET}, {63,0+L_OFFSET}, {63,1+L_OFFSET}, {62,2+L_OFFSET}, {62,3+L_OFFSET}, {62,1+L_OFFSET}, {62,0+L_OFFSET},
				 {61,3+L_OFFSET}, {61,2+L_OFFSET}, {61,0+L_OFFSET}, {61,1+L_OFFSET}, {60,2+L_OFFSET}, {60,3+L_OFFSET}, {60,1+L_OFFSET}, {60,0+L_OFFSET},
				 {59,3+L_OFFSET}, {59,2+L_OFFSET}, {59,0+L_OFFSET}, {59,1+L_OFFSET}, {58,2+L_OFFSET}, {58,3+L_OFFSET}, {58,1+L_OFFSET}, {58,0+L_OFFSET},
				 {57,3+L_OFFSET}, {57,2+L_OFFSET}, {57,0+L_OFFSET}, {57,1+L_OFFSET}, {56,2+L_OFFSET}, {56,3+L_OFFSET}, {56,1+L_OFFSET}, {56,0+L_OFFSET},
				 {55,3+L_OFFSET}, {55,2+L_OFFSET}, {55,0+L_OFFSET}, {55,1+L_OFFSET}, {54,2+L_OFFSET}, {54,3+L_OFFSET}, {54,1+L_OFFSET}, {54,0+L_OFFSET},
				 {53,3+L_OFFSET}, {53,2+L_OFFSET}, {53,0+L_OFFSET}, {53,1+L_OFFSET}, {52,2+L_OFFSET}, {52,3+L_OFFSET}, {52,1+L_OFFSET}, {52,0+L_OFFSET},
				 {51,3+L_OFFSET}, {51,2+L_OFFSET}, {51,0+L_OFFSET}, {51,1+L_OFFSET}, {50,2+L_OFFSET}, {50,3+L_OFFSET}, {50,1+L_OFFSET}, {50,0+L_OFFSET},
				 {49,3+L_OFFSET}, {49,2+L_OFFSET}, {49,0+L_OFFSET}, {49,1+L_OFFSET}, {48,2+L_OFFSET}, {48,3+L_OFFSET}, {48,1+L_OFFSET}, {48,0+L_OFFSET},
	         }
	      }
	   },

	};


#else

#error Unsupported FPGA Family

#endif

#ifdef __cplusplus
}
#endif

#endif

