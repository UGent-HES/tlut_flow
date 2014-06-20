library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.matrix_type_pkg.all;

entity matrix is
    port(
    a : in  matrix_type;
    b : in  matrix_type;
    x : out matrix_type
);
end matrix;

architecture rtl of matrix is
begin


process(a,b)
begin
    for i in x'range loop
        x(i) <= a(i) xor b(i);
    end loop;
end process;

end rtl;
