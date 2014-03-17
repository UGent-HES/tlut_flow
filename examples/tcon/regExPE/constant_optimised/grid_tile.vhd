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
	--PARAM
	--out
	Op_Out: out  std_logic;
	Ff_out: out  std_logic;
	Fb_Out: out  std_logic
	);
end grid_tile;

architecture RTL of grid_tile is

	signal in_sel  : natural range 0 to 4 := 0;
	signal Ff_en   : std_logic := '$Ff_en$';
	signal Fb_en   : std_logic := '$Fb_en$';
	signal loopback_en : std_logic := '$loopback_en$';
	signal fastforward_en : std_logic := '$fastforward_en$';
	signal counter_en : std_logic := '$counter_en$';
	signal dummy_en : std_logic := '$dummy_en$';
    signal cntr_N : std_logic_vector( N-1 downto 0) := X"55";
    signal cntr_M : std_logic_vector( N-1 downto 0) := X"AA";
    
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