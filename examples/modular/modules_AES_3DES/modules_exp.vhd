--TMAP
library ieee, std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modules_exp is
port(
--PARAM
    p       :   in std_ulogic;
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
    key     :   in std_logic_vector(191 downto 0);
--PARAM
    input   :   in std_logic_vector(127 downto 0);
    lddata  :	in std_logic;	-- active when data for loading is ready
    ldkey   :	in std_logic;	-- active when key for loading is ready
    out_ready:	out	std_logic;	-- active when encryption of data is done	
    output  :   out std_logic_vector(127 downto 0);
    clk     :   in std_logic;
    reset   :   in std_logic
	 );
end modules_exp;

architecture behavior of modules_exp is
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


    AES:entity work.AES
    port map (
        key0 => key0,
        key1 => key1,
        key2 => key2,
        key3 => key3,
        key4 => key4,
        key5 => key5,
        key6 => key6,
        key7 => key7,
        key8 => key8,
        key9 => key9,
        key10 => key10,
        input  => input,
        output => output_AES,
        clk    => clk
    );
    
    output <= (X"0000000000000000" & output_tdes) when p='1' else output_AES;

end behavior;
