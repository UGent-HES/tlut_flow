------------------------------DESCRIPTION AND LIBRARY DECLARATION-START---------------------------
-- Design Name:    HDL GENERATION - CONV LAYER 
-- Module Name:    FC - Behavioral 
-- Project Name:   CNN accelerator
-- Number of Total Operaiton: 12
-- Number of Clock Cycles: 32
-- Number of GOPS = 0.0
-------------------------------------------------Total Number of Operations for the Entire Model:4
-- Target Devices: Zynq-XC7Z020
-- Description: 
-- Dependencies: 
-- Revision:0.010 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;

entity FC_LAYER_6 is

GENERIC
 	( 
	constant PERCISION      : positive := 5; 	
	constant DOUT_WIDTH     : positive := 5; 	
	constant BIAS_SIZE      : positive := 5;
	constant MULT_SIZE      : positive := 10;
	constant BASE_DIN_WIDTH : positive := 41;
	constant DIN_WIDTH      : positive := 5;
	constant IMAGE_WIDTH    : positive := 1;
	constant IMAGE_SIZE     : positive := 169;	
	constant F_SIZE         : positive := 1;
	constant PF_X2_SIZE     : positive := 4;
	constant WEIGHT_SIZE    : positive := 5;
	constant BIASES_SIZE	: positive := 2;
	constant PADDING        : positive := 1;
	constant STRIDE         : positive := 1;
	constant FEATURE_MAPS   : positive := 3;
	constant VALID_CYCLES   : positive := 4;
	constant VALID_LOCAL_PIX: positive := 2;
	constant ADD_TREE_DEPTH : positive := 1;
	constant INPUT_DEPTH    : positive := 5;
	constant INNER_PXL_SUM  : positive := 1;
	constant SUM_PEXILS     : positive := 45;
	constant MULT_SUM_D_1   : positive := 10;
	constant MULT_SUM_SIZE_1: positive := 6;
	constant MULT_SUM_D_2   : positive := 5;
	constant MULT_SUM_SIZE_2: positive := 6;
	constant MULT_SUM_D_3   : positive := 3;
	constant MULT_SUM_SIZE_3: positive := 6;
	constant MULT_SUM_D_4   : positive := 2;
	constant MULT_SUM_SIZE_4: positive := 6;
	constant MULT_SUM_D_5   : positive := 1;
	constant MULT_SUM_SIZE_5: positive := 6;
	constant LOCAL_OUTPUT   : positive := 5	
		); 

port(
	DIN_1_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_2_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_3_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_4_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_5_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_6_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_7_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_8_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_9_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_10_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_11_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_12_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_13_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_14_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_15_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_16_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_17_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_18_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_19_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	DIN_20_6         :IN std_logic_vector(DIN_WIDTH-1 downto 0);
	CLK,RST         :IN std_logic;
   	EN_STREAM       :IN std_logic; 					-- S_AXIS_TREADY  : Ready to accept data in 
	EN_STREAM_OUT_6 :OUT std_logic; 			-- M_AXIS_TREADY  : Connected slave device is ready to accept data out/ Internal Enable
	VALID_OUT_6     :OUT std_logic;                         -- M_AXIS_TVALID  : Data out is valid
	EN_LOC_STREAM_6 :IN std_logic;
	DOUT_1_6        :OUT std_logic_vector(DOUT_WIDTH-1 downto 0);
	DOUT_2_6        :OUT std_logic_vector(DOUT_WIDTH-1 downto 0);
	INTERNAL_RST    :OUT std_logic
	);	

end FC_LAYER_6;

------------------------------ ARCHITECTURE DECLARATION - START---------------------------------------------

architecture Behavioral of FC_LAYER_6 is

------------------------------ INTERNAL FIXED CONSTANT & SIGNALS DECLARATION - START---------------------------------------------
type       FILTER_TYPE             is array (0 to PF_X2_SIZE-1) of signed(WEIGHT_SIZE- 1 downto 0);
signal     VALID_NXTLYR_PIX        :integer range 0 to VALID_CYCLES;
signal     PIXEL_COUNT             :integer range 0 to VALID_CYCLES;
signal     OUT_PIXEL_COUNT         :integer range 0 to VALID_CYCLES;
signal     EN_NXT_LYR_6            :std_logic;
signal     FRST_TIM_EN_6           :std_logic;
signal     Enable_MULT             :std_logic;
signal     Enable_ADDER            :std_logic;
signal     Enable_ReLU             :std_logic;
signal     Enable_BIAS             :std_logic;
signal     COUNT_PIX               :integer range 0 to PF_X2_SIZE;
signal     SIG_STRIDE              :integer range 0 to IMAGE_SIZE;
signal     PADDING_count           :integer range 0 to IMAGE_SIZE; -- TEMPORARY
signal     ROW_COUNT               :integer range 0 to IMAGE_SIZE; -- TEMPORARY


------------------------------ INTERNAL DYNAMIC SIGNALS DECLARATION ARRAY TYPE- START---------------------------------------------


type   MULT_X		is array (0 to FEATURE_MAPS-1) of signed(MULT_SIZE- 1 downto 0);
signal MULT_1:MULT_X;
signal MULT_2:MULT_X;
signal MULT_3:MULT_X;
signal MULT_4:MULT_X;
signal MULT_5:MULT_X;
signal MULT_6:MULT_X;
signal MULT_7:MULT_X;
signal MULT_8:MULT_X;
signal MULT_9:MULT_X;
signal MULT_10:MULT_X;
signal MULT_11:MULT_X;
signal MULT_12:MULT_X;
signal MULT_13:MULT_X;
signal MULT_14:MULT_X;
signal MULT_15:MULT_X;
signal MULT_16:MULT_X;
signal MULT_17:MULT_X;
signal MULT_18:MULT_X;
signal MULT_19:MULT_X;
signal MULT_20:MULT_X;
signal DOUT_BUF_1_6	: std_logic_vector(LOCAL_OUTPUT-1 downto 0);
signal BIAS_1		: signed(BIAS_SIZE-1   downto 0);
signal ReLU_1		: signed(BIAS_SIZE-1   downto 0);
signal DOUT_BUF_2_6	: std_logic_vector(LOCAL_OUTPUT-1 downto 0);
signal BIAS_2		: signed(BIAS_SIZE-1   downto 0);
signal ReLU_2		: signed(BIAS_SIZE-1   downto 0);
signal DOUT_BUF_3_6	: std_logic_vector(LOCAL_OUTPUT-1 downto 0);
signal BIAS_3		: signed(BIAS_SIZE-1   downto 0);
signal ReLU_3		: signed(BIAS_SIZE-1   downto 0);


------------------------------------------------------ MULT SUMMATION DECLARATION-----------------------------------------------------------
signal SUM_PIXELS_1: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_2: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_3: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_4: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_5: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_6: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_7: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_8: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_9: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_10: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_11: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_12: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_13: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_14: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_15: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_16: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_17: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_18: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_19: signed(SUM_PEXILS-1 downto 0);
signal SUM_PIXELS_20: signed(SUM_PEXILS-1 downto 0);
type    MULT_X_SUM_1	is array (0 to FEATURE_MAPS-1 ) of signed(MULT_SUM_SIZE_1- 1 downto 0);
signal  EN_SUM_MULT_1	: std_logic;
signal  MULTS_1_1:MULT_X_SUM_1;
signal  MULTS_1_2:MULT_X_SUM_1;
signal  MULTS_1_3:MULT_X_SUM_1;
signal  MULTS_1_4:MULT_X_SUM_1;
signal  MULTS_1_5:MULT_X_SUM_1;
signal  MULTS_1_6:MULT_X_SUM_1;
signal  MULTS_1_7:MULT_X_SUM_1;
signal  MULTS_1_8:MULT_X_SUM_1;
signal  MULTS_1_9:MULT_X_SUM_1;
signal  MULTS_1_10:MULT_X_SUM_1;
signal  MULTS_1_11:MULT_X_SUM_1;
signal  MULTS_1_12:MULT_X_SUM_1;
signal  MULTS_1_13:MULT_X_SUM_1;
signal  MULTS_1_14:MULT_X_SUM_1;
signal  MULTS_1_15:MULT_X_SUM_1;
signal  MULTS_1_16:MULT_X_SUM_1;
signal  MULTS_1_17:MULT_X_SUM_1;
signal  MULTS_1_18:MULT_X_SUM_1;
signal  MULTS_1_19:MULT_X_SUM_1;
signal  MULTS_1_20:MULT_X_SUM_1;
type    MULT_X_SUM_2	is array (0 to FEATURE_MAPS-1 ) of signed(MULT_SUM_SIZE_2- 1 downto 0);
signal  EN_SUM_MULT_2	: std_logic;
signal  MULTS_2_1:MULT_X_SUM_2;
signal  MULTS_2_2:MULT_X_SUM_2;
signal  MULTS_2_3:MULT_X_SUM_2;
signal  MULTS_2_4:MULT_X_SUM_2;
signal  MULTS_2_5:MULT_X_SUM_2;
signal  MULTS_2_6:MULT_X_SUM_2;
signal  MULTS_2_7:MULT_X_SUM_2;
signal  MULTS_2_8:MULT_X_SUM_2;
signal  MULTS_2_9:MULT_X_SUM_2;
signal  MULTS_2_10:MULT_X_SUM_2;
signal  MULTS_2_11:MULT_X_SUM_2;
signal  MULTS_2_12:MULT_X_SUM_2;
signal  MULTS_2_13:MULT_X_SUM_2;
signal  MULTS_2_14:MULT_X_SUM_2;
signal  MULTS_2_15:MULT_X_SUM_2;
signal  MULTS_2_16:MULT_X_SUM_2;
signal  MULTS_2_17:MULT_X_SUM_2;
signal  MULTS_2_18:MULT_X_SUM_2;
signal  MULTS_2_19:MULT_X_SUM_2;
signal  MULTS_2_20:MULT_X_SUM_2;
type    MULT_X_SUM_3	is array (0 to FEATURE_MAPS-1 ) of signed(MULT_SUM_SIZE_3- 1 downto 0);
signal  EN_SUM_MULT_3	: std_logic;
signal  MULTS_3_1:MULT_X_SUM_3;
signal  MULTS_3_2:MULT_X_SUM_3;
signal  MULTS_3_3:MULT_X_SUM_3;
signal  MULTS_3_4:MULT_X_SUM_3;
signal  MULTS_3_5:MULT_X_SUM_3;
signal  MULTS_3_6:MULT_X_SUM_3;
signal  MULTS_3_7:MULT_X_SUM_3;
signal  MULTS_3_8:MULT_X_SUM_3;
signal  MULTS_3_9:MULT_X_SUM_3;
signal  MULTS_3_10:MULT_X_SUM_3;
signal  MULTS_3_11:MULT_X_SUM_3;
signal  MULTS_3_12:MULT_X_SUM_3;
signal  MULTS_3_13:MULT_X_SUM_3;
signal  MULTS_3_14:MULT_X_SUM_3;
signal  MULTS_3_15:MULT_X_SUM_3;
signal  MULTS_3_16:MULT_X_SUM_3;
signal  MULTS_3_17:MULT_X_SUM_3;
signal  MULTS_3_18:MULT_X_SUM_3;
signal  MULTS_3_19:MULT_X_SUM_3;
signal  MULTS_3_20:MULT_X_SUM_3;
type    MULT_X_SUM_4	is array (0 to FEATURE_MAPS-1 ) of signed(MULT_SUM_SIZE_4- 1 downto 0);
signal  EN_SUM_MULT_4	: std_logic;
signal  MULTS_4_1:MULT_X_SUM_4;
signal  MULTS_4_2:MULT_X_SUM_4;
signal  MULTS_4_3:MULT_X_SUM_4;
signal  MULTS_4_4:MULT_X_SUM_4;
signal  MULTS_4_5:MULT_X_SUM_4;
signal  MULTS_4_6:MULT_X_SUM_4;
signal  MULTS_4_7:MULT_X_SUM_4;
signal  MULTS_4_8:MULT_X_SUM_4;
signal  MULTS_4_9:MULT_X_SUM_4;
signal  MULTS_4_10:MULT_X_SUM_4;
signal  MULTS_4_11:MULT_X_SUM_4;
signal  MULTS_4_12:MULT_X_SUM_4;
signal  MULTS_4_13:MULT_X_SUM_4;
signal  MULTS_4_14:MULT_X_SUM_4;
signal  MULTS_4_15:MULT_X_SUM_4;
signal  MULTS_4_16:MULT_X_SUM_4;
signal  MULTS_4_17:MULT_X_SUM_4;
signal  MULTS_4_18:MULT_X_SUM_4;
signal  MULTS_4_19:MULT_X_SUM_4;
signal  MULTS_4_20:MULT_X_SUM_4;
type    MULT_X_SUM_5	is array (0 to FEATURE_MAPS-1 ) of signed(MULT_SUM_SIZE_5- 1 downto 0);
signal  EN_SUM_MULT_5	: std_logic;
signal  MULTS_5_1:MULT_X_SUM_5;
signal  MULTS_5_2:MULT_X_SUM_5;
signal  MULTS_5_3:MULT_X_SUM_5;
signal  MULTS_5_4:MULT_X_SUM_5;
signal  MULTS_5_5:MULT_X_SUM_5;
signal  MULTS_5_6:MULT_X_SUM_5;
signal  MULTS_5_7:MULT_X_SUM_5;
signal  MULTS_5_8:MULT_X_SUM_5;
signal  MULTS_5_9:MULT_X_SUM_5;
signal  MULTS_5_10:MULT_X_SUM_5;
signal  MULTS_5_11:MULT_X_SUM_5;
signal  MULTS_5_12:MULT_X_SUM_5;
signal  MULTS_5_13:MULT_X_SUM_5;
signal  MULTS_5_14:MULT_X_SUM_5;
signal  MULTS_5_15:MULT_X_SUM_5;
signal  MULTS_5_16:MULT_X_SUM_5;
signal  MULTS_5_17:MULT_X_SUM_5;
signal  MULTS_5_18:MULT_X_SUM_5;
signal  MULTS_5_19:MULT_X_SUM_5;
signal  MULTS_5_20:MULT_X_SUM_5;



--------------------------------------------- FILTER HARDCODED CONSTANTS -WEIGHTS START--------------------------------

constant FMAP_1_1: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_2: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_3: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_4: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_5: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_6: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_7: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_8: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_9: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_10: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_11: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_12: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_13: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_14: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_15: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_16: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_17: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_18: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_19: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_1_20: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_1: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_2: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_3: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_4: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_5: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_6: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_7: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_8: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_9: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_10: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_11: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_12: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_13: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_14: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_15: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_16: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_17: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_18: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_19: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_2_20: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_1: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_2: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_3: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_4: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_5: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_6: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_7: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_8: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_9: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_10: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_11: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_12: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_13: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_14: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_15: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_16: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_17: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_18: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_19: signed(WEIGHT_SIZE- 1 downto 0):= "00001";
constant FMAP_3_20: signed(WEIGHT_SIZE- 1 downto 0):= "00001";

constant BIAS_VAL_1: signed (BIASES_SIZE-1 downto 0):="01";
constant BIAS_VAL_2: signed (BIASES_SIZE-1 downto 0):="01";
constant BIAS_VAL_3: signed (BIASES_SIZE-1 downto 0):="01";


BEGIN
-------------------------------------------------------- ARCHITECTURE BEGIN--------------------------------------------------------

LAYER_6: process(CLK)


begin
	EN_STREAM_OUT_6 <= '0';
	VALID_OUT_6 <= '0';
------------------------------------------------ RESET AND PROCESS TOP START ------------------------------------------------------
if rising_edge(CLK) then
  if RST = '1' then
	-------------------FIXED SIGNALS RESET------------------------
    PIXEL_COUNT<=0;VALID_NXTLYR_PIX<=0;OUT_PIXEL_COUNT<=0;
    EN_NXT_LYR_6<='0';FRST_TIM_EN_6<='0';INTERNAL_RST<='0';
    Enable_MULT<='0';Enable_ADDER<='0';Enable_ReLU<='0';Enable_BIAS<='0';
    PADDING_count<=0;ROW_COUNT<=0;SIG_STRIDE<=STRIDE;COUNT_PIX<=0;

-------------------DYNAMIC SIGNALS RESET------------------------
    DOUT_BUF_1_6<=(    others => '0');BIAS_1<=(    others => '0');ReLU_1<=(    others => '0');
    DOUT_BUF_2_6<=(    others => '0');BIAS_2<=(    others => '0');ReLU_2<=(    others => '0');
    DOUT_BUF_3_6<=(    others => '0');BIAS_3<=(    others => '0');ReLU_3<=(    others => '0');

    SUM_PIXELS_1<=(    others=>'0');MULT_1<=(    others=> (    others=>'0'));
    SUM_PIXELS_2<=(    others=>'0');MULT_2<=(    others=> (    others=>'0'));
    SUM_PIXELS_3<=(    others=>'0');MULT_3<=(    others=> (    others=>'0'));
    SUM_PIXELS_4<=(    others=>'0');MULT_4<=(    others=> (    others=>'0'));
    SUM_PIXELS_5<=(    others=>'0');MULT_5<=(    others=> (    others=>'0'));
    SUM_PIXELS_6<=(    others=>'0');MULT_6<=(    others=> (    others=>'0'));
    SUM_PIXELS_7<=(    others=>'0');MULT_7<=(    others=> (    others=>'0'));
    SUM_PIXELS_8<=(    others=>'0');MULT_8<=(    others=> (    others=>'0'));
    SUM_PIXELS_9<=(    others=>'0');MULT_9<=(    others=> (    others=>'0'));
    SUM_PIXELS_10<=(    others=>'0');MULT_10<=(    others=> (    others=>'0'));
    SUM_PIXELS_11<=(    others=>'0');MULT_11<=(    others=> (    others=>'0'));
    SUM_PIXELS_12<=(    others=>'0');MULT_12<=(    others=> (    others=>'0'));
    SUM_PIXELS_13<=(    others=>'0');MULT_13<=(    others=> (    others=>'0'));
    SUM_PIXELS_14<=(    others=>'0');MULT_14<=(    others=> (    others=>'0'));
    SUM_PIXELS_15<=(    others=>'0');MULT_15<=(    others=> (    others=>'0'));
    SUM_PIXELS_16<=(    others=>'0');MULT_16<=(    others=> (    others=>'0'));
    SUM_PIXELS_17<=(    others=>'0');MULT_17<=(    others=> (    others=>'0'));
    SUM_PIXELS_18<=(    others=>'0');MULT_18<=(    others=> (    others=>'0'));
    SUM_PIXELS_19<=(    others=>'0');MULT_19<=(    others=> (    others=>'0'));
    SUM_PIXELS_20<=(    others=>'0');MULT_20<=(    others=> (    others=>'0'));

    EN_SUM_MULT_1<='0';
    MULTS_1_1<=(    others=> (    others=>'0'));
    MULTS_1_2<=(    others=> (    others=>'0'));
    MULTS_1_3<=(    others=> (    others=>'0'));
    MULTS_1_4<=(    others=> (    others=>'0'));
    MULTS_1_5<=(    others=> (    others=>'0'));
    MULTS_1_6<=(    others=> (    others=>'0'));
    MULTS_1_7<=(    others=> (    others=>'0'));
    MULTS_1_8<=(    others=> (    others=>'0'));
    MULTS_1_9<=(    others=> (    others=>'0'));
    MULTS_1_10<=(    others=> (    others=>'0'));
    MULTS_1_11<=(    others=> (    others=>'0'));
    MULTS_1_12<=(    others=> (    others=>'0'));
    MULTS_1_13<=(    others=> (    others=>'0'));
    MULTS_1_14<=(    others=> (    others=>'0'));
    MULTS_1_15<=(    others=> (    others=>'0'));
    MULTS_1_16<=(    others=> (    others=>'0'));
    MULTS_1_17<=(    others=> (    others=>'0'));
    MULTS_1_18<=(    others=> (    others=>'0'));
    MULTS_1_19<=(    others=> (    others=>'0'));
    MULTS_1_20<=(    others=> (    others=>'0'));
    EN_SUM_MULT_2<='0';
    MULTS_2_1<=(    others=> (    others=>'0'));
    MULTS_2_2<=(    others=> (    others=>'0'));
    MULTS_2_3<=(    others=> (    others=>'0'));
    MULTS_2_4<=(    others=> (    others=>'0'));
    MULTS_2_5<=(    others=> (    others=>'0'));
    MULTS_2_6<=(    others=> (    others=>'0'));
    MULTS_2_7<=(    others=> (    others=>'0'));
    MULTS_2_8<=(    others=> (    others=>'0'));
    MULTS_2_9<=(    others=> (    others=>'0'));
    MULTS_2_10<=(    others=> (    others=>'0'));
    MULTS_2_11<=(    others=> (    others=>'0'));
    MULTS_2_12<=(    others=> (    others=>'0'));
    MULTS_2_13<=(    others=> (    others=>'0'));
    MULTS_2_14<=(    others=> (    others=>'0'));
    MULTS_2_15<=(    others=> (    others=>'0'));
    MULTS_2_16<=(    others=> (    others=>'0'));
    MULTS_2_17<=(    others=> (    others=>'0'));
    MULTS_2_18<=(    others=> (    others=>'0'));
    MULTS_2_19<=(    others=> (    others=>'0'));
    MULTS_2_20<=(    others=> (    others=>'0'));
    EN_SUM_MULT_3<='0';
    MULTS_3_1<=(    others=> (    others=>'0'));
    MULTS_3_2<=(    others=> (    others=>'0'));
    MULTS_3_3<=(    others=> (    others=>'0'));
    MULTS_3_4<=(    others=> (    others=>'0'));
    MULTS_3_5<=(    others=> (    others=>'0'));
    MULTS_3_6<=(    others=> (    others=>'0'));
    MULTS_3_7<=(    others=> (    others=>'0'));
    MULTS_3_8<=(    others=> (    others=>'0'));
    MULTS_3_9<=(    others=> (    others=>'0'));
    MULTS_3_10<=(    others=> (    others=>'0'));
    MULTS_3_11<=(    others=> (    others=>'0'));
    MULTS_3_12<=(    others=> (    others=>'0'));
    MULTS_3_13<=(    others=> (    others=>'0'));
    MULTS_3_14<=(    others=> (    others=>'0'));
    MULTS_3_15<=(    others=> (    others=>'0'));
    MULTS_3_16<=(    others=> (    others=>'0'));
    MULTS_3_17<=(    others=> (    others=>'0'));
    MULTS_3_18<=(    others=> (    others=>'0'));
    MULTS_3_19<=(    others=> (    others=>'0'));
    MULTS_3_20<=(    others=> (    others=>'0'));
    EN_SUM_MULT_4<='0';
    MULTS_4_1<=(    others=> (    others=>'0'));
    MULTS_4_2<=(    others=> (    others=>'0'));
    MULTS_4_3<=(    others=> (    others=>'0'));
    MULTS_4_4<=(    others=> (    others=>'0'));
    MULTS_4_5<=(    others=> (    others=>'0'));
    MULTS_4_6<=(    others=> (    others=>'0'));
    MULTS_4_7<=(    others=> (    others=>'0'));
    MULTS_4_8<=(    others=> (    others=>'0'));
    MULTS_4_9<=(    others=> (    others=>'0'));
    MULTS_4_10<=(    others=> (    others=>'0'));
    MULTS_4_11<=(    others=> (    others=>'0'));
    MULTS_4_12<=(    others=> (    others=>'0'));
    MULTS_4_13<=(    others=> (    others=>'0'));
    MULTS_4_14<=(    others=> (    others=>'0'));
    MULTS_4_15<=(    others=> (    others=>'0'));
    MULTS_4_16<=(    others=> (    others=>'0'));
    MULTS_4_17<=(    others=> (    others=>'0'));
    MULTS_4_18<=(    others=> (    others=>'0'));
    MULTS_4_19<=(    others=> (    others=>'0'));
    MULTS_4_20<=(    others=> (    others=>'0'));
    EN_SUM_MULT_5<='0';
    MULTS_5_1<=(    others=> (    others=>'0'));
    MULTS_5_2<=(    others=> (    others=>'0'));
    MULTS_5_3<=(    others=> (    others=>'0'));
    MULTS_5_4<=(    others=> (    others=>'0'));
    MULTS_5_5<=(    others=> (    others=>'0'));
    MULTS_5_6<=(    others=> (    others=>'0'));
    MULTS_5_7<=(    others=> (    others=>'0'));
    MULTS_5_8<=(    others=> (    others=>'0'));
    MULTS_5_9<=(    others=> (    others=>'0'));
    MULTS_5_10<=(    others=> (    others=>'0'));
    MULTS_5_11<=(    others=> (    others=>'0'));
    MULTS_5_12<=(    others=> (    others=>'0'));
    MULTS_5_13<=(    others=> (    others=>'0'));
    MULTS_5_14<=(    others=> (    others=>'0'));
    MULTS_5_15<=(    others=> (    others=>'0'));
    MULTS_5_16<=(    others=> (    others=>'0'));
    MULTS_5_17<=(    others=> (    others=>'0'));
    MULTS_5_18<=(    others=> (    others=>'0'));
    MULTS_5_19<=(    others=> (    others=>'0'));
    MULTS_5_20<=(    others=> (    others=>'0'));

------------------------------------------------ PROCESS START------------------------------------------------------
	  
   else 	
	if EN_LOC_STREAM_6='1' and EN_STREAM= '1' and OUT_PIXEL_COUNT<VALID_CYCLES  then    -- check valid data and enable stream
		
		if  FRST_TIM_EN_6='1' then EN_NXT_LYR_6<='1';end if;

			MULT_1(0)<=signed(DIN_1_6)*signed(FMAP_1_1);
			MULT_2(0)<=signed(DIN_2_6)*signed(FMAP_1_2);
			MULT_3(0)<=signed(DIN_3_6)*signed(FMAP_1_3);
			MULT_4(0)<=signed(DIN_4_6)*signed(FMAP_1_4);
			MULT_5(0)<=signed(DIN_5_6)*signed(FMAP_1_5);
			MULT_6(0)<=signed(DIN_6_6)*signed(FMAP_1_6);
			MULT_7(0)<=signed(DIN_7_6)*signed(FMAP_1_7);
			MULT_8(0)<=signed(DIN_8_6)*signed(FMAP_1_8);
			MULT_9(0)<=signed(DIN_9_6)*signed(FMAP_1_9);
			MULT_10(0)<=signed(DIN_10_6)*signed(FMAP_1_10);
			MULT_11(0)<=signed(DIN_11_6)*signed(FMAP_1_11);
			MULT_12(0)<=signed(DIN_12_6)*signed(FMAP_1_12);
			MULT_13(0)<=signed(DIN_13_6)*signed(FMAP_1_13);
			MULT_14(0)<=signed(DIN_14_6)*signed(FMAP_1_14);
			MULT_15(0)<=signed(DIN_15_6)*signed(FMAP_1_15);
			MULT_16(0)<=signed(DIN_16_6)*signed(FMAP_1_16);
			MULT_17(0)<=signed(DIN_17_6)*signed(FMAP_1_17);
			MULT_18(0)<=signed(DIN_18_6)*signed(FMAP_1_18);
			MULT_19(0)<=signed(DIN_19_6)*signed(FMAP_1_19);
			MULT_20(0)<=signed(DIN_20_6)*signed(FMAP_1_20);

			MULT_1(1)<=signed(DIN_1_6)*signed(FMAP_2_1);
			MULT_2(1)<=signed(DIN_2_6)*signed(FMAP_2_2);
			MULT_3(1)<=signed(DIN_3_6)*signed(FMAP_2_3);
			MULT_4(1)<=signed(DIN_4_6)*signed(FMAP_2_4);
			MULT_5(1)<=signed(DIN_5_6)*signed(FMAP_2_5);
			MULT_6(1)<=signed(DIN_6_6)*signed(FMAP_2_6);
			MULT_7(1)<=signed(DIN_7_6)*signed(FMAP_2_7);
			MULT_8(1)<=signed(DIN_8_6)*signed(FMAP_2_8);
			MULT_9(1)<=signed(DIN_9_6)*signed(FMAP_2_9);
			MULT_10(1)<=signed(DIN_10_6)*signed(FMAP_2_10);
			MULT_11(1)<=signed(DIN_11_6)*signed(FMAP_2_11);
			MULT_12(1)<=signed(DIN_12_6)*signed(FMAP_2_12);
			MULT_13(1)<=signed(DIN_13_6)*signed(FMAP_2_13);
			MULT_14(1)<=signed(DIN_14_6)*signed(FMAP_2_14);
			MULT_15(1)<=signed(DIN_15_6)*signed(FMAP_2_15);
			MULT_16(1)<=signed(DIN_16_6)*signed(FMAP_2_16);
			MULT_17(1)<=signed(DIN_17_6)*signed(FMAP_2_17);
			MULT_18(1)<=signed(DIN_18_6)*signed(FMAP_2_18);
			MULT_19(1)<=signed(DIN_19_6)*signed(FMAP_2_19);
			MULT_20(1)<=signed(DIN_20_6)*signed(FMAP_2_20);

			MULT_1(2)<=signed(DIN_1_6)*signed(FMAP_3_1);
			MULT_2(2)<=signed(DIN_2_6)*signed(FMAP_3_2);
			MULT_3(2)<=signed(DIN_3_6)*signed(FMAP_3_3);
			MULT_4(2)<=signed(DIN_4_6)*signed(FMAP_3_4);
			MULT_5(2)<=signed(DIN_5_6)*signed(FMAP_3_5);
			MULT_6(2)<=signed(DIN_6_6)*signed(FMAP_3_6);
			MULT_7(2)<=signed(DIN_7_6)*signed(FMAP_3_7);
			MULT_8(2)<=signed(DIN_8_6)*signed(FMAP_3_8);
			MULT_9(2)<=signed(DIN_9_6)*signed(FMAP_3_9);
			MULT_10(2)<=signed(DIN_10_6)*signed(FMAP_3_10);
			MULT_11(2)<=signed(DIN_11_6)*signed(FMAP_3_11);
			MULT_12(2)<=signed(DIN_12_6)*signed(FMAP_3_12);
			MULT_13(2)<=signed(DIN_13_6)*signed(FMAP_3_13);
			MULT_14(2)<=signed(DIN_14_6)*signed(FMAP_3_14);
			MULT_15(2)<=signed(DIN_15_6)*signed(FMAP_3_15);
			MULT_16(2)<=signed(DIN_16_6)*signed(FMAP_3_16);
			MULT_17(2)<=signed(DIN_17_6)*signed(FMAP_3_17);
			MULT_18(2)<=signed(DIN_18_6)*signed(FMAP_3_18);
			MULT_19(2)<=signed(DIN_19_6)*signed(FMAP_3_19);
			MULT_20(2)<=signed(DIN_20_6)*signed(FMAP_3_20);


                        EN_SUM_MULT_1<='1';

      -------------------------------------------- Enable MULT START --------------------------------------------				


		if EN_SUM_MULT_1 = '1' then
			------------------------------------STAGE-1--------------------------------------
			MULTS_1_1(0)<=signed(MULT_1(0)(MULT_SIZE-1) & MULT_1(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_2(0)(MULT_SIZE-1) & MULT_2(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_1(1)<=signed(MULT_1(1)(MULT_SIZE-1) & MULT_1(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_2(1)(MULT_SIZE-1) & MULT_2(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_1(2)<=signed(MULT_1(2)(MULT_SIZE-1) & MULT_1(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_2(2)(MULT_SIZE-1) & MULT_2(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_2(0)<=signed(MULT_3(0)(MULT_SIZE-1) & MULT_3(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_4(0)(MULT_SIZE-1) & MULT_4(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_2(1)<=signed(MULT_3(1)(MULT_SIZE-1) & MULT_3(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_4(1)(MULT_SIZE-1) & MULT_4(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_2(2)<=signed(MULT_3(2)(MULT_SIZE-1) & MULT_3(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_4(2)(MULT_SIZE-1) & MULT_4(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_3(0)<=signed(MULT_5(0)(MULT_SIZE-1) & MULT_5(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_6(0)(MULT_SIZE-1) & MULT_6(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_3(1)<=signed(MULT_5(1)(MULT_SIZE-1) & MULT_5(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_6(1)(MULT_SIZE-1) & MULT_6(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_3(2)<=signed(MULT_5(2)(MULT_SIZE-1) & MULT_5(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_6(2)(MULT_SIZE-1) & MULT_6(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_4(0)<=signed(MULT_7(0)(MULT_SIZE-1) & MULT_7(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_8(0)(MULT_SIZE-1) & MULT_8(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_4(1)<=signed(MULT_7(1)(MULT_SIZE-1) & MULT_7(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_8(1)(MULT_SIZE-1) & MULT_8(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_4(2)<=signed(MULT_7(2)(MULT_SIZE-1) & MULT_7(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_8(2)(MULT_SIZE-1) & MULT_8(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_5(0)<=signed(MULT_9(0)(MULT_SIZE-1) & MULT_9(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_10(0)(MULT_SIZE-1) & MULT_10(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_5(1)<=signed(MULT_9(1)(MULT_SIZE-1) & MULT_9(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_10(1)(MULT_SIZE-1) & MULT_10(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_5(2)<=signed(MULT_9(2)(MULT_SIZE-1) & MULT_9(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_10(2)(MULT_SIZE-1) & MULT_10(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_6(0)<=signed(MULT_11(0)(MULT_SIZE-1) & MULT_11(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_12(0)(MULT_SIZE-1) & MULT_12(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_6(1)<=signed(MULT_11(1)(MULT_SIZE-1) & MULT_11(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_12(1)(MULT_SIZE-1) & MULT_12(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_6(2)<=signed(MULT_11(2)(MULT_SIZE-1) & MULT_11(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_12(2)(MULT_SIZE-1) & MULT_12(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_7(0)<=signed(MULT_13(0)(MULT_SIZE-1) & MULT_13(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_14(0)(MULT_SIZE-1) & MULT_14(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_7(1)<=signed(MULT_13(1)(MULT_SIZE-1) & MULT_13(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_14(1)(MULT_SIZE-1) & MULT_14(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_7(2)<=signed(MULT_13(2)(MULT_SIZE-1) & MULT_13(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_14(2)(MULT_SIZE-1) & MULT_14(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_8(0)<=signed(MULT_15(0)(MULT_SIZE-1) & MULT_15(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_16(0)(MULT_SIZE-1) & MULT_16(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_8(1)<=signed(MULT_15(1)(MULT_SIZE-1) & MULT_15(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_16(1)(MULT_SIZE-1) & MULT_16(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_8(2)<=signed(MULT_15(2)(MULT_SIZE-1) & MULT_15(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_16(2)(MULT_SIZE-1) & MULT_16(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_9(0)<=signed(MULT_17(0)(MULT_SIZE-1) & MULT_17(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_18(0)(MULT_SIZE-1) & MULT_18(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_9(1)<=signed(MULT_17(1)(MULT_SIZE-1) & MULT_17(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_18(1)(MULT_SIZE-1) & MULT_18(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_9(2)<=signed(MULT_17(2)(MULT_SIZE-1) & MULT_17(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_18(2)(MULT_SIZE-1) & MULT_18(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));

			MULTS_1_10(0)<=signed(MULT_19(0)(MULT_SIZE-1) & MULT_19(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_20(0)(MULT_SIZE-1) & MULT_20(0)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_10(1)<=signed(MULT_19(1)(MULT_SIZE-1) & MULT_19(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_20(1)(MULT_SIZE-1) & MULT_20(1)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));
			MULTS_1_10(2)<=signed(MULT_19(2)(MULT_SIZE-1) & MULT_19(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2))+signed(MULT_20(2)(MULT_SIZE-1) & MULT_20(2)(MULT_SIZE-3 downto MULT_SIZE-PERCISION-2));



                     EN_SUM_MULT_2<='1';
		end if;


		------------------------- Enable NEXT STATGE MULTS START -----------------------

		if EN_SUM_MULT_2 = '1' then
			------------------------------------STAGE-2--------------------------------------
			MULTS_2_1(0)<=signed(MULTS_1_1(0)(PERCISION) & MULTS_1_1(0)(PERCISION downto 1))+signed(MULTS_1_2(0)(PERCISION) & MULTS_1_2(0)(PERCISION downto 1));
			MULTS_2_1(1)<=signed(MULTS_1_1(1)(PERCISION) & MULTS_1_1(1)(PERCISION downto 1))+signed(MULTS_1_2(1)(PERCISION) & MULTS_1_2(1)(PERCISION downto 1));
			MULTS_2_1(2)<=signed(MULTS_1_1(2)(PERCISION) & MULTS_1_1(2)(PERCISION downto 1))+signed(MULTS_1_2(2)(PERCISION) & MULTS_1_2(2)(PERCISION downto 1));

			MULTS_2_2(0)<=signed(MULTS_1_3(0)(PERCISION) & MULTS_1_3(0)(PERCISION downto 1))+signed(MULTS_1_4(0)(PERCISION) & MULTS_1_4(0)(PERCISION downto 1));
			MULTS_2_2(1)<=signed(MULTS_1_3(1)(PERCISION) & MULTS_1_3(1)(PERCISION downto 1))+signed(MULTS_1_4(1)(PERCISION) & MULTS_1_4(1)(PERCISION downto 1));
			MULTS_2_2(2)<=signed(MULTS_1_3(2)(PERCISION) & MULTS_1_3(2)(PERCISION downto 1))+signed(MULTS_1_4(2)(PERCISION) & MULTS_1_4(2)(PERCISION downto 1));

			MULTS_2_3(0)<=signed(MULTS_1_5(0)(PERCISION) & MULTS_1_5(0)(PERCISION downto 1))+signed(MULTS_1_6(0)(PERCISION) & MULTS_1_6(0)(PERCISION downto 1));
			MULTS_2_3(1)<=signed(MULTS_1_5(1)(PERCISION) & MULTS_1_5(1)(PERCISION downto 1))+signed(MULTS_1_6(1)(PERCISION) & MULTS_1_6(1)(PERCISION downto 1));
			MULTS_2_3(2)<=signed(MULTS_1_5(2)(PERCISION) & MULTS_1_5(2)(PERCISION downto 1))+signed(MULTS_1_6(2)(PERCISION) & MULTS_1_6(2)(PERCISION downto 1));

			MULTS_2_4(0)<=signed(MULTS_1_7(0)(PERCISION) & MULTS_1_7(0)(PERCISION downto 1))+signed(MULTS_1_8(0)(PERCISION) & MULTS_1_8(0)(PERCISION downto 1));
			MULTS_2_4(1)<=signed(MULTS_1_7(1)(PERCISION) & MULTS_1_7(1)(PERCISION downto 1))+signed(MULTS_1_8(1)(PERCISION) & MULTS_1_8(1)(PERCISION downto 1));
			MULTS_2_4(2)<=signed(MULTS_1_7(2)(PERCISION) & MULTS_1_7(2)(PERCISION downto 1))+signed(MULTS_1_8(2)(PERCISION) & MULTS_1_8(2)(PERCISION downto 1));

			MULTS_2_5(0)<=signed(MULTS_1_9(0)(PERCISION) & MULTS_1_9(0)(PERCISION downto 1))+signed(MULTS_1_10(0)(PERCISION) & MULTS_1_10(0)(PERCISION downto 1));
			MULTS_2_5(1)<=signed(MULTS_1_9(1)(PERCISION) & MULTS_1_9(1)(PERCISION downto 1))+signed(MULTS_1_10(1)(PERCISION) & MULTS_1_10(1)(PERCISION downto 1));
			MULTS_2_5(2)<=signed(MULTS_1_9(2)(PERCISION) & MULTS_1_9(2)(PERCISION downto 1))+signed(MULTS_1_10(2)(PERCISION) & MULTS_1_10(2)(PERCISION downto 1));



                         EN_SUM_MULT_3<='1';
		end if;


		------------------------- Enable NEXT STATGE MULTS START -----------------------

		if EN_SUM_MULT_3 = '1' then
			------------------------------------STAGE-3--------------------------------------
			MULTS_3_1(0)<=signed(MULTS_2_1(0));
			MULTS_3_1(1)<=signed(MULTS_2_1(1));
			MULTS_3_1(2)<=signed(MULTS_2_1(2));

			MULTS_3_2(0)<=signed(MULTS_2_2(0)(PERCISION) & MULTS_2_2(0)(PERCISION downto 1))+signed(MULTS_2_3(0)(PERCISION) & MULTS_2_3(0)(PERCISION downto 1));
			MULTS_3_2(1)<=signed(MULTS_2_2(1)(PERCISION) & MULTS_2_2(1)(PERCISION downto 1))+signed(MULTS_2_3(1)(PERCISION) & MULTS_2_3(1)(PERCISION downto 1));
			MULTS_3_2(2)<=signed(MULTS_2_2(2)(PERCISION) & MULTS_2_2(2)(PERCISION downto 1))+signed(MULTS_2_3(2)(PERCISION) & MULTS_2_3(2)(PERCISION downto 1));

			MULTS_3_3(0)<=signed(MULTS_2_4(0)(PERCISION) & MULTS_2_4(0)(PERCISION downto 1))+signed(MULTS_2_5(0)(PERCISION) & MULTS_2_5(0)(PERCISION downto 1));
			MULTS_3_3(1)<=signed(MULTS_2_4(1)(PERCISION) & MULTS_2_4(1)(PERCISION downto 1))+signed(MULTS_2_5(1)(PERCISION) & MULTS_2_5(1)(PERCISION downto 1));
			MULTS_3_3(2)<=signed(MULTS_2_4(2)(PERCISION) & MULTS_2_4(2)(PERCISION downto 1))+signed(MULTS_2_5(2)(PERCISION) & MULTS_2_5(2)(PERCISION downto 1));



                         EN_SUM_MULT_4<='1';
		end if;


		------------------------- Enable NEXT STATGE MULTS START -----------------------

		if EN_SUM_MULT_4 = '1' then
			------------------------------------STAGE-4--------------------------------------
			MULTS_4_1(0)<=signed(MULTS_3_1(0));
			MULTS_4_1(1)<=signed(MULTS_3_1(1));
			MULTS_4_1(2)<=signed(MULTS_3_1(2));

			MULTS_4_2(0)<=signed(MULTS_3_2(0)(PERCISION) & MULTS_3_2(0)(PERCISION downto 1))+signed(MULTS_3_3(0)(PERCISION) & MULTS_3_3(0)(PERCISION downto 1));
			MULTS_4_2(1)<=signed(MULTS_3_2(1)(PERCISION) & MULTS_3_2(1)(PERCISION downto 1))+signed(MULTS_3_3(1)(PERCISION) & MULTS_3_3(1)(PERCISION downto 1));
			MULTS_4_2(2)<=signed(MULTS_3_2(2)(PERCISION) & MULTS_3_2(2)(PERCISION downto 1))+signed(MULTS_3_3(2)(PERCISION) & MULTS_3_3(2)(PERCISION downto 1));



                         EN_SUM_MULT_5<='1';
		end if;


		------------------------- Enable NEXT STATGE MULTS START -----------------------

		if EN_SUM_MULT_5 = '1' then
			------------------------------------STAGE-5--------------------------------------
			MULTS_5_1(0)<=signed(MULTS_4_1(0)(PERCISION) & MULTS_4_1(0)(PERCISION downto 1))+signed(MULTS_4_2(0)(PERCISION) & MULTS_4_2(0)(PERCISION downto 1));
			MULTS_5_1(1)<=signed(MULTS_4_1(1)(PERCISION) & MULTS_4_1(1)(PERCISION downto 1))+signed(MULTS_4_2(1)(PERCISION) & MULTS_4_2(1)(PERCISION downto 1));
			MULTS_5_1(2)<=signed(MULTS_4_1(2)(PERCISION) & MULTS_4_1(2)(PERCISION downto 1))+signed(MULTS_4_2(2)(PERCISION) & MULTS_4_2(2)(PERCISION downto 1));



                        Enable_BIAS<='1';
		end if;


		------------------------------------STAGE-BIAS--------------------------------------
		if Enable_BIAS = '1' then

			BIAS_1<=(1+signed( MULTS_5_1(0)(PERCISION downto 1)));
			BIAS_2<=(1+signed( MULTS_5_1(1)(PERCISION downto 1)));
			BIAS_3<=(1+signed( MULTS_5_1(2)(PERCISION downto 1)));

			Enable_ReLU<='1';
			
		end if;

		if SIG_STRIDE>1 and Enable_ReLU='1' then
                 SIG_STRIDE<=SIG_STRIDE-1; end if;

	if  Enable_ReLU='1' then
		if VALID_NXTLYR_PIX<VALID_LOCAL_PIX and SIG_STRIDE>(STRIDE-1) then

			if BIAS_1>0 then
			ReLU_1<=BIAS_1;
			DOUT_BUF_1_6<=std_logic_vector(BIAS_1);
			else
			ReLU_1<= (			others => '0');
			DOUT_BUF_1_6<=(			others => '0');
			end if;
			if BIAS_2>0 then
			ReLU_2<=BIAS_2;
			DOUT_BUF_2_6<=std_logic_vector(BIAS_2);
			else
			ReLU_2<= (			others => '0');
			DOUT_BUF_2_6<=(			others => '0');
			end if;
			if BIAS_3>0 then
			ReLU_3<=BIAS_3;
			DOUT_BUF_3_6<=std_logic_vector(BIAS_3);
			else
			ReLU_3<= (			others => '0');
			DOUT_BUF_3_6<=(			others => '0');
			end if;

			EN_NXT_LYR_6<='1';FRST_TIM_EN_6<='1';
			OUT_PIXEL_COUNT<=OUT_PIXEL_COUNT+1;
		else
                       EN_NXT_LYR_6<='0';
                       DOUT_BUF_1_6<=(                       others => '0');
                       DOUT_BUF_2_6<=(                       others => '0');
                       DOUT_BUF_3_6<=(                       others => '0');

		end if; -- VALIDPIXELS

		if VALID_NXTLYR_PIX=(VALID_LOCAL_PIX*STRIDE)-1 then VALID_NXTLYR_PIX<=0;SIG_STRIDE<=STRIDE;   -- reset sride and valid pixels
		else VALID_NXTLYR_PIX<=VALID_NXTLYR_PIX+1;end if; 

	end if;  --ReLU
elsif OUT_PIXEL_COUNT>=VALID_CYCLES  then INTERNAL_RST<='1';SIG_STRIDE<=STRIDE;EN_NXT_LYR_6<='1';  -- order is very important
else  EN_NXT_LYR_6<='0';-- In case stream stopped

end if; -- end enable 
end if; -- for RST	
end if; -- rising edge
end process LAYER_6;

DOUT_1_6<=DOUT_BUF_1_6;
DOUT_2_6<=DOUT_BUF_2_6;

end Behavioral;
------------------------------ ARCHITECTURE DECLARATION - END---------------------------------------------

