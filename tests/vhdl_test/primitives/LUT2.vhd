library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT2 is
generic (
    INIT : bit_vector(3 downto 0));
port (
    O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC);
end LUT2;

architecture rtl of LUT2 is
    signal address : std_ulogic_vector(1 downto 0);
begin

    address <= I1 & I0;

    O <= to_stdulogic(INIT(to_integer(unsigned(address))));

end;