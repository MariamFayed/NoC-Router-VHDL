LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY fifo_controller IS
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
END;

architecture fifo_controller_behav of fifo_controller is

  COMPONENT GCounter IS
  PORT(	clk, reset, en : IN std_logic;
	      Count_out: OUT std_logic_vector (3 DOWNTO 0));
  END COMPONENT GCounter;
  
  FOR rd_ptr_GRAY: GCounter USE ENTITY WORK.GCounter (behav);
  
  FOR wr_ptr_GRAY: GCounter USE ENTITY WORK.GCounter (behav);
  
  COMPONENT grayToBin IS
   port (  gray_in           :   in std_logic_vector (3 downto 0);
           bin_out           :   out std_logic_vector (3 downto 0)
       ); 
  END COMPONENT grayToBin;
  
  FOR rd_ptr_add_BIN: grayToBin USE ENTITY WORK.grayToBin (behav);
  
  FOR wr_ptr_a_BIN: grayToBin USE ENTITY WORK.grayToBin (behav);  
  
  --Gray Counter Signals
  signal rd_GCounter,wr_GCounter : std_logic_vector (3 downto 0) := "0000";
  signal en_wr            : std_logic := '0';
  signal en_rd            : std_logic := '0';
  
  --Converter Signals 
  signal rd_G2B_out  : std_logic_vector (3 downto 0) := "0000";
  signal wr_G2Ba_out : std_logic_vector (3 downto 0) := "0000";
  
  
  --FIFO Controller Signals
  signal emptySignal: std_logic := '0';
  signal fullSignal : std_logic := '0';
  signal writevalid : std_logic := '0';
  signal readvalid  : std_logic := '0';
  
  
 begin
 --Port Mapping of GCounters
  rd_ptr_GRAY: GCounter port map (rdclk,reset,en_rd,rd_GCounter);
  wr_ptr_GRAY: GCounter port map (wrclk,reset,en_wr,wr_GCounter);
    
  
  --Port Mapping of Converters
  rd_ptr_add_BIN : grayToBin port map (rd_GCounter,rd_G2B_out);
  wr_ptr_a_BIN   : grayToBin port map (wr_GCounter,wr_G2Ba_out);



p2: process(rdclk,wrclk,reset)
  begin
    if reset = '1' then 
       emptySignal <= '1';
       fullSignal  <= '0'; 
       end if; 

if (rising_edge(rdclk)) then
 
   if (wr_GCounter(3 downto 0) = rd_GCounter(3 downto 0)) then     --Checking if Empty Flag through Grey Bits
          emptySignal <='1';
          fullSignal <= '0'; 
          readvalid <= '0';
	        en_rd <= '0';
                        
        else 
          readvalid <= '1'; 
          if (emptySignal = '0' AND r_req = '1') then               --Enable or disable the read counter based on read request 
            en_rd <= '1';                                           --And Empty Flag
            fullSignal <= '0';
          elsif (r_req = '0') then
            en_rd <= '0';  
          end if;
    end if;
end if;


      
if (rising_edge(wrclk)) then 
  if ((wr_GCounter(3) /= rd_GCounter(3)) AND (wr_GCounter(2) /= rd_GCounter(2)) AND (wr_GCounter(1 downto 0) 
      = rd_GCounter(1 downto 0))) then                               --Checking if Full Flag through Grey Bits
        fullSignal <= '1';                                            
        emptySignal <= '0';        
        writevalid <= '0';
	      en_wr <= '0';            
      
	else 
	 writevalid <= '1'; 
	  if (fullSignal = '0' AND w_req = '1' ) then                       --Enable or disable the write counter based on write request    
        en_wr <= '1';                           	               	     --And Full Flag
    elsif  (w_req = '0') then        
        en_wr <= '0';
    end if;

   
	  end if;
	end if;
	
	if(en_wr ='1') then
	   emptySignal <= '0';
	end if;

  write_valid <= writevalid;
  read_valid <= readvalid;
  rd_ptr <= rd_G2B_out(2 downto 0);
  wr_ptr <= wr_G2Ba_out(2 downto 0);
  empty <= emptySignal;
  full <= fullSignal;
end process p2;
end architecture;