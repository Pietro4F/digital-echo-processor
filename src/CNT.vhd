LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

-------------------------------------------------
-- Contatore con valore di terminal count
-- impostabile parametricamente e numero di bit
-- necessari calcolato automaticamente
-------------------------------------------------

ENTITY CNT IS
	GENERIC (M : INTEGER := 1040); --Valore di terminal count
	PORT (
		Enable, Clock, Clear : IN STD_LOGIC;
		Tc : OUT STD_LOGIC;
		Q : BUFFER UNSIGNED(INTEGER(ceil(log2(real(M)))) - 1 DOWNTO 0)
	);
END CNT;

ARCHITECTURE Behavior OF CNT IS
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

					IF (To_integer(Q) = M - 1) THEN --Se valore contato è equivalente a quello di terminal count impostato
						Tc <= '1'; --Asserzione segnale di TERMINAL COUNT
					ELSE
						Tc <= '0'; --Reset segnale di terminal count
					END IF;

				END IF;
			END IF;
		END IF;

	END PROCESS Count_process;

END Behavior;