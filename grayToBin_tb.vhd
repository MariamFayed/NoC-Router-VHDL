LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity grayToBin_tb is 
generic ( n   : integer := 3);
end entity;

architecture test2 of grayToBin_tb is
  component grayToBin is
   
   GENERIC ( n   : integer := 3);
    port   ( gray_in           :   in std_logic_vector (n downto 0);
            bin_out            :   out std_logic_vector (n downto 0)
          );   
end component;
for dut : grayToBin USE ENTITY WORK.grayToBin (behav);

signal gray_in, bin_out : std_logic_vector(n downto 0):= "0000" ;
begin 
  dut: grayToBin port map(gray_in,bin_out);
    
    gtb : PROCESS IS
    begin
      gray_in <= "0000";
      wait for 10 ns;
      assert bin_out = "0000"
      REPORT "0 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0001";
      wait for 10 ns;
      assert bin_out = "0001"
      REPORT "1 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0011";
      wait for 10 ns;
      assert bin_out = "0010"
      REPORT "2 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0010";
      wait for 10 ns;
      assert bin_out = "0011"
      REPORT "3 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0110";
      wait for 10 ns;
      assert bin_out = "0100"
      REPORT "4 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0111";
      wait for 10 ns;
      assert bin_out = "0101"
      REPORT "5 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0101";
      wait for 10 ns;
      assert bin_out = "0110"
      REPORT "6 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "0100";
      wait for 10 ns;
      assert bin_out = "0111"
      REPORT "7 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		  
		  gray_in <= "1100";
      wait for 10 ns;
      assert bin_out = "1000"
      REPORT "8 Convert Error"
		  SEVERITY warning;
		  
		  wait for 10 ns;

      gray_in <= "1101";
      wait for 10 ns;
      assert bin_out = "1001"
      REPORT "9 Convert Error"
      SEVERITY warning;

	    wait for 10 ns;

      gray_in <= "1111";
      wait for 10 ns;
      assert bin_out = "1010"
      REPORT "10 Convert Error"
      SEVERITY warning;

	    wait for 10 ns;

      gray_in <= "1110";
      wait for 10 ns;
      assert bin_out = "1011"
      REPORT "11 Convert Error"
      SEVERITY warning;

	    wait for 10 ns;

      gray_in <= "1010";
      wait for 10 ns;
      assert bin_out = "1100"
      REPORT "12 Convert Error"
      SEVERITY warning;
		  
	    wait for 10 ns;

      gray_in <= "1011";
      wait for 10 ns;
      assert bin_out = "1101"
      REPORT "13 Convert Error"
      SEVERITY warning;

	    wait for 10 ns;

      gray_in <= "1001";
      wait for 10 ns;
      assert bin_out = "1110"
      REPORT "14 Convert Error"
      SEVERITY warning;

	    wait for 10 ns;

      gray_in <= "1000";
      wait for 10 ns;
      assert bin_out = "1111"
      REPORT "15 Convert Error"
      SEVERITY warning;
		  
		  wait;
  end process;
end architecture;
		  