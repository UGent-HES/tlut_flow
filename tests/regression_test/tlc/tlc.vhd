library ieee;
use ieee.std_logic_1164.all;

-- TLC test
entity tlc is
port	(
		in_signal                : in std_logic_vector(7 downto 0);
--PARAM
		p                        : in std_logic;
--PARAM
		out_signal1              : out std_logic
		);
end tlc;

architecture rtl of tlc is
    signal mux1 : std_logic;
begin
	mux1 <= in_signal(1) when p='1' else not(in_signal(2));
	out_signal1 <= mux1 and in_signal(3) and in_signal(4) and in_signal(5)
	    and in_signal(6) and in_signal(7);
end rtl;
