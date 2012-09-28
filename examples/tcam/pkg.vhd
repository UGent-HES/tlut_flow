

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg is
 constant DATA_WIDTH : integer := 8;
 constant ADDR_WIDTH : integer := 4;

 type entry is record
  used : std_logic;
  data : std_logic_vector(DATA_WIDTH-1 downto 0);
  mask : std_logic_vector(DATA_WIDTH-1 downto 0);
 end record;

 type entries is array (2**ADDR_WIDTH-1 downto 0) of entry;

 function compare (data: std_logic_vector(DATA_WIDTH-1 downto 0); entry0 : entry) return std_logic;
 function matchExists(data : std_logic_vector(DATA_WIDTH-1 downto 0); content: entries) return std_logic;
 function findMatch(data : std_logic_vector(DATA_WIDTH-1 downto 0); content: entries) return std_logic_vector;

end package pkg;

package body pkg is

 function compare (data: std_logic_vector(DATA_WIDTH-1 downto 0); entry0 : entry) return std_logic is
 variable result : std_logic;
 begin
  result := entry0.used;
  for i in 0 to DATA_WIDTH-1 loop
   result := result and ((entry0.data(i) xnor data(i)) or entry0.mask(i));
  end loop;
  return result;
 end function compare;

 function matchExists(data : std_logic_vector(DATA_WIDTH-1 downto 0); content: entries) return std_logic is
  variable match : std_logic;
 begin
  match := '0';
  for i in 2**ADDR_WIDTH-1 downto 0 loop
   if (compare(data, content(i)) = '1') then
    match := '1';
   end if;
  end loop;
  return match;
 end function matchExists;

 function findMatch(data : std_logic_vector(DATA_WIDTH-1 downto 0); content: entries) return std_logic_vector is
  variable addr : std_logic_vector(ADDR_WIDTH-1 downto 0);
 begin
  addr := (others => '0');
  for i in 2**ADDR_WIDTH-1 downto 0 loop
   if (compare(data, content(i)) = '1') then
    addr := std_logic_vector(to_unsigned(i, ADDR_WIDTH));
   end if;
  end loop;
  return addr;
 end function findMatch;


end package body pkg;
