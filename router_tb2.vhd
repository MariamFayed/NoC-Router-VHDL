
LIBRARY IEEE;
USE IEEE.std_lOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY router_tb2 IS
  generic (n : integer := 7);
END router_tb2;

ARCHITECTURE behavior_router OF router_tb2 IS 

COMPONENT ROUTER IS
  generic (n : integer := 7);
  PORT (rst: in std_logic;
        rclock: in std_logic;
        wclock: in std_logic;
        wr1,wr2,wr3,wr4: in std_logic;
        datai1,datai2,datai3,datai4: in std_logic_vector (n downto 0);
        datao1,datao2,datao3,datao4: out std_logic_vector (n downto 0)
       );
END COMPONENT ROUTER;
  

FOR dut: ROUTER USE ENTITY WORK. ROUTER(Router_Struct);

   signal rst : std_logic := '0';
   signal rclock : std_logic := '0';
   signal wclock : std_logic := '0';
   signal wr1,wr2,wr3,wr4: std_logic;
   signal datai1,datai2,datai3,datai4: std_logic_vector (n downto 0);
   signal datao1,datao2,datao3,datao4: std_logic_vector (n downto 0);

BEGIN
  
  dut: ROUTER PORT MAP (rst,rclock,wclock,wr1,wr2,wr3,wr4,datai1,datai2,datai3,datai4,datao1,datao2,datao3,datao4);
  
    rd_clock_process :process is
    begin
     rclock <= '0';
     wait for 10 ns;
     rclock <= '1';
     wait for 10 ns;
    end process;
    
  wr_clock_process : process is
    begin
     wclock <= '0';
     wait for 10 ns;
     wclock <= '1';
     wait for 10 ns;
    end process;
       
  test:  process is
  BEGIN
    rst <= '1';
    
    wait for 10 ns;
    
    rst <= '0';
    wr1 <= '1';
    wr2 <= '1'; 
    wr3 <= '1'; 
    wr4 <= '1';
    
    datai1 <= "10100000"; 
    datai2 <= "10110001";
    datai3 <= "10000110";            
    datai4 <= "10001111";

    wait for 20 ns;
    wr1 <= '0';
    wr2 <= '0'; 
    wr3 <= '0'; 
    wr4 <= '0';
    
    wait for 20 ns;
    wr1 <= '1';
    wr2 <= '1'; 
    wr3 <= '1'; 
    wr4 <= '1';
    
    datai1 <= "11000001";
    
    datai2 <= "00000001";
     
    datai3 <= "00000101";
               
    datai4 <= "00001101";
    
    
    wait for 20 ns;
    wr1 <= '0';
    wr2 <= '0'; 
    wr3 <= '0'; 
    wr4 <= '0';
    
   wait for 25 ns;
   assert datao2 = "10110001"
   REPORT "Data out 2 error"
	 SEVERITY warning;
	 
	  wait for 20 ns;
   assert datao3 = "10000110"
   REPORT "Data out 3 error"
	 SEVERITY warning;
	 
	 wait for 20 ns;
   assert datao2 = "00001101"
   REPORT "Data out 2 error"
	 SEVERITY warning;
	 
	 assert datao4 = "10001111"
   REPORT "Data out 4 error"
	 SEVERITY warning;
	 
	 wait for 20 ns;
   assert datao1 = "10100000"
   REPORT "Data out 1 error"
	 SEVERITY warning;
	 
	 assert datao2 = "11000001"
   REPORT "Data out 2 error"
	 SEVERITY warning;
	 
   wait for 20 ns;
   assert datao2 = "00000001"
   REPORT "Data out 2 error"
	 SEVERITY warning;
	 
	 
	 wait for 20 ns;
   assert datao2 = "00000101"
   REPORT "Data out 2 error"
	 SEVERITY warning;
    wait;
    
    
    end process;
    
  END ARCHITECTURE;