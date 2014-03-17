--TMAP
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AES is
port (
--/PARAM
            key0            :   in      std_logic_vector(127 downto 0);
            key1            :   in      std_logic_vector(127 downto 0);
            key2            :   in      std_logic_vector(127 downto 0);
            key3            :   in      std_logic_vector(127 downto 0);
            key4            :   in      std_logic_vector(127 downto 0);
            key5            :   in      std_logic_vector(127 downto 0);
            key6            :   in      std_logic_vector(127 downto 0);
            key7            :   in      std_logic_vector(127 downto 0);
            key8            :   in      std_logic_vector(127 downto 0);
            key9            :   in      std_logic_vector(127 downto 0);
            key10           :   in      std_logic_vector(127 downto 0);
--/PARAM


            input           :   in std_logic_vector(127 downto 0);
            output          :   out std_logic_vector(127 downto 0);
            clk             :   in std_logic

);
end AES;

architecture Behavioral of AES is
    type        roundarray is array (0 to 10) of std_logic_vector(127 downto 0);
    signal      roundOut       :   roundarray;
    signal      key            :   roundarray;

begin

    key(0) <= key0;
    key(1) <= key1;
    key(2) <= key2;
    key(3) <= key3;
    key(4) <= key4;
    key(5) <= key5;
    key(6) <= key6;
    key(7) <= key7;
    key(8) <= key8;
    key(9) <= key9;
    key(10) <= key10;

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




