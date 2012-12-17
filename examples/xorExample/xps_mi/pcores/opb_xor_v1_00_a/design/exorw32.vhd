library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity exorw32 is
    port(
    --PARAM
    p : in  std_logic_vector(31 downto 0);
    --PARAM
    a : in  std_logic_vector(31 downto 0);
    x : out std_logic_vector(31 downto 0)
);
end exorw32;

architecture behavior of exorw32 is
begin

EXORS: for i in 0 to 31 generate
    EXOR: entity work.exorw1
    port map (
        a => a(i),
        p => p(i),
        x => x(i)
    );
end generate EXORS;

end behavior;
 
