library ieee;
use ieee.std_logic_1164.all;

-- Test all possible sizes of TLUTs
entity test4 is
port    (
--PARAM
        in_param    : in std_logic;          
--PARAM
        in_sig      : in std_logic_vector(5 downto 0);
        out_sig     : out std_logic_vector(6 downto 1)
        );
end test4;

architecture rtl of test4 is
begin
    out_sig(6) <= in_sig(0) 
                    and in_sig(1)
                    and in_sig(2)
                    and in_sig(3)
                    and in_sig(4)
                    and in_sig(5)
                    and in_param;
    out_sig(5) <= in_sig(0) 
                    and in_sig(1)
                    and in_sig(2)
                    and in_sig(3)
                    and in_sig(4)
                    and in_param;
    out_sig(4) <= in_sig(0) 
                    and in_sig(1)
                    and in_sig(2)
                    and in_sig(3)
                    and in_param;
    out_sig(3) <= in_sig(0) 
                    and in_sig(1)
                    and in_sig(2)
                    and in_param;
    out_sig(2) <= in_sig(0) 
                    and in_sig(1)
                    and in_param;
    out_sig(1) <= in_sig(0) 
                    and in_param;
end rtl;
