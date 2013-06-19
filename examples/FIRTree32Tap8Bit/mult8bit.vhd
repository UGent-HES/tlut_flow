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

library work;
use work.all; 


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult8bit is
generic (
    DATA_WIDTH  : integer := 8
);
port(
    a   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
    b   :   in  std_logic_vector(7 downto 0);
    c   :   out  std_logic_vector((2*DATA_WIDTH)-1 downto 0)
    );
end mult8bit;

architecture Behavioral of mult8bit is

	signal right : std_logic_vector((DATA_WIDTH)+4-1 downto 0);
	signal left  :  std_logic_vector((DATA_WIDTH)+4-1 downto 0);
	signal left_shifted  :  std_logic_vector((2*DATA_WIDTH)-1 downto 0);
	signal new_right  :  std_logic_vector((2*DATA_WIDTH)-1 downto 0);
begin

		  MULTIPLIER_right:entity work.treeMult4b
   port map(

	a => a(3 downto 0),
	b => b,
	o => right
);

	MULTIPLIER_left:entity work.treeMult4b
   port map(

	a => a(7 downto 4),
	b => b,
	o => left
);		  
	 	
  	    left_shifted <= left & "0000" ;
		 -- left_shifted <= std_logic_vector("sll"(unsigned(left), 4));
		  
		 new_right <= "0000" & right;
		  
		   
		 c <= unsigned(new_right) + unsigned(left_shifted) ;
			

end Behavioral;
