library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
        
entity FD is
generic (
    INIT : bit:= '1');
port (
    Q : out STD_ULOGIC;
	C : in STD_ULOGIC;
	D : in STD_ULOGIC);
end FD;

architecture rtl of FD is
    signal REG : STD_ULOGIC := to_stdulogic(INIT);
begin

    process(C)
    begin
        if rising_edge(C) then
            Q <= D;
        end if;
    end process;
    
end;