--TMAP
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modules is
port(
--PARAM
    p       :   in std_ulogic;
--PARAM
    key     :   in std_logic_vector(191 downto 0);
    input   :   in std_logic_vector(127 downto 0);
    lddata  :	in std_logic;	-- active when data for loading is ready
    ldkey   :	in std_logic;	-- active when key for loading is ready
    out_ready:	out	std_logic;	-- active when encryption of data is done	
    output  :   out std_logic_vector(127 downto 0);
    clk     :   in std_logic;
    reset   :   in std_logic
	 );
end modules;

architecture behavior of modules is
    signal output_tdes : std_logic_vector(0 to 63);
    signal output_AES  : std_logic_vector(127 downto 0);
begin

    TDES:entity work.tdes_top
    port map (
		key1_in  => key(63 downto 0),
		key2_in  => key(127 downto 64),
		key3_in  => key(191 downto 128),
		function_select => '1', -- active when encryption, inactive when decryption
		lddata   => lddata,
		ldkey    => ldkey,
		out_ready => out_ready,
		data_in  => input(63 downto 0),
		data_out => output_tdes,

		reset    => reset,
		clock    => clk
	);


    AES:entity work.k_AES
    port map (
        key_in => key(127 downto 0),
        input  => input,
        output => output_AES,
        clk    => clk
    );
    
    output <= (X"0000000000000000" & output_tdes) when p='1' else output_AES;

end behavior;
