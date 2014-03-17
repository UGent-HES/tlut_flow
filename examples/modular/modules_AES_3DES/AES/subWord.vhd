library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity subword is
 port (
	word_in : in std_logic_vector (31 downto 0);
	word_out : out std_logic_vector (31 downto 0)
);

end subword;
 architecture behavioural of subword is
	
begin
GEN:for i in 0 to 3 generate 
      	SUB:entity work.subByte
	      port map (input => word_in(i*8+7 downto i*8), output => word_out(i*8+7 downto i*8));
   end generate;		
end architecture behavioural;