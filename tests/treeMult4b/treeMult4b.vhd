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
    a   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
    o   :   out  std_logic_vector(3*DATA_WIDTH-1 downto 0)
	 );
end treeMult4b;

architecture rtl of treeMult4b is
component LUT1
generic (
	INIT : bit_vector := X"2");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC);
end component;
component LUT2
generic (
	INIT : bit_vector := X"4");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC);
end component;
component LUT3
generic (
	INIT : bit_vector := X"8");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC);
end component;
component LUT4
generic (
	INIT : bit_vector := X"16");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC; 
	I3: in STD_ULOGIC);
end component;
component FD
generic (
	INIT : bit:= '1');
port   (Q : out STD_ULOGIC;
	C : in STD_ULOGIC;
	D : in STD_ULOGIC);
end component;

signal a26 : STD_ULOGIC ;
signal a40not : STD_ULOGIC ;
signal a68not : STD_ULOGIC ;
signal a138not : STD_ULOGIC ;
signal a214not : STD_ULOGIC ;
signal a296not : STD_ULOGIC ;
signal a382not : STD_ULOGIC ;
signal a470not : STD_ULOGIC ;
signal a546not : STD_ULOGIC ;
signal a614not : STD_ULOGIC ;
signal a652not : STD_ULOGIC ;
signal a660not : STD_ULOGIC ;

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
attribute lock_pins of LUT1: component is "ALL";
attribute lock_pins of LUT2: component is "ALL";
attribute lock_pins of LUT3: component is "ALL";
attribute lock_pins of LUT4: component is "ALL";

begin

treeMult4b_LUT1_a26: LUT1
generic map (
	INIT =>X"1")
port map (O => a26,
	I0 => a(0));

treeMult4b_LUT2_a40not: LUT2
generic map (
	INIT =>X"1")
port map (O => a40not,
	I0 => a(1),
	I1 => a(0));

treeMult4b_LUT3_a68not: LUT3
generic map (
	INIT =>X"1")
port map (O => a68not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(0));

treeMult4b_LUT4_a138not: LUT4
generic map (
	INIT =>X"1")
port map (O => a138not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a214not: LUT4
generic map (
	INIT =>X"1")
port map (O => a214not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a296not: LUT4
generic map (
	INIT =>X"1")
port map (O => a296not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a382not: LUT4
generic map (
	INIT =>X"1")
port map (O => a382not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a470not: LUT4
generic map (
	INIT =>X"1")
port map (O => a470not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a546not: LUT4
generic map (
	INIT =>X"1")
port map (O => a546not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a614not: LUT4
generic map (
	INIT =>X"1")
port map (O => a614not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a652not: LUT4
generic map (
	INIT =>X"1")
port map (O => a652not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));

treeMult4b_LUT4_a660not: LUT4
generic map (
	INIT =>X"1")
port map (O => a660not,
	I0 => a(1),
	I1 => a(2),
	I2 => a(3),
	I3 => a(0));
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