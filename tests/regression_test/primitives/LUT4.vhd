library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT4 is
generic (
    INIT : bit_vector(15 downto 0));
port (
    O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC; 
	I3: in STD_ULOGIC);
end LUT4;

architecture rtl of LUT4 is
    signal address : std_ulogic_vector(3 downto 0);
begin

    address <= I3 & I2 & I1 & I0;

    O <= to_stdulogic(INIT(to_integer(unsigned(address))));

end;