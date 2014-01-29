library ieee;
use ieee.std_logic_1164.all;

entity test2 is
port	(
		clk	: in std_logic;
		in_signal1, in_signal2   : in std_logic;	
		out_signal, out_signal_n, out_signal_n2 : out std_logic
	);
end test2;

architecture rtl of test2 is
	signal reg_signal, reg_signal_n : std_logic;
begin
	process(clk)
	begin
		if rising_edge(clk) then
			reg_signal <= in_signal1 and in_signal2;
			reg_signal_n <= not(in_signal1 and in_signal2);
		end if;
	end process;

	out_signal <= reg_signal;
	out_signal_n <= not(reg_signal);
	out_signal_n2 <= reg_signal_n;
end rtl;
