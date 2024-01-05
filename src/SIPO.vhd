LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Shift register con caricamento sequenziale e uscita
-- parallela con numero di bit impostabile parametricamnete
-------------------------------------------------

ENTITY SIPO IS
	GENERIC (N : INTEGER := 8); --Numero di bit
	PORT (
		Clock, Clear, Load, R : IN STD_LOGIC;
		Q : BUFFER STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
	);
END SIPO;

ARCHITECTURE Behavior OF SIPO IS

BEGIN

	Sipo_process : PROCESS (Clock)

	BEGIN

		IF (Clock'EVENT AND Clock = '1') THEN

			IF (Clear = '1') THEN
				Q <= (OTHERS => '0'); --Reset del valore memorizzato

			ELSIF (Load = '1') THEN
				Q <= R & Q(N - 1 DOWNTO 1); --Operazione di shift

			END IF;
		END IF;

	END PROCESS;

END ARCHITECTURE;