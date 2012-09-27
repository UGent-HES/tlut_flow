--TMAP
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

-- synopsys translate_off
library UNISIM;
use unisim.Vcomponents.all;
-- synopsys translate_on

entity treeMult4b is
generic (
    DATA_WIDTH      : integer := 4
);

port(
	shift_in : in std_logic;
	clk_e : in std_logic;
	shift_clk : in std_logic;
	shift_out : out std_logic;
    a   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
    o   :   out  std_logic_vector(3*DATA_WIDTH-1 downto 0)
	 );
end treeMult4b;

architecture rtl of treeMult4b is
component SRLC16E
generic (
	INIT : bit_vector := X"0001");
port   (Q : out STD_LOGIC;
	CLK : in STD_LOGIC;
	CE : in STD_LOGIC;
	D : in STD_LOGIC;
	Q15 : out STD_LOGIC;
	A0 : in STD_LOGIC;
	A1 : in STD_LOGIC;
	A2 : in STD_LOGIC;
	A3 : in STD_LOGIC);
end component;

component FD
generic (
	INIT : bit:= '1');
port   (Q : out STD_ULOGIC;
	C : in STD_ULOGIC;
	D : in STD_ULOGIC);
end component;

signal a26 : STD_LOGIC ;
signal a26q : STD_LOGIC ;
signal a40not : STD_LOGIC ;
signal a40notq : STD_LOGIC ;
signal a68not : STD_LOGIC ;
signal a68notq : STD_LOGIC ;
signal a138not : STD_LOGIC ;
signal a138notq : STD_LOGIC ;
signal a214not : STD_LOGIC ;
signal a214notq : STD_LOGIC ;
signal a296not : STD_LOGIC ;
signal a296notq : STD_LOGIC ;
signal a382not : STD_LOGIC ;
signal a382notq : STD_LOGIC ;
signal a470not : STD_LOGIC ;
signal a470notq : STD_LOGIC ;
signal a546not : STD_LOGIC ;
signal a546notq : STD_LOGIC ;
signal a614not : STD_LOGIC ;
signal a614notq : STD_LOGIC ;
signal a652not : STD_LOGIC ;
signal a652notq : STD_LOGIC ;
signal a660not : STD_LOGIC ;
signal a660notq : STD_LOGIC ;
signal a0,a1,a2,a3 : STD_LOGIC ;

attribute INIT : string;
attribute INIT of treeMult4b_LUT1_a26: label is "2";
attribute INIT of treeMult4b_LUT2_a40not: label is "4";
attribute INIT of treeMult4b_LUT3_a68not: label is "8";
attribute INIT of treeMult4b_LUT4_a138not: label is "16";
attribute INIT of treeMult4b_LUT4_a214not: label is "16";
attribute INIT of treeMult4b_LUT4_a296not: label is "16";
attribute INIT of treeMult4b_LUT4_a382not: label is "16";
attribute INIT of treeMult4b_LUT4_a470not: label is "16";
attribute INIT of treeMult4b_LUT4_a546not: label is "16";
attribute INIT of treeMult4b_LUT4_a614not: label is "16";
attribute INIT of treeMult4b_LUT4_a652not: label is "16";
attribute INIT of treeMult4b_LUT4_a660not: label is "16";

attribute lock_pins : string;
attribute lock_pins of SRLC16E: component is "ALL";

begin

treeMult4b_LUT1_a26: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a26,
	Q15 => a26q,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(0),
	A1 => a1,
	A2 => a2,
	A3 => a3,
	D => shift_in);

treeMult4b_LUT2_a40not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a40not,
	Q15 => a40notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(1),
	A1 => a(0),
	A2 => a2,
	A3 => a3,
	D => a26q);

treeMult4b_LUT3_a68not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a68not,
	Q15 => a68notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(1),
	A2 => a(0),
	A3 => a3,
	D => a40notq);

treeMult4b_LUT4_a138not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a138not,
	Q15 => a138notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a68notq);

treeMult4b_LUT4_a214not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a214not,
	Q15 => a214notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a138notq);

treeMult4b_LUT4_a296not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a296not,
	Q15 => a296notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a214notq);

treeMult4b_LUT4_a382not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a382not,
	Q15 => a382notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a296notq);

treeMult4b_LUT4_a470not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a470not,
	Q15 => a470notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a382notq);

treeMult4b_LUT4_a546not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a546not,
	Q15 => a546notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a470notq);

treeMult4b_LUT4_a614not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a614not,
	Q15 => a614notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a546notq);

treeMult4b_LUT4_a652not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a652not,
	Q15 => a652notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a614notq);

treeMult4b_LUT4_a660not: SRLC16E
generic map (
	INIT =>X"0001")
port map (
	Q => a660not,
	Q15 => a660notq,
	CLK => shift_clk,
	CE => clk_e,
	A0 => a(2),
	A1 => a(3),
	A2 => a(1),
	A3 => a(0),
	D => a652notq);
shift_out <= a660notq;

o(0) <= a26;
o(1) <= a40not;
o(2) <= a68not;
o(3) <= a138not;
o(4) <= a214not;
o(5) <= a296not;
o(6) <= a382not;
o(7) <= a470not;
o(8) <= a546not;
o(9) <= a614not;
o(10) <= a652not;
o(11) <= a660not;
end;