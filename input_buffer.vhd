LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity input_buffer is 
  GENERIC ( n   : integer := 7);
  port (  data_in           :   in std_logic_vector (n downto 0);
          clk,clk_en,rst    :   in std_logic;
          data_out          :   out std_logic_vector (n downto 0)
        );   
end entity;

architecture reg of input_buffer is
  signal temp: STD_LOGIC_VECTOR (n downto 0);
  begin
    process(clk,rst,clk_en)
      begin
        if rst = '1' then
          temp <= "00000000";
          
        elsif clk'event AND clk = '1' AND clk_en = '1' then
          temp <= data_in;
        end if;
      end process;
      data_out <= temp;
    end; 
          
        
      
          
