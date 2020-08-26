library ieee;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY ROUTER IS
  generic (n : integer := 7);
  PORT (rst: in std_logic;
        rclock: in std_logic;
        wclock: in std_logic;
        wr1,wr2,wr3,wr4: in std_logic;
        datai1,datai2,datai3,datai4: in std_logic_vector (n downto 0);
        datao1,datao2,datao3,datao4: out std_logic_vector (n downto 0)
       );
END ROUTER;

ARCHITECTURE Router_Struct of ROUTER is
  
  COMPONENT  input_buffer IS
  GENERIC ( n   : integer := 7);
  port (  data_in           :   in std_logic_vector (n downto 0);
          clk,clk_en,rst    :   in std_logic;
          data_out          :   out std_logic_vector (n downto 0)
        );   
  END COMPONENT input_buffer;

  FOR IB_1: input_buffer USE ENTITY WORK.input_buffer (reg);
  FOR IB_2: input_buffer USE ENTITY WORK.input_buffer (reg);
  FOR IB_3: input_buffer USE ENTITY WORK.input_buffer (reg);
  FOR IB_4: input_buffer USE ENTITY WORK.input_buffer (reg);
  
  COMPONENT demux IS
  GENERIC ( n   : integer := 7);
  port (  data_in                      :   in std_logic_vector (n downto 0);
          d_out1,d_out2,d_out3,d_out4  :   out std_logic_vector(n downto 0);
          sel                          :   in std_logic_vector (1 downto 0);
          en                           :   in std_logic);    
 END COMPONENT demux;
 
 FOR DeMux_1: demux USE ENTITY WORK.demux (behav_demux);
 FOR DeMux_2: demux USE ENTITY WORK.demux (behav_demux);
 FOR DeMux_3: demux USE ENTITY WORK.demux (behav_demux);
 FOR DeMux_4: demux USE ENTITY WORK.demux (behav_demux);
 
 COMPONENT fifo IS 
   generic (n : integer := 7);
   PORT(reset: in std_logic;
        rclk: in std_logic;
        wclk: in std_logic;
        r_req: in std_logic;
        w_req: in std_logic;
        
        datain : in std_logic_vector(n downto 0);
        dataout: out std_logic_vector(n downto 0);
        empty: out std_logic;
        full: out std_logic );
  END COMPONENT fifo;
  
  
  FOR fifo_11: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_21: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_31: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_41: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_12: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_22: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_32: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_42: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_13: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_23: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_33: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_43: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_14: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_24: fifo USE ENTITY WORK.fifo (fifo_struct);
  FOR fifo_34: fifo USE ENTITY WORK.fifo (fifo_struct); 
  FOR fifo_44: fifo USE ENTITY WORK.fifo (fifo_struct);
  
  COMPONENT scheduler IS 
   PORT(clock: IN STD_LOGIC;
	 din1, din2, din3, din4: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	 dout: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
  END COMPONENT scheduler;
  
  FOR scheduler1: scheduler USE ENTITY WORK.scheduler (Behav);
  FOR scheduler2: scheduler USE ENTITY WORK.scheduler (Behav);
  FOR scheduler3: scheduler USE ENTITY WORK.scheduler (Behav);
  FOR scheduler4: scheduler USE ENTITY WORK.scheduler (Behav);
  
  
  --Input Buffers Signals
  SIGNAL data_in1,data_in2,data_in3,data_in4 : std_logic_vector (7 downto 0);
  SIGNAL clk,clk_en,rst_IB : std_logic;
  SIGNAL IBdata_out1,IBdata_out2,IBdata_out3,IBdata_out4 : std_logic_vector (7 downto 0);
  
  --Demux Signals
  SIGNAL dataout_1,dataout_2,dataout_3,dataout_4,dataout_5,dataout_6,dataout_7,
         dataout_8,dataout_9,dataout_10,dataout_11,dataout_12,dataout_13, 
         dataout_14,dataout_15,dataout_16 : std_logic_vector (7 downto 0);
         
  --FIFO Signals
  SIGNAL Fdataout_1,Fdataout_2,Fdataout_3,Fdataout_4,Fdataout_5,Fdataout_6,Fdataout_7,
         Fdataout_8,Fdataout_9,Fdataout_10,Fdataout_11,Fdataout_12,Fdataout_13, 
         Fdataout_14,Fdataout_15,Fdataout_16 : std_logic_vector (7 downto 0);
  SIGNAL empty_1,empty_2,empty_3,empty_4,empty_5,empty_6,empty_7,empty_8,empty_9,empty_10,empty_11,empty_12,empty_13,empty_14,empty_15,empty_16 : std_logic;
  SIGNAL full_1,full_2,full_3,full_4,full_5,full_6,full_7,full_8,full_9,full_10,full_11,full_12,full_13,full_14,full_15,full_16 : std_logic;
  
  SIGNAL RFIFO : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";      --Read Signal for Round Robin Synchronization
  SIGNAL NS    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  
 
  SIGNAL WFIFO_1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";    --Write Requests for FIFO'S connected to first demux
  SIGNAL WFIFO_2 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";    --Write Requests for FIFO'S connected to second demux
  SIGNAL WFIFO_3 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";    --Write Requests for FIFO'S connected to third demux
  SIGNAL WFIFO_4 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";    --Write Requests for FIFO'S connected to fourth demux



  SIGNAL r_req1,r_req2,r_req3,r_req4,r_req5,r_req6,r_req7,r_req8        :  std_logic  ;
  SIGNAL r_req9,r_req10,r_req11,r_req12,r_req13,r_req14,r_req15,r_req16 : std_logic   ;

BEGIN
  
  --Router/Input Buffers Port Mapping      
  IB_1: input_buffer port map(datai1,wclock,wr1,rst,IBdata_out1);
  IB_2: input_buffer port map(datai2,wclock,wr2,rst,IBdata_out2);
  IB_3: input_buffer port map(datai3,wclock,wr3,rst,IBdata_out3);
  IB_4: input_buffer port map(datai4,wclock,wr4,rst,IBdata_out4);
          
  --Input Buffers/Demuxes Port Mapping
  Demux_1: demux port map(IBdata_out1,dataout_1,dataout_5,dataout_9, dataout_13,IBdata_out1(1 downto 0),wr1);
  Demux_2: demux port map(IBdata_out2,dataout_2,dataout_6,dataout_10,dataout_14,IBdata_out2(1 downto 0),wr2);
  Demux_3: demux port map(IBdata_out3,dataout_3,dataout_7,dataout_11,dataout_15,IBdata_out3(1 downto 0),wr3);
  Demux_4: demux port map(IBdata_out4,dataout_4,dataout_8,dataout_12,dataout_16,IBdata_out4(1 downto 0),wr4);

  --Demuxes/FIFO Port Mapping  
  fifo_11 : fifo port map (rst, rclock, wclock, r_req1,WFIFO_1(0),  dataout_1, Fdataout_1, empty_1, full_1);
  fifo_21 : fifo port map (rst, rclock, wclock, r_req2,WFIFO_2(0),  dataout_2, Fdataout_2, empty_2, full_2);
  fifo_31 : fifo port map (rst, rclock, wclock, r_req3,WFIFO_3(0),  dataout_3, Fdataout_3, empty_3, full_3);
  fifo_41 : fifo port map (rst, rclock, wclock, r_req4,WFIFO_4(0),  dataout_4, Fdataout_4, empty_4, full_4);
  fifo_12 : fifo port map (rst, rclock, wclock, r_req5,WFIFO_1(1),  dataout_5, Fdataout_5, empty_5, full_5);
  fifo_22 : fifo port map (rst, rclock, wclock, r_req6,WFIFO_2(1),  dataout_6, Fdataout_6, empty_6, full_6);
  fifo_32 : fifo port map (rst, rclock, wclock, r_req7,WFIFO_3(1),  dataout_7, Fdataout_7, empty_7, full_7);
  fifo_42 : fifo port map (rst, rclock, wclock, r_req8,WFIFO_4(1),  dataout_8, Fdataout_8, empty_8, full_8);
  fifo_13 : fifo port map (rst, rclock, wclock, r_req9,WFIFO_1(2),  dataout_9, Fdataout_9, empty_9, full_9);
  fifo_23 : fifo port map (rst, rclock, wclock, r_req10,WFIFO_2(2), dataout_10,Fdataout_10,empty_10,full_10);
  fifo_33 : fifo port map (rst, rclock, wclock, r_req11,WFIFO_3(2), dataout_11,Fdataout_11,empty_11,full_11);
  fifo_43 : fifo port map (rst, rclock, wclock, r_req12,WFIFO_4(2), dataout_12,Fdataout_12,empty_12,full_12);
  fifo_14 : fifo port map (rst, rclock, wclock, r_req13,WFIFO_1(3), dataout_13,Fdataout_13,empty_13,full_13);
  fifo_24 : fifo port map (rst, rclock, wclock, r_req14,WFIFO_2(3), dataout_14,Fdataout_14,empty_14,full_14);
  fifo_34 : fifo port map (rst, rclock, wclock, r_req15,WFIFO_3(3), dataout_15,Fdataout_15,empty_15,full_15);
  fifo_44 : fifo port map (rst, rclock, wclock, r_req16,WFIFO_4(3), dataout_16,Fdataout_16,empty_16,full_16);  
    
  --FIFO/Scheduler Port Mapping
  scheduler1 : scheduler port map (rclock, Fdataout_1, Fdataout_2, Fdataout_3, Fdataout_4, datao1);
  scheduler2 : scheduler port map (rclock, Fdataout_5, Fdataout_6, Fdataout_7, Fdataout_8, datao2);
  scheduler3 : scheduler port map (rclock, Fdataout_9, Fdataout_10,Fdataout_11,Fdataout_12,datao3);
  scheduler4 : scheduler port map (rclock, Fdataout_13,Fdataout_14,Fdataout_15,Fdataout_16,datao4);

  --Read Requests Logic Implementation
  r_req1  <= (not(empty_1)  and RFIFO(0));
  r_req2  <= (not(empty_2)  and RFIFO(1));
  r_req3  <= (not(empty_3)  and RFIFO(2));
  r_req4  <= (not(empty_4)  and RFIFO(3));
  r_req5  <= (not(empty_5)  and RFIFO(0));
  r_req6  <= (not(empty_6)  and RFIFO(1));
  r_req7  <= (not(empty_7)  and RFIFO(2));
  r_req8  <= (not(empty_8)  and RFIFO(3)); 
  r_req9  <= (not(empty_9)  and RFIFO(0));
  r_req10 <= (not(empty_10) and RFIFO(1));
  r_req11 <= (not(empty_11) and RFIFO(2));
  r_req12 <= (not(empty_12) and RFIFO(3));
  r_req13 <= (not(empty_13) and RFIFO(0));
  r_req14 <= (not(empty_14) and RFIFO(1));
  r_req15 <= (not(empty_15) and RFIFO(2)); 
  r_req16 <= (not(empty_16) and RFIFO(3)); 
  
--This part synchronizes the Read Requests of the Router

Process (rclock,rst)      --This process is used to synchronize the round robin with the read request based on FSM
  begin
    if (rst = '1') then
      RFIFO <= "0100";    --Reset state of the variable
  else if (rising_edge(rclock)) then 
      RFIFO <= NS;
    end if;
  end if;
end process;
  
Process (RFIFO)   --This process is setting the next state for the read request based on the case, 
  begin           --where each 4 requests are set to a bit
    case RFIFO is
      when "0001" => 
        NS <= "0010";
      when "0010" =>
        NS <= "0100";
      when "0100" =>
        NS <= "1000";
      when "0000" =>
        NS <= "0001";
      when others => 
        NS <= "0001";
        
      end case;
    end process;
    
--This part of the code synchronizes the Write Requests of the Router

--There are 4 processes, each for one of the write enables.
Process (wr1,wclock,rst) 
  begin
    if (wr1 = '1') then
    case (IBdata_out1(1 downto 0)) is --Selection of Demux output based on the 2 LSB's of the the data in
    when "00" =>	    
          if (full_1 = '0') then      --Setting the Write request for the desired FIFO and turning off the rest
		
               WFIFO_1(0) <= '1';
               WFIFO_1(1) <= '0';
               WFIFO_1(2) <= '0';
               WFIFO_1(3) <= '0';
	    
          else 
               WFIFO_1(0) <= '0';
	   
          end if;

      when "01" => 
          if (full_5 = '0') then
		
               WFIFO_1(1) <= '1';
               WFIFO_1(0) <= '0';
               WFIFO_1(2) <= '0';
               WFIFO_1(3) <= '0';
	    
          else 
               WFIFO_1(1) <= '0';
	   
          end if;
	
      
      when "10" =>   
          if (full_9 = '0') then
		
               WFIFO_1(2) <= '1';
               WFIFO_1(0) <= '0';
               WFIFO_1(1) <= '0';
               WFIFO_1(3) <= '0';
	    
          else 
               WFIFO_1(2) <= '0';
	   
          end if;
	
      
      when "11" =>    
          if (full_13 = '0') then
		
               WFIFO_1(3) <= '1';
               WFIFO_1(0) <= '0';
               WFIFO_1(1) <= '0';
               WFIFO_1(2) <= '0';
	    
          else 
               WFIFO_1(3) <= '0';
	   
          end if;
	
     when others => null;
    end case;
  else                              --If enable is off then turn all write requests off
    WFIFO_1(0) <= '0';
    WFIFO_1(1) <= '0';
    WFIFO_1(2) <= '0';
    WFIFO_1(3) <= '0';
  end if;
end process;
  Process (wr2,wclock,rst)
    begin
    if (wr2 = '1') then
    case (IBdata_out2 (1 downto 0)) is --Selection of Demux output based on the 2 LSB's of the the data in
    when "00" =>	    
          if (full_2 = '0') then       --Setting the Write request for the desired FIFO and turning off the rest
		
               WFIFO_2(0) <= '1';
               WFIFO_2(1) <= '0';
               WFIFO_2(2) <= '0';
               WFIFO_2(3) <= '0';
	    
          else 
               WFIFO_2(0) <= '0';
	   
          end if;
	
      
      when "01" => 
          if (full_6 = '0') then
		
               WFIFO_2(1) <= '1';
               WFIFO_2(0) <= '0';
               WFIFO_2(2) <= '0';
               WFIFO_2(3) <= '0';
	    
          else 
               WFIFO_2(1) <= '0';
	   
          end if;
	
      
      when "10" =>   
          if (full_10 = '0') then
		
               WFIFO_2(2) <= '1';
               WFIFO_2(0) <= '0';
               WFIFO_2(1) <= '0';
               WFIFO_2(3) <= '0';
	    
          else 
               WFIFO_2(2) <= '0';
	   
          end if;
	
      
      when "11" =>    
          if (full_14 = '0') then
		
               WFIFO_2(3) <= '1';
               WFIFO_2(0) <= '0';
               WFIFO_2(1) <= '0';
               WFIFO_2(2) <= '0';
               
	    
          else 
               WFIFO_2(3) <= '0';
	   
          end if;
	
     when others => null;
       
    end case;
     else                              --If enable is off then turn all write requests off
    WFIFO_2(0) <= '0';
    WFIFO_2(1) <= '0';
    WFIFO_2(2) <= '0';
    WFIFO_2(3) <= '0';
  end if;
end process;
Process (wr3,wclock,rst)
  begin
  if (wr3 = '1') then
    case (IBdata_out3(1 downto 0)) is --Selection of Demux output based on the 2 LSB's of the the data in
    when "00" =>	    
          if (full_3 = '0') then      --Setting the Write request for the desired FIFO and turning off the rest
		
               WFIFO_3(0) <= '1';
               WFIFO_3(1) <= '0';
               WFIFO_3(2) <= '0';
               WFIFO_3(3) <= '0';
	    
          else 
               WFIFO_3(0) <= '0';
	   
          end if;
	
      
      when "01" => 
          if (full_7 = '0') then
		
               WFIFO_3(1) <= '1';
               WFIFO_3(0) <= '0';
               WFIFO_3(2) <= '0';
               WFIFO_3(3) <= '0';
	    
          else 
               WFIFO_3(1) <= '0';
	   
          end if;
	
      
      when "10" =>   
          if (full_11 = '0') then
		
               WFIFO_3(2) <= '1';
               WFIFO_3(0) <= '0';
               WFIFO_3(1) <= '0';
               WFIFO_3(3) <= '0';
	    
          else 
               WFIFO_3(2) <= '0';
	   
          end if;
	
      
      when "11" =>    
          if (full_15 = '0') then
		
               WFIFO_3(3) <= '1';
               WFIFO_3(0) <= '0';
               WFIFO_3(1) <= '0';
               WFIFO_3(2) <= '0';
               
	    
          else 
               WFIFO_3(3) <= '0';
	   
          end if;
	
     when others => null;
    end case;
   else                              --If enable is off then turn all write requests off 
    WFIFO_3(0) <= '0';
    WFIFO_3(1) <= '0';
    WFIFO_3(2) <= '0';
    WFIFO_3(3) <= '0';
  end if;
end process;
Process (wr4,wclock,rst)
begin  
  if (wr4 = '1') then
    case (IBdata_out4 ( 1 downto 0)) is --Selection of Demux output based on the 2 LSB's of the the data in 
    when "00" =>	    
          if (full_4 = '0') then        --Setting the Write request for the desired FIFO and turning off the rest
		
               WFIFO_4(0) <= '1';
               WFIFO_4(1) <= '0';
               WFIFO_4(2) <= '0';
               WFIFO_4(3) <= '0';
	    
          else 
               WFIFO_4(0) <= '0';
	   
          end if;
	
      
      when "01" => 
          if (full_8 = '0') then
		
               WFIFO_4(1) <= '1';
               WFIFO_4(0) <= '0';
               WFIFO_4(2) <= '0';
               WFIFO_4(3) <= '0';
	    
          else 
               WFIFO_4(1) <= '0';
	   
          end if;
	
      
      when "10" =>   
          if (full_12 = '0') then
		
               WFIFO_4(2) <= '1';
               WFIFO_4(0) <= '0';
               WFIFO_4(1) <= '0';
               WFIFO_4(3) <= '0';
	    
          else 
               WFIFO_4(2) <= '0';
	   
          end if;
	
      
      when "11" =>    
          if (full_16 = '0') then
		
               WFIFO_4(3) <= '1';
               WFIFO_4(0) <= '0';
               WFIFO_4(1) <= '0';
               WFIFO_4(2) <= '0';
	    
          else 
               WFIFO_4(3) <= '0';
	   
          end if;
	
     when others => null;
    end case;
 else 
    WFIFO_4(0) <= '0';
    WFIFO_4(1) <= '0';
    WFIFO_4(2) <= '0';
    WFIFO_4(3) <= '0';
  end if;
  end process;

END ARCHITECTURE;