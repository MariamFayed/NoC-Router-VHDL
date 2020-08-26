LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY fifo IS
  generic (n : integer := 7);
  PORT (reset: in std_logic;
        rclk: in std_logic;
        wclk: in std_logic;
        r_req: in std_logic;
        w_req: in std_logic;
        
        datain : in std_logic_vector(n downto 0);
        dataout: out std_logic_vector(n downto 0);
        empty: out std_logic;
        full: out std_logic );
END;

ARCHITECTURE fifo_struct of fifo is

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
  END COMPONENT fifo_controller;
  
  FOR fifo_control1: fifo_controller USE ENTITY WORK.fifo_controller (fifo_controller_behav);
  
  COMPONENT memory IS
   GENERIC ( ADDRESS_WIDTH : integer := 3; 
             DATA_WIDTH : integer    := 8 ); 
   PORT(
        D_in : IN std_logic_vector (DATA_WIDTH-1 downto 0);           
        ADDRA : IN std_logic_vector(ADDRESS_WIDTH-1 downto 0);           
        ADDRB : IN std_logic_vector(ADDRESS_WIDTH-1 downto 0); 
        WEA : IN std_logic;       
        REA : IN std_logic;                                                                                       
        CLKA: IN std_logic;                                           
        CLKB: IN std_logic;                             
        D_out : OUT std_logic_vector (DATA_WIDTH-1 downto 0));
  END COMPONENT memory;
  
  FOR memory1: memory USE ENTITY WORK.memory (Behavioral);
  
  --Fifo Controller Signals
  signal wrptr,rdptr : std_logic_vector (2 downto 0);
  signal readvalid,writevalid : std_logic;
  

  begin
    
    --Port Mapping of Fifo Controller
      fifo_control1 : fifo_controller port map (reset,rclk,wclk,r_req,w_req,writevalid,readvalid,wrptr,rdptr,empty,full);
    --Port Mapping of Memory
      memory1 : memory port map (datain,wrptr,rdptr,writevalid,readvalid,wclk,rclk,dataout);   
        
end architecture;
        
        
