library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mixColumns is
port (
	input					:	in std_logic_vector(127 downto 0);
	output				:	out std_logic_vector(127 downto 0)
);
end mixColumns;

architecture Behavioral of mixColumns is
    signal inColumn0 : std_logic_vector(31 downto 0);
    signal inColumn1 : std_logic_vector(31 downto 0);
    signal inColumn2 : std_logic_vector(31 downto 0);
    signal inColumn3 : std_logic_vector(31 downto 0);
    
    signal outColumn0 : std_logic_vector(31 downto 0);
    signal outColumn1 : std_logic_vector(31 downto 0);
    signal outColumn2 : std_logic_vector(31 downto 0);
    signal outColumn3 : std_logic_vector(31 downto 0);

begin

inColumn0 <= input(103 downto 96) & input(71 downto 64) & input(39 downto 32) & input(7 downto 0);
inColumn1 <= input(111 downto 104) & input(79 downto 72) & input(47 downto 40) & input(15 downto 8);
inColumn2 <= input(119 downto 112) & input(87 downto 80) & input(55 downto 48) & input(23 downto 16);
inColumn3 <= input(127 downto 120) & input(95 downto 88) & input(63 downto 56) & input(31 downto 24);

output <= outColumn3(31 downto 24)&outColumn2(31 downto 24)&outColumn1(31 downto 24)&outColumn0(31 downto 24)&
          outColumn3(23 downto 16)&outColumn2(23 downto 16)&outColumn1(23 downto 16)&outColumn0(23 downto 16)&
          outColumn3(15 downto 8)&outColumn2(15 downto 8)&outColumn1(15 downto 8)&outColumn0(15 downto 8)&
          outColumn3(7 downto 0)&outColumn2(7 downto 0)&outColumn1(7 downto 0)&outColumn0(7 downto 0);
          
MIXCOLUMN0 : entity work.mixColumn 
   port map (
      input => inColumn0,
      output => outColumn0
   );

MIXCOLUMN1 : entity work.mixColumn 
   port map (
      input => inColumn1,
      output => outColumn1
   );

MIXCOLUMN2 : entity work.mixColumn 
   port map (
      input => inColumn2,
      output => outColumn2
   );

MIXCOLUMN3 : entity work.mixColumn 
   port map (
      input => inColumn3,
      output => outColumn3
   );

  
end Behavioral;




