library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rotword is
 port (
	word : in std_logic_vector (31 downto 0);
	word_out : out std_logic_vector (31 downto 0)
);

end rotword;
 architecture behavioural of rotword is
	
begin	
	word_out(31 downto 24) <= word(23 downto 16);
	word_out(23 downto 16) <= word(15 downto 8);
	word_out(15 downto 8) <= word(7 downto 0);
	word_out(7 downto 0) <= word(31 downto 24);
		
end architecture behavioural;