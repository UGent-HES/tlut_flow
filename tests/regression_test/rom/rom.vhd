--TMAP

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;


entity rom is
    generic(
    N : integer := 6
);
    port(
    --PARAM
    p : in  std_logic_vector(2**N-1 downto 0);
    --PARAM
    a : in  std_logic_vector(N-1 downto 0);
    d : out std_logic --==_vector(0 downto 0)
);
end rom;

architecture rtl of rom is
begin

    d <= p(to_integer(unsigned(a)));

end rtl;
 
