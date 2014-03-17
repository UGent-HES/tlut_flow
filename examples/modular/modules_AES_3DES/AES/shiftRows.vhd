library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shiftRows is
port (
	input					:	in std_logic_vector(127 downto 0);
	output				:	out std_logic_vector(127 downto 0)
);
end shiftRows;

architecture Behavioral of shiftRows is
           
begin
   output(7 downto 0) <= input(7 downto 0);
   output(15 downto 8) <= input (15 downto 8);
   output(23 downto 16) <= input (23 downto 16);
   output(31 downto 24) <= input (31 downto 24);
   
   output(39 downto 32) <= input (47 downto 40);
   output(47 downto 40) <= input (55 downto 48);
   output(55 downto 48) <= input (63 downto 56);
   output(63 downto 56) <= input (39 downto 32);

   output(71 downto 64) <= input (87 downto 80);
   output(79 downto 72) <= input (95 downto 88);
   output(87 downto 80) <= input (71 downto 64);
   output(95 downto 88) <= input (79 downto 72);

   output(103 downto 96) <= input (127 downto 120);
   output(111 downto 104) <= input (103 downto 96);
   output(119 downto 112) <= input (111 downto 104);
   output(127 downto 120) <= input (119 downto 112);
  
end Behavioral;







