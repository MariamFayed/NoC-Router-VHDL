library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
        
entity BCounter is 
generic ( n   : integer := 3);
port(Clock, Reset, En : in  std_logic;
     D_out : out std_logic_vector(n downto 0));
 
end entity;
        
architecture archi of BCounter is  
        
signal tmp: std_logic_vector(n downto 0);
        
begin
        
process (Clock, Reset) 
        
begin   
        
if (Reset = '1') then   
        
tmp <= "0000";  
        
elsif (Clock'event and Clock='1' and En = '1') then 
        
	tmp <= tmp + 1;

 end if;     
        
 end process; 
        
 D_out <= tmp;
        
 end archi;
