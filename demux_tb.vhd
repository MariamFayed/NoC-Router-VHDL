LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_tb is 
generic ( n   : integer := 7);
end entity;

architecture test1 of demux_tb is
  component demux is
   
  GENERIC ( n   : integer := 7);
   port ( data_in                     :  in std_logic_vector (n downto 0);
          d_out1,d_out2,d_out3,d_out4  :   out std_logic_vector(n downto 0);
          sel                          :   in std_logic_vector (1 downto 0);
          en                           :   in std_logic);    
end component;
for dut :demux USE ENTITY WORK.demux (behav_demux);

signal data_in,d_out1,d_out2,d_out3,d_out4 : std_logic_vector(n downto 0) := "00000000";
signal en                                 : std_logic;
signal sel                                 : std_logic_vector(1 downto 0) := "00";

BEGIN
	dut: demux port map(data_in,d_out1,d_out2,d_out3,d_out4,sel,en);
	  
 test: PROCESS IS
   
  BEGIN
    
     en <= '1';
     sel <= "00";
     data_in <= "00000001";
     wait for 10 ns;
      assert d_out1 = "00000001"
      REPORT "Data 1 error"
		  SEVERITY warning;
		  
		  wait for 10 ns;
		 
		 sel <= "01";
     data_in <= "00000010";
     wait for 10 ns;
      assert d_out2 = "00000010"
      REPORT "Data 2 error"
		  SEVERITY warning;
		 
		  wait for 10 ns;
		 
		 sel <= "10";
     data_in <= "00000100";
     wait for 10 ns;
     assert d_out3 = "00000100"
     REPORT "Data 3 error"
		 SEVERITY warning;
		  
		 wait for 10 ns;
		  
	  sel <= "11";
    data_in <= "00001000";
    wait for 10 ns;
    assert d_out4 = "00001000"
    REPORT "Data 4 error"
		SEVERITY warning;
		 
		 wait for 10 ns; 
		  
		 en <= '0'; 
		 sel <= "00";
		 data_in <= "10000001";
		 wait for 10 ns;
     assert d_out1 = "00000001"
     REPORT "Enable error"
		 SEVERITY warning;
     
     WAIT ;
   
   END PROCESS test;
  
end architecture;  