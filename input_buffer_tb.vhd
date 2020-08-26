LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity input_buffer_tb is 
generic ( n   : integer := 7);
end entity;

architecture test of input_buffer_tb is
  component input_buffer is
   
  GENERIC ( n   : integer := 7);
  port    (  data_in           :   in std_logic_vector (n downto 0);
            clk,clk_en,rst    :   in std_logic;
          data_out :            out std_logic_vector (n downto 0)
        );   
end component;
for dut :input_buffer USE ENTITY WORK.input_buffer (reg);

signal data_in,data_out : std_logic_vector(n downto 0) := "00000000";
signal clk,rst   : std_logic;
signal clk_en : std_logic := '0';

BEGIN
	dut: input_buffer port map(data_in,clk,clk_en,rst,data_out);
	  
 clock: PROCESS IS   
  BEGIN     
   clk <= '0','1' AFTER 10 ns;     
    WAIT FOR 20 ns;   
   END PROCESS clock;
   
  test: PROCESS IS
    begin
      rst <= '1';
      wait for 10 ns;
      assert data_out = "00000000"
      REPORT "Reset error"
		  SEVERITY warning;
		  wait for 10 ns;
		  
		  rst <= '0';
		  clk_en <= '1';
		  data_in <= "11010011";
		  wait for 11 ns;
		  assert data_out = "11010011"
      REPORT "Input error"
		  SEVERITY warning;
		  wait for 10 ns;
		  
		  rst <= '0';
		  clk_en <= '0';
		  data_in <= "10000001";
		  wait for 10 ns;
		  assert data_out = "11010011"
      REPORT "Hold error"
		  SEVERITY warning;
		  wait for 10 ns;
		  rst <= '1';
      wait for 10 ns;
      assert data_out = "00000000"
      REPORT "Reset error"
		  SEVERITY warning;
		  
		  
		  wait;
		  
		 end process;
		 
 end architecture;
		  
		  
		  
		  
		  
		  
