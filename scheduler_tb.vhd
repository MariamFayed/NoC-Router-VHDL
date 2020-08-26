library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY scheduler_tb IS
END ENTITY scheduler_tb;

ARCHITECTURE behav OF scheduler_tb IS 

COMPONENT scheduler IS 
PORT(clock: IN STD_LOGIC;
	din1, din2, din3, din4: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	dout: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT scheduler;

FOR dut: scheduler USE ENTITY WORK.scheduler (Behav);

SIGNAL clk : STD_LOGIC := '0'; 
constant clk_period : time := 20 ns;
SIGNAL input1: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL input2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL input3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL input4 : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL output: STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

BEGIN

dut: scheduler PORT MAP (clk, input1, input2, input3, input4, output);

clk_process :process is
   	begin
        clk <= '1';
        wait for clk_period/2;  
        clk <= '0';
        wait for clk_period/2;  
end process;

PROCESS IS
BEGIN 

input1 <= "00011100";
input2 <= "11100011";
input3 <= "00110011";
input4 <= "10101010";

WAIT;
END PROCESS;

END ARCHITECTURE behav;




