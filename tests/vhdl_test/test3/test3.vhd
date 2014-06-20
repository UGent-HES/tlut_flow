library ieee;
use ieee.std_logic_1164.all;

-- Test parameters used as outputs of the circuit
entity test3 is
port    (
--PARAM
        in_param    : in std_logic_vector(1 downto 0);          
--PARAM
        in_dummy1, in_dummy2 : in std_logic;
        out_dummy   : out std_logic;
        out_dummy2  : out std_logic;
        out_param   : out std_logic_vector(1 downto 0)
        );
end test3;

architecture rtl of test3 is
begin
    out_dummy <= in_dummy1 or in_dummy2;
    out_dummy2 <= '0';
    out_param(0) <= in_param(0);
    out_param(1) <= not(in_param(1));
end rtl;
