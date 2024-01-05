LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Sommatore di numeri signed fixed point
-- con numero di bit parametrico
-------------------------------------------------

ENTITY ADDER IS
	GENERIC (N : INTEGER := 9);
	PORT (
		A, B : IN sfixed(-1 DOWNTO -N);
		Y : OUT sfixed(0 DOWNTO -N)
	);
END ADDER;

ARCHITECTURE Behavior OF ADDER IS

BEGIN

	Y <= (A + B);

END ARCHITECTURE;