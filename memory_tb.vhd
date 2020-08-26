
LIBRARY IEEE;
USE IEEE.std_lOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY memory_tb IS
END memory_tb;
 
ARCHITECTURE behavior OF memory_tb IS 
COMPONENT memory
    GENERIC ( ADDRESS_WIDTH : integer := 3; 
          DATA_WIDTH : integer := 8 ); 
PORT(
        D_in : IN std_logic_vector(DATA_WIDTH-1 downto 0);             
        ADDRA : IN std_logic_vector(ADDRESS_WIDTH-1 downto 0);            
        ADDRB : IN std_logic_vector(ADDRESS_WIDTH-1 downto 0);        
        REA : IN std_logic;                             
        WEA : IN std_logic;                             
        CLKA: IN std_logic;                             
        CLKB: IN std_logic;            
        D_out : OUT std_logic_vector (DATA_WIDTH-1 downto 0)           
);

END COMPONENT memory;

FOR dut:  memory USE ENTITY WORK. memory(Behavioral);
   signal data_in : std_logic_vector (7 downto 0) := (others => '0') ;
   signal ADDRA : std_logic_vector (2 downto 0) := (others => '0') ;
   signal ADDRB : std_logic_vector (2 downto 0) := (others => '0') ;
   signal WEA : std_logic := '0';
   signal REA : std_logic := '0';
   signal clkA : std_logic := '0';
   signal clkB : std_logic := '0';
   signal data_out: std_logic_vector(7 downto 0) := (others => '0'); 

   constant clk_period : time := 20 ns;

BEGIN
   dut: memory PORT MAP (data_in, ADDRA , ADDRB , REA , WEA , clkA , clkB , data_out);


   clkA_process : PROCESS
     BEGIN
        clkA <= '1';
        wait for clk_period/2;
        clkA <= '0';
        wait for clk_period/2;
     END PROCESS clkA_process;
    
   clkB_process : PROCESS
     BEGIN
        clkB <= '1';
        wait for clk_period/2;
        clkB <= '0';
        wait for clk_period/2;
     END PROCESS clkB_process;

   stim_proc: PROCESS
     BEGIN
	WEA <= '0';
	REA <= '0';
	data_in <= "11111111";
	ADDRA <= "001";
	ADDRB <= "010";
	WAIT FOR clk_period;
	Assert data_out = "00000000"  Report "ERROR IN THE ENABLE BITTS" Severity ERROR;


	WEA <= '1';
	for i in 1 to 8 loop
            data_in <= conv_std_logic_vector(i,8);
            ADDRA <= conv_std_logic_vector(i-1,3);
            wait for clk_period;
	END LOOP;
	

	REA <= '1';
	for i in 1 to 8 loop
            ADDRB <= conv_std_logic_vector(i-1,3);
            wait for clk_period;	
	END LOOP;

	REA <= '0';
	WEA <= '0';
	
WAIT;

END PROCESS;

END;      
	