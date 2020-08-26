LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity demux is 
  GENERIC ( n   : integer := 7);
  port (  data_in                      :   in std_logic_vector (n downto 0);
          d_out1,d_out2,d_out3,d_out4  :   out std_logic_vector(n downto 0);
          sel                          :   in std_logic_vector (1 downto 0);
          en                           :   in std_logic);    
end entity;

architecture behav_demux of demux is
begin
  p2 : PROCESS ( en , sel ,data_in) 
  
  BEGIN 
 
    if en = '1' then
      if (sel  <= "00") then
        d_out1 <= data_in ;
        
      elsif (sel <= "01") then
        d_out2 <= data_in ;
        
      elsif (sel <= "10") then
        d_out3 <= data_in ; 
      else
        d_out4 <= data_in ;  
      
      end if;  
    end if; 
  end process;
end architecture;

   

