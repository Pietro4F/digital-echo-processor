LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Comparatore di numeri unsigned
-- con valore di soglia parametrico,
-- uscita attiva se ingreso è maggiore della soglia
-------------------------------------------------

ENTITY COMPARATOR_GENERIC_VALUE IS
	GENERIC (M : INTEGER := 8); --Soglia
	PORT (
		Din : IN UNSIGNED(15 DOWNTO 0);
		Greater : OUT STD_LOGIC
	);
END COMPARATOR_GENERIC_VALUE;

ARCHITECTURE Behavior OF COMPARATOR_GENERIC_VALUE IS

BEGIN

	PROCESS (Din)

	BEGIN

		IF (Din > to_unsigned(M, Din'LENGTH)) THEN

			Greater <= '1';

		ELSE

			Greater <= '0';

		END IF;

	END PROCESS;

END ARCHITECTURE;