
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity grayToBin is 
  generic (n : integer      := 3);
  port (  gray_in           :   in std_logic_vector (n downto 0);
          bin_out           :   out std_logic_vector(n downto 0)
       );   
end entity;
architecture behav of grayToBin is
begin
		counter: process (gray_in) is 
		variable temp : std_logic_vector (n downto 0); --Containing binary bits converted
		begin
		 
		 temp(n) := gray_in(n);     --Setting the the MSB in the grey code to the MSB in binary code
		
	FOR j IN (n-1) DOWNTO 0 LOOP  --XORing of the previous temp and the current gray bit 
	temp(j) := temp (j+1) XOR gray_in (j);
	END LOOP;
	bin_out <= temp;
	end process;
	

end behav;
  

