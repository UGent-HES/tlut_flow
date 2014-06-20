library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT3 is
generic (
    INIT : bit_vector(7 downto 0));
port (
    O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC);
end LUT3;

architecture rtl of LUT3 is
    signal address : std_ulogic_vector(2 downto 0);
begin

    address <= I2 & I1 & I0;

    O <= to_stdulogic(INIT(to_integer(unsigned(address))));

end;