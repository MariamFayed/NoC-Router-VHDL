library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity GCounter_tb is
  generic ( n   : integer := 3);
end entity;

architecture Behavioral of GCounter_tb is

component GCounter
generic ( n   : integer := 3);
PORT(	clk, reset, en : IN std_logic;
	Count_out: OUT std_logic_vector (n DOWNTO 0));

end component;

signal reset,clk,en: std_logic := '0';
signal counter:std_logic_vector(n downto 0);
constant clk_period : time := 20 ns;

for dut :GCounter USE ENTITY WORK.GCounter (behav);

begin
dut: GCounter port map (clk, reset, en, counter);
   

clock_process :process
begin
     clk <= '0';
     wait for 10 ns;
     clk <= '1';
     wait for 10 ns;
end process;


stim_proc: process
begin        
  
   reset <= '1';
   wait for  clk_period;    
    reset <= '0';
    en <= '1';
   wait;
end process;
end Behavioral;
