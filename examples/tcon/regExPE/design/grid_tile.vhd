--TMAP
library ieee;
use ieee.std_logic_1164.all;

use work.all;

entity grid_tile is
	generic ( N : natural := 8);
	port(
	clk : in std_logic;
	reset: in std_logic;
	--in
	Op_In_v: in  std_logic_vector(4 downto 0);
	Ff_In: in  std_logic;
	Fb_In: in  std_logic;
	condition : in std_logic;
	--PARAM
	in_sel  : in natural range 0 to 4;
	Ff_en   : in std_logic;
	Fb_en   : in std_logic;
	loopback_en : in std_logic;
	fastforward_en : in std_logic;
	counter_en : in std_logic;
	dummy_en : in std_logic;
    cntr_N : in std_logic_vector( N-1 downto 0);
    cntr_M : in std_logic_vector( N-1 downto 0);
	--PARAM
	--out
	Op_Out: out  std_logic;
	Ff_out: out  std_logic;
	Fb_Out: out  std_logic
	);
end grid_tile;

architecture RTL of grid_tile is
begin

    Counter_ent: entity work.top_genericblock
    generic map (
        N => N
        )
    port map (
        clk => clk,
        reset => reset,
        Op_In => Op_In_v(in_sel),
        Ff_In => Ff_In,
        Fb_In => Fb_In,
        condition => condition,
        Ff_en   => Ff_en,
        Fb_en   => Fb_en,
        loopback_en => loopback_en,
        fastforward_en => fastforward_en,
        counter_en => counter_en,
        dummy_en => dummy_en,
        cntr_N => cntr_N,
        cntr_M => cntr_M,
        Op_Out => Op_Out,
        Ff_out => Ff_out,
        Fb_Out => Fb_Out
        );

	
end architecture RTL;
