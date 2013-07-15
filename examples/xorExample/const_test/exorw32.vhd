--TMAP

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity exorw32 is
    port(
    --PARAM
    p : in  std_logic_vector(31 downto 0);
    --PARAM
    b : in  std_logic_vector(31 downto 0);
    x : out std_logic_vector(31 downto 0)
);
end exorw32;

architecture behavior of exorw32 is
    signal c : std_logic_vector(31 downto 0) := X"0f000000";
begin

EXORS : process (b, p)
begin
    for i in 31 downto 24 loop
        x(i) <= b(i) xor c(i);
    end loop;
    for i in 23 downto 0 loop
        x(i) <= b(i) xor p(i);
    end loop;
end process;

end behavior;
 
