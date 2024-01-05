LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Contatore con valore con numero di bit impostabile
-- parametricamente e valore di terminal count
-- specificabile esternamente
-------------------------------------------------

ENTITY CNT_SEL IS
	GENERIC (N : INTEGER := 8); --Numero di bit
	PORT (
		Enable, Clock, Clear : IN STD_LOGIC;
		Module : IN UNSIGNED(N - 1 DOWNTO 0);
		Tc : OUT STD_LOGIC;
		Q : BUFFER UNSIGNED(3 DOWNTO 0)
	);
END CNT_SEL;

ARCHITECTURE Behavior OF CNT_SEL IS
BEGIN

	Count_process : PROCESS (Clock, Clear)

	BEGIN

		IF Clear = '1' THEN --Reset asincrono
			Q <= (OTHERS => '0'); --Reset del conteggio
			Tc <= '0'; --Reset segnale di terminal count

		ELSE
			IF (Clock'EVENT AND Clock = '1') THEN

				IF (Enable = '1') THEN

					Q <= Q + 1; --Incremento conteggio

					IF (To_integer(Q) = Module - 1) THEN --Se valore contato è equivalente a quello di terminal count impostato
						Tc <= '1'; --Asserzione segnale di terminal count
					ELSE
						Tc <= '0'; --Reset segnale di terminal count
					END IF;

				END IF;
			END IF;
		END IF;

	END PROCESS Count_process;

END Behavior;