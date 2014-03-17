library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity round0 is
port (

            key             :   in      std_logic_vector(127 downto 0);

            input           :   in std_logic_vector(127 downto 0);
            output          :   out std_logic_vector(127 downto 0);
            clk             :   in std_logic
);
end round0;

architecture Behavioral of round0 is
    signal      addroundkey     :   std_logic_vector(127 downto 0);
    signal      reg             :   std_logic_vector(127 downto 0);

begin
    addroundkey0 : entity work.addRoundKey
        port map (
            input  => input,
           
            key    => key,
          
            output => addroundkey
        );

    process(clk)
    begin
        if clk'event and clk = '1' then
            reg <= addroundkey;
        end if;
    end process;

    output <=   reg;

end Behavioral;