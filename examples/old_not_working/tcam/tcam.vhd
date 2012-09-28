--TMAP
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg.all;

entity tcam is
	port (
		clk			:	in	std_logic;
		rst			:	in	std_logic;
		en			:	in	std_logic;
	
		data		:	in	std_logic_vector(DATA_WIDTH-1 downto 0);
		
		--PARAM		
		content		:	in	entries;
		--PARAM
		
		addrout		:	out std_logic_vector(ADDR_WIDTH-1 downto 0);
		match		:	out	std_logic
	);
end tcam;

architecture rtl of tcam is
begin

	TCAM_READ:process (clk, rst) is
	begin
	    if rst = '1' then
	    elsif rising_edge(clk) then
			if (en = '1' and matchExists(data,content) = '1') then
				match	<=	'1';
				addrout	<=	findMatch(data,content);
			else
				match	<=	'0';
				addrout	<=	(others => '0');	
			end if;
	    end if;
	end process TCAM_READ;

end architecture rtl;
