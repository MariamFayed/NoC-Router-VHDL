LIBRARY IEEE;
USE IEEE.std_lOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY router_tb4 IS
  generic (n : integer := 7);
END router_tb4;

ARCHITECTURE behavior_router OF router_tb4 IS 

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
    
    datai2 <= "10110000";
   
    datai3 <= "10000100";
                
    datai4 <= "10001100";

    wait for 20 ns;
    
    datai1 <= "11000001";
    
    datai2 <= "00000001";
     
    datai3 <= "00000101";
               
    datai4 <= "00001101";
    
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
    
    datai1 <= "11000010";
    
    datai2 <= "00000010";
     
    datai3 <= "00000110";
               
    datai4 <= "00001110";
    
   wait for 25 ns;
   assert datao1 <= "10110000"
   REPORT "Data out Port 1"
   SEVERITY warning;
   
    --wait for 15 ns;
    wr1 <= '0';
    wr2 <= '0'; 
    wr3 <= '0'; 
    wr4 <= '0';
         
    wait for 15 ns;
    
    
  
    wr1 <= '1';
    wr2 <= '1'; 
    wr3 <= '1'; 
    wr4 <= '1';
    
    datai1 <= "10100011";
      
    datai2 <= "10110011";
        
    datai3 <= "10000111";
              
    datai4 <= "11001111";
    
    
    wait for 5 ns;
    assert datao1 <= "10000100"
   REPORT "Data out Port 1"
   SEVERITY warning;
   
    assert datao2 <= "00000101"
   REPORT "Data out Port 2"
   SEVERITY warning;
   
   
    wait for 5 ns;
   
   assert datao1 <= "10100000"
   REPORT "Data out Port 1"
   SEVERITY warning;
   
   assert datao2 <= "11000001"
   REPORT "Data out Port 2"
   SEVERITY warning;
    
    wait for 15 ns;

    wr1 <= '0';
    wr2 <= '0'; 
    wr3 <= '0'; 
    wr4 <= '0';
   
     wait for 25 ns;

     
    assert datao1 <= "10100000"
   REPORT "Data out Port 1"
   SEVERITY warning;
   
   assert datao2 <= "11000001"
   REPORT "Data out Port 2"
   SEVERITY warning;
   
   assert datao3 <= "11000010"
   REPORT "Data out Port 3"
   SEVERITY warning;
   
    wait for 20 ns;
       
    assert datao2 <= "00000001"
   REPORT "Data out Port 2"
   SEVERITY warning;
   
   assert datao3 <= "00000010"
   REPORT "Data out Port 3"
   SEVERITY warning;
   

   wait for 15 ns;
   
   assert datao3 <= "00000110"
   REPORT "Data out Port 3"
   SEVERITY warning;
   
  assert datao4 <= "10000111"
   REPORT "Data out Port 4"
   SEVERITY warning;
    wait for 20 ns;

   assert datao3 <= "00001110"
   REPORT "Data out Port 3"
   SEVERITY warning;
   
    assert datao4 <= "11001111"
   REPORT "Data out Port 4"
   SEVERITY warning;
   
    wait for 20 ns;

   
   assert datao4 <= "10100011"
   REPORT "Data out Port 4"
   SEVERITY warning;
   
   wait for 20 ns;

   assert datao4 <= "10110011"
   REPORT "Data out Port 4"
   SEVERITY warning;
   wait for 20 ns;

   

  wait;
    
    
    end process;
    
end architecture;