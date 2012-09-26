

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg2 is
 constant DATA_W : integer := _DATA_W;
 constant ADDR_W : integer := _ADDR_W;

 type entry is record
  used : std_logic;
  data : std_logic_vector(DATA_W-1 downto 0);
  mask : std_logic_vector(DATA_W-1 downto 0);
 end record;

 type entry_array is array (0 to 2**ADDR_W-1) of entry;

end package pkg2;

package body pkg2 is
end package body pkg2;
