library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vector is
    port(
    a : in  std_logic_vector(31 downto 0);
    b : in  std_logic_vector(31 downto 0);
    x : out std_logic_vector(31 downto 0)
);
end vector;

architecture rtl of vector is
begin

    x <= a xor b;

end rtl;
