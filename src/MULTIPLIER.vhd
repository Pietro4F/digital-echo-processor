LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Moltiplicatore di numeri signed fixed point
-- con numero di bit parametrico
-------------------------------------------------

ENTITY MULTIPLIER IS
	GENERIC (N : INTEGER := 9);
	PORT (
		A, B : IN sfixed(-1 DOWNTO -N);
		Y : OUT sfixed(-1 DOWNTO - (2 * N))
	);
END MULTIPLIER;

ARCHITECTURE Behavior OF MULTIPLIER IS

BEGIN

	Y <= (A * B);

END ARCHITECTURE;