library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 


ENTITY memory IS
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
END memory;

ARCHITECTURE Behavioral OF memory IS

TYPE RAM IS ARRAY(0 TO 2 ** ADDRESS_WIDTH - 1) OF std_logic_vector(DATA_WIDTH - 1 DOWNTO 0); 

SIGNAL ram_block : RAM ;
BEGIN

   PROCESS (CLKA)
   BEGIN
      IF (CLKA'event AND CLKA = '1') THEN
         IF (WEA = '1') THEN --Check write request to write into the memory
            ram_block(to_integer(unsigned(ADDRA))) <= D_in; 
         END IF;
      END IF;
   END PROCESS;

  PROCESS (CLKB)
   BEGIN
      IF (clkB'event AND clkB = '1') THEN
	IF(REA = '1') THEN     --Check read request to read from the memory
		D_out <= ram_block(to_integer(unsigned(ADDRB)));
	ELSE
		D_out <= "ZZZZZZZZ"; --Sets High Impedence if Read Valid is set to 0
	END IF;
      END IF;
   END PROCESS;

END Behavioral ;