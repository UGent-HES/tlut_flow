--TMAP
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity treeMult4b is
generic (
    DATA_WIDTH      : integer := 4
);
port(
    a   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
--PARAM
    b  :   in  std_logic_vector(7 downto 0);
--PARAM
    o   :   out  std_logic_vector(3*DATA_WIDTH-1 downto 0)
	 );
end treeMult4b;

architecture rtl of treeMult4b is
    constant numLevels      : integer := integer(CEIL(LOG(real(DATA_WIDTH), 2.0)))+1;

    type intermediateLevel_t is array (0 to DATA_WIDTH-1) of std_logic_vector(3*DATA_WIDTH-1 downto 0);
    type intermediate_t is array (0 to numLevels-1) of intermediateLevel_t;
    signal intermediate : intermediate_t;

begin


    
    ANDGATES: for i in 0 to DATA_WIDTH-1 generate

        process (a(i),b)
        variable result : std_logic_vector(3*DATA_WIDTH-1 downto 0);
        begin
            result := (others => '0');
            for j in 0 to 2*DATA_WIDTH-1 loop
                result(j+i) := b(j) and a(i);
            end loop;
            intermediate(0)(i) <= result;
        end process;

    end generate ANDGATES;

    ADDERLEVEL: for level in 1 to numLevels-1  generate

        ADDER: for add in 0 to (2**(numLevels-1-level))-1 generate

            intermediate(level)(add) <= std_logic_vector(unsigned(intermediate(level-1)(2*add)) + unsigned(intermediate(level-1)(2*add+1)));

        end generate ADDER;

    end generate ADDERLEVEL;

    o <= intermediate(numLevels-1)(0);
	 
end rtl;
