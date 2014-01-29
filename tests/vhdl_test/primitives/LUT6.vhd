library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT6 is
generic (
    INIT : bit_vector(63 downto 0));
port (
    O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC; 
	I3: in STD_ULOGIC; 
	I4: in STD_ULOGIC; 
	I5: in STD_ULOGIC);
end LUT6;

architecture rtl of LUT6 is
    signal address : std_ulogic_vector(5 downto 0);
begin

    address <= I5 & I4 & I3 & I2 & I1 & I0;

    O <= to_stdulogic(INIT(to_integer(unsigned(address))));

end;