library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
generic (
    DATA_WIDTH_A      : integer := _DATA_WIDTH_A;
    DATA_WIDTH_B      : integer := _DATA_WIDTH_B
);
port(
    a   :   in  std_logic_vector(DATA_WIDTH_A-1 downto 0);
    b   :   in  std_logic_vector(DATA_WIDTH_B-1 downto 0);
    o   :   out  std_logic_vector(DATA_WIDTH_A + DATA_WIDTH_B - 1 downto 0)
);
end mult;

architecture behavior of mult is
begin
    o <= std_logic_vector(unsigned(a) * unsigned(b));
end behavior;
