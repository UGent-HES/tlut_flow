library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mixColumn is
port (
	input					:	in std_logic_vector(31 downto 0);
	output				:	out std_logic_vector(31 downto 0)
);
end mixColumn;

architecture Behavioral of mixColumn is
   signal s0 : std_logic_vector(7 downto 0); 
   signal s1 : std_logic_vector(7 downto 0);
   signal s2 : std_logic_vector(7 downto 0);
   signal s3 : std_logic_vector(7 downto 0);     
 
   signal s0_timesx : std_logic_vector(7 downto 0); 
   signal s1_timesx : std_logic_vector(7 downto 0);
   signal s2_timesx : std_logic_vector(7 downto 0);
   signal s3_timesx : std_logic_vector(7 downto 0);     
begin
   s0 <= input(7 downto 0);
   s1 <= input(15 downto 8);
   s2 <= input(23 downto 16);
   s3 <= input(31 downto 24);         
   
   process (s0)
   begin
       if s0(7)='1' then 
          s0_timesx <= (s0(6 downto 0) & '0') xor CONV_STD_LOGIC_VECTOR(16#1B#,8);
       else 
          s0_timesx <= s0(6 downto 0) & '0';
       end if; 
   end process;    

   process (s1)
   begin
       if s1(7)='1' then 
          s1_timesx <= (s1(6 downto 0) & '0') xor CONV_STD_LOGIC_VECTOR(16#1B#,8);
       else 
          s1_timesx <= s1(6 downto 0) & '0';
       end if; 
   end process;    

   process (s2)
   begin
       if s2(7)='1' then 
          s2_timesx <= (s2(6 downto 0) & '0') xor CONV_STD_LOGIC_VECTOR(16#1B#,8);
       else 
          s2_timesx <= s2(6 downto 0) & '0';
       end if; 
   end process;    

   process (s3)
   begin
       if s3(7)='1' then 
          s3_timesx <= (s3(6 downto 0) & '0') xor CONV_STD_LOGIC_VECTOR(16#1B#,8);
       else 
          s3_timesx <= s3(6 downto 0) & '0';
       end if; 
   end process;    
   
output(7 downto 0)   <= s0_timesx xor s1_timesx xor s1 xor s2 xor s3 ;
output(15 downto 8)  <= s1_timesx xor s2_timesx xor s2 xor s3 xor s0 ;
output(23 downto 16) <= s2_timesx xor s3_timesx xor s3 xor s0 xor s1 ;
output(31 downto 24) <= s3_timesx xor s0_timesx xor s0 xor s1 xor s2 ;   
   
end Behavioral;





