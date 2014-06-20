library ieee;
use ieee.std_logic_1164.all;

package matrix_type_pkg is
  type matrix_type is array (8 downto 0, 7 downto 0) of std_ulogic;
end package;
