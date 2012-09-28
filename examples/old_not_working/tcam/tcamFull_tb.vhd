library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg.all;

entity tcamFull_tb is
end tcamFull_tb;

architecture behaviour of tcamFull_tb is

signal	clk			:	std_logic	:=	'0';
signal	rst			:	std_logic	:=	'0';

signal	en			:	std_logic;
signal	rw			:	std_logic;
	
signal	data		:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal	mask		:	std_logic_vector(DATA_WIDTH-1 downto 0);
signal	addrin		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
		
signal	addrout		:	std_logic_vector(ADDR_WIDTH-1 downto 0);
signal	match		:	std_logic;


begin

	DUT: entity work.tcamFull
	port map (
		clk => clk,
		rst => rst,
		en => en,
		rw => rw,
	
		data => data,
		mask => mask,
		addrin => addrin,
		
		addrout => addrout,
		match => match
	);


	STIM : process is
	begin
		data	<=	std_logic_vector(to_unsigned(1,DATA_WIDTH));
		mask	<=	std_logic_vector(to_unsigned(0,DATA_WIDTH));
		addrin	<=	std_logic_vector(to_unsigned(0,ADDR_WIDTH));
		en		<=	'1';
		rw		<=	'1';
		
		wait for 100 ns;
		
		data	<=	std_logic_vector(to_unsigned(2,DATA_WIDTH));
		mask	<=	std_logic_vector(to_unsigned(1,DATA_WIDTH));
		addrin	<=	std_logic_vector(to_unsigned(1,ADDR_WIDTH));
		en		<=	'1';
		rw		<=	'1';
		
		wait for 100 ns;
		
		data	<=	std_logic_vector(to_unsigned(4,DATA_WIDTH));
		mask	<=	std_logic_vector(to_unsigned(2,DATA_WIDTH));
		addrin	<=	std_logic_vector(to_unsigned(2,ADDR_WIDTH));
		en		<=	'1';
		rw		<=	'1';
		
		wait for 100 ns;
		
		data	<=	std_logic_vector(to_unsigned(4,DATA_WIDTH));
		mask	<=	std_logic_vector(to_unsigned(3,DATA_WIDTH));
		addrin	<=	std_logic_vector(to_unsigned(3,ADDR_WIDTH));
		en		<=	'1';
		rw		<=	'1';
		
		wait for 100 ns;


		for i in 0 to 15 loop
			data	<=	std_logic_vector(to_unsigned(i,DATA_WIDTH));
			mask	<=	(others => '0');
			addrin	<=	(others => '0');
			en		<=	'1';
			rw		<=	'0';
					
			wait for 100 ns; 
		end loop;	
		
		wait;	

	end process STIM;


	CLOCK: process
	begin
		wait for 50 ns;
		clk <= not clk;
	end process;
	
end behaviour;