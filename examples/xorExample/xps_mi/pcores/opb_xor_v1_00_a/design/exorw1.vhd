--TMAP

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity exorw1 is
    port(
    --PARAM
    p : in  std_logic;
    --PARAM
    a : in  std_logic;
    x : out std_logic
);
end exorw1;

architecture behavior of exorw1 is
begin

x <= a xor p;

end behavior;
 
