LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Shift register con caricamento parallelo e uscita
-- sequenziale con numero di bit impostabile parametricamnete
-------------------------------------------------

ENTITY PISO IS
	GENERIC (N : INTEGER := 8); --Numero di bit
	PORT (
		R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		Clock, Clear, Load, Shift : IN STD_LOGIC;
		Q : OUT STD_LOGIC
	);
END PISO;

ARCHITECTURE Behavioral OF PISO IS

BEGIN

	Piso_process : PROCESS (Clock)

		VARIABLE Data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0); --Valore memorizzato nel registro

	BEGIN

		IF (Clock'EVENT AND Clock = '1') THEN

			IF (Clear = '1') THEN
				Data := (OTHERS => '0'); --Reset del valore memorizzato

			ELSIF (Load = '1') THEN
				Data := R; --Campionamento dell'ingresso parallelo

			ELSIF (Shift = '1') THEN
				Data := '0' & Data(N - 1 DOWNTO 1); --Operazione di shift

			END IF;

		END IF;

		Q <= Data(0); --Aggiornamento dell'uscita sequenziale

	END PROCESS;

END ARCHITECTURE;