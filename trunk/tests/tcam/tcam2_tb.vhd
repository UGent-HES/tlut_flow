library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg2.all;

entity tcamFull_tb is
end tcamFull_tb;

architecture behaviour of tcamFull_tb is
signal	entry		:	entry_array := (others => ('0',(others => '0'),(others => '0')));
signal	datain		:	std_logic_vector(DATA_W-1 downto 0);
signal	addrout		:	std_logic_vector(ADDR_W-1 downto 0);
signal	match		:	std_logic;

begin

	DUT: entity work.tcam2
	port map (
        entry => entry,
		datain => datain,
		addrout => addrout,
		match => match
	);


	STIM : process is
	begin
		
		entry <= (	('0',"0000","0000"),
					('1',"0001","0000"),
					('1',"0010","0000"),
					('1',"0011","0000"),
					('1',"0100","0000"),
					('1',"0101","0000"),
					('1',"0100","0011"),
					('1',"1100","0011"),
					('1',"1000","0001"),
					('0',"0000","0000"),
					('0',"0000","0000"),
					('0',"0000","0000"),
					('0',"0000","0000"),
					('0',"0000","0000"),
					('0',"0000","0000"),
					('1',"1111","0000"));
		
		for i in 0 to 15 loop
			datain	<=	std_logic_vector(to_unsigned(i,DATA_W));
			wait for 100 ns; 
		end loop;	
		
		wait;	

	end process STIM;


end behaviour;