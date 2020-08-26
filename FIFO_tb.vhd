library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FIFO_tb is
generic (n : integer := 7);
end entity;

architecture Behavioral of FIFO_tb is

component FIFO
   
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

END COMPONENT;

for dut : fifo USE ENTITY WORK.fifo (fifo_struct);

SIGNAL d_in, d_out : std_logic_vector(n downto 0);
SIGNAL rdclk, wrclk, r_req, w_req, empty, full, reset : std_logic;


BEGIN

dut : fifo port map (reset, rdclk, wrclk, r_req, w_req, d_in, d_out , empty, full);

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
  
  sim : process is 
    begin 
	reset <= '1';
	wait for 20 ns;
	reset <= '0';
	wait for 20 ns;

	w_req <= '1';
	r_req <= '0';
	d_in <= "00000001";
	wait for 20 ns;
	d_in <= "00000010";
	wait for 20 ns;
  d_in <= "00000100";
	wait for 20 ns;
	d_in <= "00001000";
	wait for 20 ns;
	d_in <= "00010000";
	wait for 20 ns;
	d_in <= "00100000";
	wait for 20 ns;
	d_in <= "01000000";
  wait for 20 ns;
  w_req <= '0';
  r_req <= '1';
  wait;





END PROCESS;

END ARCHITECTURE;
