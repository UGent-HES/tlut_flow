--TMAP

------------------------------------------------------
-- Author   : Tom Davidson
--            Ghent University
--            Electronics and Information Systems (ELIS) Department
-- Project  : thesis
-- Date     : 17 April 2009
-- Version  : 0.1
-- Description: "Comparing DNA sequences in FPGA"
------------------------------------------------------
-- SW cell description
-- version 0.1: smallest possible size of TLUT file
------------------------------------------------------

--library plb_aligner_32bit_v1_00_a;
--use work.all;

library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subst_row_mem is
	generic (
		score_bits         : integer :=16;
		substitution_bits  : integer :=6;
		gap_open_bits      : integer :=4;
		gap_extension_bits : integer :=4;
		alphabet_bits      : integer :=5;
		alphabet_size      : integer :=24;
		log_max_rows       : integer :=11;
		log_max_cols       : integer :=11;
		num_cells		   : integer :=15;
		--max_caches         : integer :=22;
		cell_index         : integer :=0;
		platform           : string  :="SIMULATION";
		pipelined_computation : boolean := false;
		fast_adders        : boolean := false;
		max_select_slice   : integer := 4;
		sub_select_slice   : integer := 4
	--altera_caches      : boolean := false
	);
	port (	
		clk	: in std_logic;
		--substitution matrix row input

--PARAM
subst_row : in std_logic_vector(143 downto 0);
--PARAM
		
		-- substitution matrix lookup
		row_char : in std_logic_vector(4 downto 0);
		substitution_cost : out std_logic_vector(5 downto 0)
		);
end subst_row_mem;

architecture rtl of subst_row_mem is
	
begin
	process(clk)--for downto, change if clk is removed
	begin
		if rising_edge(clk) then--added to make the behaviour clocked, NOT working correctly (makes the max column be one higher)
	 	case row_char is
	 		when "00000" => substitution_cost <= subst_row(143 downto 138);--0
		 	when "00001" => substitution_cost <= subst_row(137 downto 132);--1
	 		when "00010" => substitution_cost <= subst_row(131 downto 126);--2
	 		when "00011" => substitution_cost <= subst_row(125 downto 120);--3
	 		when "00100" => substitution_cost <= subst_row(119 downto 114);--4
	 		when "00101" => substitution_cost <= subst_row(113 downto 108);--5
	 		when "00110" => substitution_cost <= subst_row(107 downto 102);--6
	 		when "00111" => substitution_cost <= subst_row(101 downto 96);--7
	 		when "01000" => substitution_cost <= subst_row(95 downto 90);--8
	 		when "01001" => substitution_cost <= subst_row(89 downto 84);--9
	 		when "01010" => substitution_cost <= subst_row(83 downto 78);--10
	 		when "01011" => substitution_cost <= subst_row(77 downto 72);--11
	 		when "01100" => substitution_cost <= subst_row(71 downto 66);--12
	 		when "01101" => substitution_cost <= subst_row(65 downto 60);--13
	 		when "01110" => substitution_cost <= subst_row(59 downto 54);--14
	 		when "01111" => substitution_cost <= subst_row(53 downto 48);--15
	 		when "10000" => substitution_cost <= subst_row(47 downto 42);--16
	 		when "10001" => substitution_cost <= subst_row(41 downto 36);--17
	 		when "10010" => substitution_cost <= subst_row(35 downto 30);--18
	 		when "10011" => substitution_cost <= subst_row(29 downto 24);--19
	 		when "10100" => substitution_cost <= subst_row(23 downto 18);--20
	 		when "10101" => substitution_cost <= subst_row(17 downto 12);--21
	 		when "10110" => substitution_cost <= subst_row(11 downto 6);--22
	 		when "10111" => substitution_cost <= subst_row(5 downto 0);--23
	 		when others => substitution_cost <= "000000";
	 	end case;
	 end if;
	 end process;
end rtl;
