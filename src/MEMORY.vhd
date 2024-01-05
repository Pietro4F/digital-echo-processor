LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

-------------------------------------------------
-- Memoria sincrona a due porte con larghezza
-- di word e numero di celle impostabili parametricamente
-------------------------------------------------

ENTITY MEMORY IS
	GENERIC (
		N : INTEGER := 9;      --Numero bit
		M : INTEGER := 44100); --Numero di word
	PORT (
		Din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		AddR, AddW : IN UNSIGNED(INTEGER(ceil(log2(real(M)))) - 1 DOWNTO 0);
		Clock, REn, WEn : IN STD_LOGIC;
		Dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
	);
END MEMORY;

ARCHITECTURE Behavior OF MEMORY IS

	TYPE Mem IS ARRAY (M - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

BEGIN

	PROCESS (Clock)

		VARIABLE Data : Mem := (OTHERS => (OTHERS => '0'));

	BEGIN

		IF (Clock'EVENT AND Clock = '1') THEN

			--Se lettura abilitata
			IF (REn = '1') THEN

				--Allora mettere in uscita il dato memorizzato nella cella puntata dall'indirizzo indicato
				Dout <= Data(To_integer(AddR));

			END IF;

			--Se scrittura abilitata
			IF (WEn = '1') THEN

				--Scrivere nella cella di memoria all'indirizzo indicato il dato in ingresso
				Data(To_integer(AddW)) := Din;

			END IF;

		END IF;

	END PROCESS;

END Behavior;