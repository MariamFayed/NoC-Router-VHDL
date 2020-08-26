LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY GCounter IS
generic (n : integer := 3);
PORT(	clk, reset, en : IN std_logic;
	Count_out: OUT std_logic_vector (n DOWNTO 0));

END ENTITY GCounter;

ARCHITECTURE behav OF GCounter IS

COMPONENT BCounter IS

PORT(Clock, Reset, En : in  std_logic;
     D_out : out std_logic_vector(n downto 0));
 

END COMPONENT BCounter;

FOR ALL: BCounter USE ENTITY WORK.BCounter(archi);

SIGNAL db_in: std_logic_vector (n DOWNTO 0) := "0000";

BEGIN

bcount: BCounter 

PORT MAP(clk, reset, en, db_in);


Count: PROCESS (db_in) IS

BEGIN
	Count_out(n) <= db_in(n);  --Setting the the MSB in the binary code to the MSB in grey code
	FOR j IN n-1 DOWNTO 0 LOOP --XORing of the current and next binary inputs
	Count_out(j) <= db_in (j+1) XOR db_in (j);
	END LOOP;

END PROCESS Count;
END ARCHITECTURE behav;
