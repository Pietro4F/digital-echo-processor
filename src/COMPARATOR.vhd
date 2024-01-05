LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Comparatore a due ingressi con numero di bit
-- impostabile parametricamente
-------------------------------------------------

ENTITY COMPARATOR IS
	GENERIC (N : INTEGER := 8); --Numero di bit
	PORT (
		A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
		Equal : OUT STD_LOGIC
	);
END COMPARATOR;

ARCHITECTURE Behavior OF COMPARATOR IS

BEGIN

	Comparator_process : PROCESS (A, B)
	BEGIN

		IF (A = B) THEN --Verifica uguaglianza tra i due input
			Equal <= '1';
		ELSE
			Equal <= '0';
		END IF;

	END PROCESS;

END ARCHITECTURE;