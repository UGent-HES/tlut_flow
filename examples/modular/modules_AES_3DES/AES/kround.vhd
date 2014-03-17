
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity kround is
port (

            key             :   in      std_logic_vector(127 downto 0);

            roundkey          :   out std_logic_vector(127 downto 0);
            roundnr			: in std_logic_vector(3 downto 0)
);
end kround;

architecture Behavioral of kround is
   	signal inWord0 : std_logic_vector(31 downto 0);
    signal inWord1 : std_logic_vector(31 downto 0);
    signal inWord2 : std_logic_vector(31 downto 0);
    signal inWord3 : std_logic_vector(31 downto 0);
    
    signal outWord0 : std_logic_vector(31 downto 0);
    signal outWord1 : std_logic_vector(31 downto 0);
    signal outWord2 : std_logic_vector(31 downto 0);
    signal outWord3 : std_logic_vector(31 downto 0);
    
    signal temp : std_logic_vector(31 downto 0);
	
	signal rot_word : std_logic_vector(31 downto 0);
	signal sub_word : std_logic_vector(31 downto 0);
	type trcon is array (0 to 9) of integer;
	constant rcon : trcon := (16#01000000#, 16#02000000#, 16#04000000#, 16#08000000#, 16#10000000#, 16#20000000#, 16#40000000#, 16#80000000#, 16#1b000000#, 16#36000000# ); 
begin

inWord3 <= key(127 downto 96);
inWord2 <= key(95 downto 64);
inWord1 <= key(63 downto 32);
inWord0 <= key(31 downto 0);

RT : entity work.rotword(behavioural)
	port map (
		word => inWord0,
		word_out => rot_word
		);
		
SW : entity work.subword(behavioural)
	port map (
		word_in => rot_word,
		word_out => sub_word
		);
temp <= (sub_word xor CONV_STD_LOGIC_VECTOR(rcon(CONV_INTEGER(roundnr)-1),32));
outWord0 <= temp xor inWord3;
outWord1 <= inWord2 xor outWord0;
outword2 <= inWord1 xor outWord1;
outWord3 <= inWord0 xor outWord2;

roundkey <= outWord0 & outWord1 & outWord2 & outWord3;       

end Behavioral;
