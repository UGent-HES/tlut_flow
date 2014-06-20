--TMAP
library ieee;
use ieee.numeric_std.all;
use IEEE.math_real.CEIL;
use IEEE.math_real.LOG;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity firTree32tap is
generic (
    DATA_WIDTH  : integer := 8 

);
port(
    i   :   in  std_logic_vector(DATA_WIDTH-1 downto 0);
    --PARAM
    c0  :   in  std_logic_vector(7 downto 0);
    c1  :   in  std_logic_vector(7 downto 0);
    c2  :   in  std_logic_vector(7 downto 0);
    c3  :   in  std_logic_vector(7 downto 0);
    c4  :   in  std_logic_vector(7 downto 0);
    c5  :   in  std_logic_vector(7 downto 0);
    c6  :   in  std_logic_vector(7 downto 0);
    c7  :   in  std_logic_vector(7 downto 0);
    c8  :   in  std_logic_vector(7 downto 0);
    c9  :   in  std_logic_vector(7 downto 0);
    c10  :   in  std_logic_vector(7 downto 0);
    c11  :   in  std_logic_vector(7 downto 0);
    c12  :   in  std_logic_vector(7 downto 0);
    c13  :   in  std_logic_vector(7 downto 0);
    c14  :   in  std_logic_vector(7 downto 0);
    c15  :   in  std_logic_vector(7 downto 0);
    c16  :   in  std_logic_vector(7 downto 0);
    c17  :   in  std_logic_vector(7 downto 0);
    c18  :   in  std_logic_vector(7 downto 0);
    c19  :   in  std_logic_vector(7 downto 0);
    c20 :   in  std_logic_vector(7 downto 0);
    c21 :   in  std_logic_vector(7 downto 0);
    c22 :   in  std_logic_vector(7 downto 0);
    c23  :   in  std_logic_vector(7 downto 0);
    c24 :   in  std_logic_vector(7 downto 0);
    c25  :   in  std_logic_vector(7 downto 0);
    c26  :   in  std_logic_vector(7 downto 0);
    c27  :   in  std_logic_vector(7 downto 0);
    c28  :   in  std_logic_vector(7 downto 0);
    c29  :   in  std_logic_vector(7 downto 0);
    c30  :   in  std_logic_vector(7 downto 0);
    c31  :   in  std_logic_vector(7 downto 0);
--PARAM
    o   :   out  std_logic_vector((2*DATA_WIDTH)-1+31 downto 0);
    clk :   in std_logic
);
end firTree32tap;

architecture rtl of firTree32tap is
    constant numLevels      : integer := integer(CEIL(LOG(real(DATA_WIDTH), 2.0)))+1;

    type intermediate_t is array (0 to 32) of std_logic_vector((2*DATA_WIDTH)-1+31 downto 0);
    signal intermediate : intermediate_t := (others => (others => '0'));
    type coef_t is array (0 to 31) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal coef : coef_t;
    type mult_t is array (0 to 31) of std_logic_vector((2*DATA_WIDTH)-1 downto 0);
    signal mult1 : mult_t;

    signal i_buffered : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    
    coef(0) <= c0;
    coef(1) <= c1;
    coef(2) <= c2;
    coef(3) <= c3;
    coef(4) <= c4;
    coef(5) <= c5;
    coef(6) <= c6;
    coef(7) <= c7;
    coef(8) <= c8;
    coef(9) <= c9;
    coef(10) <= c10;
    coef(11) <= c11;
    coef(12) <= c12;
    coef(13) <= c13;
    coef(14) <= c14;
    coef(15) <= c15;
    coef(16) <= c16;
    coef(17) <= c17;
    coef(18) <= c18;
    coef(19) <= c19;
    coef(20) <= c20;
    coef(21) <= c21;
    coef(22) <= c22;
    coef(23) <= c23;
    coef(24) <= c24;
    coef(25) <= c25;
    coef(26) <= c26;
    coef(27) <= c27;
    coef(28) <= c28;
    coef(29) <= c29;
    coef(30) <= c30;
    coef(31) <= c31;
   
    intermediate(0) <= (others => '0');
    
    BUF:process(clk)
    begin
        if clk'event and clk='1' then
            i_buffered <= i;
        end if;
    end process BUF;

    TAPS: for index in 1 to 32 generate

        MULTIPLIER:entity work.mult8bit
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            a => i_buffered,
            b => coef(index-1),
            c => mult1(index-1)
        );

        SUM:process(clk)
        begin
            if clk'event and clk='1' then
                intermediate(index) <= STD_LOGIC_VECTOR(UNSIGNED'(UNSIGNED(intermediate(index-1)) + UNSIGNED(mult1(index-1)))) ;
            end if;
        end process SUM;

    end generate TAPS;

    o <= intermediate(6); -- and ((2*DATA_WIDTH)-1+31 downto 41 => '0', 40 downto 10 => '1', 9 downto 0 => '0');

end rtl;
