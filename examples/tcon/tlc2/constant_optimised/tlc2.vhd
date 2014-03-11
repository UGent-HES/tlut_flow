--TMAP
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.all;

entity tlc2 is
	generic(N : natural := 8);
	port(
		input               : in std_logic_vector(N - 1 downto 0);
		--PARAM
		--p                   : in  std_logic_vector(2 downto 0);
		--PARAM
		output              : out std_logic_vector(N*2-1 downto 0)
	);

end tlc2;

architecture RTL of tlc2 is
	signal o1 : std_logic_vector(N*2-1 downto 0);
	signal o2 : std_logic_vector(N*2-1 downto 0);
	signal t1,ti : integer;
	signal t2 : integer;
	
	signal p : std_logic_vector(2 downto 0) := "$p$";
	
begin
    ti <= to_integer(unsigned(input));
    --t2 <= ti + 11*t1;
    process(ti,p) begin
       case p is
          when "000" => t2 <= 3*ti;
          when "001" => t2 <= 5*ti;
          when "010" => t2 <= 6*ti;
          when "011" => t2 <= 2*ti;
          when "100" => t2 <= 6*ti+3;
          when "101" => t2 <= 3*ti;
          when "110" => t2 <= 6*ti+2;
          when "111" => t2 <= 6*ti+9;
          --when others => t2 <= 'Z';
       end case;
    end process;
 
    output <= std_logic_vector(to_unsigned(t2,output'length));

end architecture RTL;
