--TMAP

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:47 04/14/2008 
-- Design Name: 
-- Module Name:    mult8bit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult16bit is
generic (
    DATA_WIDTH  : integer := 16
);
port(
    a   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
--PARAM
    b   :   in  std_logic_vector(15 downto 0);
--PARAM	
    o   :   out  std_logic_vector((2*DATA_WIDTH)-1 downto 0)
    );
end mult16bit;

architecture Behavioral of mult16bit is

	type nibble_type is array (0 to DATA_WIDTH/4-1) of std_logic_vector((DATA_WIDTH)+4-1 downto 0);
	signal nibbles : nibble_type;
	type output_type_array is array (natural range <>) of std_logic_vector((2*DATA_WIDTH)-1 downto 0);
	signal shifted_nibbles : output_type_array(0 to DATA_WIDTH/4-1);
	signal interm_carry : output_type_array(0 to 2);
	signal inter : output_type_array(0 to 2);
begin

 MULTIPLIERS: for i in 1 to DATA_WIDTH/4 generate
   MULTIPLIER:entity work.treeMult4b
   port map(
	a => a(i*4-1 downto i*4-4),
--PARAM
	b => b,
--PARAM
	o => nibbles(i-1)
);
end generate MULTIPLIERS;

	 	shifted_nibbles(0) <= x"000" & nibbles(0);
	 	shifted_nibbles(1) <= x"00" & nibbles(1) & x"0";
	 	shifted_nibbles(2) <= x"0" & nibbles(2) & x"00";
	 	shifted_nibbles(3) <= nibbles(3) & x"000";
	 	
	 	inter(0) <= shifted_nibbles(0) 
	 	 xor shifted_nibbles(1);
	 	interm_carry(0) <= shifted_nibbles(0) and shifted_nibbles(1);
	 	
	 	inter(1) <= inter(0) 
	 	 xor shifted_nibbles(2) 
	 	 xor (interm_carry(0)((2*DATA_WIDTH)-2 downto 0) & '0');
	 	interm_carry(1) <= (inter(0) and shifted_nibbles(2)) 
	 	 or (inter(0) and (interm_carry(0)((2*DATA_WIDTH)-2 downto 0) & '0')) 
	 	 or ((interm_carry(0)((2*DATA_WIDTH)-2 downto 0) & '0') and shifted_nibbles(2));
	 	
	 	inter(2) <= inter(1) 
	 	 xor shifted_nibbles(3) 
	 	 xor (interm_carry(1)((2*DATA_WIDTH)-2 downto 0) & '0');
	 	interm_carry(2) <= (inter(1) and shifted_nibbles(3)) 
	 	 or (inter(1) and (interm_carry(1)((2*DATA_WIDTH)-2 downto 0) & '0')) 
	 	 or ((interm_carry(1)((2*DATA_WIDTH)-2 downto 0) & '0') and shifted_nibbles(3));
	 	
	 	--o <= unsigned(inter(2)) + unsigned(interm_carry(2)((2*DATA_WIDTH)-2 downto 0) & '0');
		 
		o <= unsigned(shifted_nibbles(0)) + unsigned(shifted_nibbles(1)) + unsigned(shifted_nibbles(2)) + unsigned(shifted_nibbles(3)) ;
			

end Behavioral;

