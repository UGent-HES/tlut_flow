library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity subBytes is
port (
	input					:	in std_logic_vector(127 downto 0);
	output				:	out std_logic_vector(127 downto 0)
);
end subBytes;

architecture Behavioral of subBytes is
           
begin
   GEN:for i in 0 to 15 generate 
      	SUB:entity work.subByte
	      port map (input => input(i*8+7 downto i*8), output => output(i*8+7 downto i*8));
   end generate; 
end Behavioral;





