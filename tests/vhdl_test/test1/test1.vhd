library ieee;
use ieee.std_logic_1164.all;

entity test1 is
port	(
		in_signal1, in_signal2   : in std_logic;	
		out_signal, out_signal_n : out std_logic
		);
end test1;

architecture rtl of test1 is
begin
	out_signal <= in_signal1 and in_signal2;
	out_signal_n <= not(in_signal1 and in_signal2);
end rtl;
