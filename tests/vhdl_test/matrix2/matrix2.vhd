library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.matrix_type_pkg.all;

entity matrix2 is
    port(
    a : in  matrix_type;
    b : in  matrix_type;
    x : out matrix_type
);
end matrix2;

architecture rtl of matrix2 is
begin


process(a,b)
begin
    for i in 0 to 7 loop
        for j in 0 to 7 loop
            x(i,j) <= a(i,j) xor b(i,j);
        end loop;
    end loop;
end process;

end rtl;
