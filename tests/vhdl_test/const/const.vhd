library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity const is
    port(
--PARAM
    p : in  std_logic_vector(31 downto 0);
--PARAM
    b : in  std_logic_vector(31 downto 0);
    x : out std_logic_vector(31 downto 0);
    dummy_out : out std_logic
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
    dummy_out <= b(0) xor b(1);
end process;

end behavior;
 
