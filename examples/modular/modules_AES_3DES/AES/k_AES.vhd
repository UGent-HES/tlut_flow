--TMAP
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity k_AES is
port (
--PARAM
            key_in            :   in      std_logic_vector(127 downto 0);
--PARAM

            input           :   in std_logic_vector(127 downto 0);
            output          :   out std_logic_vector(127 downto 0);
            clk             :   in std_logic

);
end k_AES;

architecture Behavioral of k_AES is
    type        roundarray is array (0 to 10) of std_logic_vector(127 downto 0);
    signal      roundOut        :   roundarray;
    signal      key             :   roundarray;

begin
	
    key(0) <= key_in;
   
    KROUNDS:for i in 1 to 10 generate 
      	KR:entity work.kround(Behavioral)
		port map (
			key => key(i-1),
			roundkey => key(i),
			roundnr => CONV_STD_LOGIC_VECTOR(i,4)
			);
    end generate;

    R : entity work.round0
        port map (            
            key => key(0),            
            input => input,
            output => roundOut(0),
            clk => clk
        );

    ROUNDS:for round in 1 to 10 generate

        R : entity work.round
            port map (                
                key => key(round),                
                input => roundOut(round-1),
                output => roundOut(round),
                clk => clk
            );

    end generate ROUNDS;
-- 
    output <= roundOut(10);

end Behavioral;




