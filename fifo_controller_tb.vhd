LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY fifo_controller_tb IS
  generic (n : integer := 3);
END fifo_controller_tb;

architecture struct_fifo_controller of fifo_controller_tb is
  COMPONENT fifo_controller IS
  generic (n : integer := 2);
  PORT (reset: in std_logic;
        rdclk: in std_logic;
        wrclk: in std_logic;
        r_req: in std_logic;
        w_req: in std_logic;
        
        write_valid: out std_logic;
        read_valid: out std_logic;
        wr_ptr: out std_logic_vector(n downto 0);
        rd_ptr: out std_logic_vector(n downto 0);
        empty: out std_logic;
        full: out std_logic       
       );
  END COMPONENT;
  for dut : fifo_controller USE ENTITY WORK.fifo_controller (fifo_controller_behav);
  
  signal reset, rdclk, wrclk, r_req, w_req, write_valid, read_valid, empty, full : std_logic := '0';
  signal wr_ptr, rd_ptr : std_logic_vector (2 downto 0);
  
begin
  dut : fifo_controller port map (reset, rdclk, wrclk, r_req, w_req, write_valid, read_valid, wr_ptr, rd_ptr, empty, full);
  
  rd_clock_process :process is
    begin
     rdclk <= '0';
     wait for 10 ns;
     rdclk <= '1';
     wait for 10 ns;
    end process;
    
  wr_clock_process : process is
    begin
     wrclk <= '0';
     wait for 10 ns;
     wrclk <= '1';
     wait for 10 ns;
    end process;
    
    test : process is
      begin
        reset <= '1';
        wait for 20 ns;
        
        reset <= '0';
        wait for 20 ns;
        w_req <= '1';
        wait for 20 ns;
        w_req <= '0';
        r_req <= '1';
       
        
       wait;
end process;

end architecture;

        
      
    
  
  