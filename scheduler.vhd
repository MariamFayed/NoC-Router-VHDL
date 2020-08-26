library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY scheduler IS 
PORT(clock: IN STD_LOGIC;
	din1, din2, din3, din4: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	dout: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END scheduler;

ARCHITECTURE Behav of scheduler IS

TYPE STATE_TYPE IS (S0, S1, S2, S3 );
SIGNAL CS, NS : STATE_TYPE := S0;


BEGIN 


PROCESS(CS) BEGIN
	CASE CS IS
	    WHEN S0 => NS <= S1; 
	    WHEN S1 => NS <= S2; 
	    WHEN S2 => NS <= S3; 
	    WHEN S3 => NS <= S0; 
	END CASE;

	CASE CS IS
	    WHEN S0 =>  dout <= din1;
	    WHEN S1 =>  dout <= din2;
	    WHEN S2 =>  dout <= din3;
	    WHEN S3 =>  dout <= din4;
	END CASE;
	
END PROCESS;


PROCESS(clock)
  begin 
    if (clock='1' and not clock'stable) then
      CS <= NS;
    end if;
end process;

END Behav;




