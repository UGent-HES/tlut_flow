library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity LUT6_2 is
generic (
    INIT : bit_vector);
port (
    O6 : out STD_ULOGIC;
    O5 : out STD_ULOGIC;
    I0 : in STD_ULOGIC;
    I1 : in STD_ULOGIC;
    I2 : in STD_ULOGIC;
    I3 : in STD_ULOGIC;
    I4 : in STD_ULOGIC;
    I5 : in STD_ULOGIC);
end LUT6_2;

architecture rtl of LUT6_2 is
    constant content : bit_vector(0 to 63) := "0111110100001111101000001111100001101001110011010011000011000101";
    signal address6 : std_ulogic_vector(5 downto 0);
    signal address5 : std_ulogic_vector(4 downto 0);
begin

    address6 <= I5 & I4 & I3 & I2 & I1 & I0;
    address5 <= I4 & I3 & I2 & I1 & I0;

    O6 <= to_stdulogic(content(to_integer(unsigned(address6))));
    O5 <= to_stdulogic(content(to_integer(unsigned(address5))));

end;
