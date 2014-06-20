library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT1 is
generic (
    INIT : bit_vector(1 downto 0));
port (
    O : out STD_ULOGIC; 
	I0: in STD_ULOGIC);
end LUT1;

architecture rtl of LUT1 is
    signal address : std_ulogic_vector(0 downto 0);
begin

    address(0) <= I0;

    O <= to_stdulogic(INIT(to_integer(unsigned(address))));

end;