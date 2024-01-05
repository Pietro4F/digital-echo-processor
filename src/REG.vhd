LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Registro con numero di bit parametrico
-------------------------------------------------

ENTITY REG IS
	GENERIC (N : INTEGER := 8); --Numero di bit
	PORT (
		R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		Clock, Clear, Enable : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
	);
END REG;

ARCHITECTURE Behavior OF REG IS

BEGIN

	Register_process : PROCESS (Clock)

	BEGIN

		IF (Clock'EVENT AND Clock = '1') THEN

			IF (Clear = '1') THEN
				Q <= (OTHERS => '0'); --Reset del valore memorizzato

			ELSIF (Enable = '1') THEN
				Q <= R; --Campionamento dell'ingresso

			END IF;

		END IF;

	END PROCESS;

END Behavior;