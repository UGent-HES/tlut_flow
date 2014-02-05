library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity const is
    port(
    p : in  std_logic_vector(31 downto 0);
    b : in  std_logic_vector(31 downto 0);
    x : out std_logic_vector(31 downto 0)
);
end const;

architecture behavior of const is
    constant c : std_logic_vector(31 downto 0) := X"aa000000";
begin

process (b, p)
begin
    for i in 31 downto 28 loop
        x(i) <= c(i);
    end loop;
    for i in 27 downto 24 loop
        x(i) <= b(i) xor c(i);
    end loop;
    for i in 23 downto 0 loop
        x(i) <= b(i) xor p(i);
    end loop;
end process;

end behavior;
 
