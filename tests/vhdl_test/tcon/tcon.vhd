library ieee;
use ieee.std_logic_1164.all;

-- TCON test
entity tcon is
port	(
		in_signal1, in_signal2,
		in_signal3, in_signal4,
		in_signal5, in_signal6   : in std_logic;
--PARAM
		p                        : in std_logic;
--PARAM
		out_signal1, out_signal2,
		out_signal3, out_signal4 : out std_logic
		);
end tcon;

architecture rtl of tcon is
begin
	out_signal1 <= in_signal1 when p='1' else in_signal2;
	out_signal2 <= in_signal3 when p='1' else not(in_signal4);
	out_signal3 <= in_signal5 when p='1' else '1';
	out_signal4 <= in_signal6 when p='1' else '0';
end rtl;
