library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity round is
port (

            key             :   in      std_logic_vector(127 downto 0);

            input           :   in std_logic_vector(127 downto 0);
            output          :   out std_logic_vector(127 downto 0);
            clk             :   in std_logic
);
end round;

architecture Behavioral of round is
    signal      addroundkey     :   std_logic_vector(127 downto 0);
    signal      subbytes        :   std_logic_vector(127 downto 0);
    signal      shiftrows       :   std_logic_vector(127 downto 0);
    signal      mixcolumns      :   std_logic_vector(127 downto 0);
    signal      reg             :   std_logic_vector(127 downto 0);

begin


        SB : entity work.subBytes
            port map (
                input  => input,
                output => subbytes
             );

        SR : entity work.shiftRows
            port map (
                input  => subbytes,
                output => shiftrows
            );

        MC : entity work.mixColumns
            port map (
                input  => shiftrows,
                output => mixcolumns
            );

        AR : entity work.addRoundKey
            port map ( 
                input  => mixcolumns,

                key    => key,

                output => addroundkey
            );

        process(clk)
        begin
            if clk'event and clk = '1' then
                reg <= addroundkey;
            end if;
        end process;

        output <= reg;


end Behavioral;