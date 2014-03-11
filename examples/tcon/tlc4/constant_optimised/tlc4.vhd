--TMAP
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.all;

entity tlc4 is
	generic(N : natural := 16);
	port(
		input1               : in std_logic_vector(N - 1 downto 0);
		input2               : in std_logic_vector(N - 1 downto 0);
		--PARAM
		--p                   : in  std_logic_vector(1 downto 0);
		--PARAM
		output              : out std_logic_vector(N - 1 downto 0)
	);

end tlc4;

architecture RTL of tlc4 is
	signal t1,t2,ti1,ti2 : integer;
	signal mask1,mask2 : std_logic_vector(N-1 downto 0);
	
	signal p           : std_logic_vector(1 downto 0) := "$p$";
	
begin
    process(p) begin
       case p is
          when "00" => mask1 <= x"3516";
                       mask2 <= x"69a6";
          when "01" => mask1 <= x"6543";
                       mask2 <= x"35b2";
          when "10" => mask1 <= x"8635";
                       mask2 <= x"a95a";
          when "11" => mask1 <= x"4156";
                       mask2 <= x"9658";
          --when others => t2 <= 'Z';
       end case;
    end process;
    ti1 <= to_integer(unsigned(input1 and mask1));
    ti2 <= to_integer(unsigned(input2 and mask2));
    t2 <= ti1 + ti2;
 
    output <= std_logic_vector(to_unsigned(t2,output'length));--input xor p;

end architecture RTL;
