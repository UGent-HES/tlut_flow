
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AddRoundKey is
port (
	input				:	in std_logic_vector(127 downto 0);

	key					:	in std_logic_vector(127 downto 0);

	output				:	out std_logic_vector(127 downto 0)
);
end AddRoundKey;

architecture Behavioral of AddRoundKey is
begin

output <= input xor key;
	
end Behavioral;
