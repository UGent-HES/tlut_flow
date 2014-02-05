library ieee;
use ieee.std_logic_1164.all;

package matrix_type_pkg is
  type matrix_type is array (natural range 7 downto 0) of std_logic_vector(7 downto 0);
end package;
