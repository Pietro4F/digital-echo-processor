LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Sottrattore di numeri unsigned
-- con numero di bit parametrico
-------------------------------------------------

ENTITY SUBTRACTOR IS
	GENERIC (N : INTEGER := 9);
	PORT (
		A, B : IN UNSIGNED(N - 1 DOWNTO 0);
		Y : OUT UNSIGNED(N DOWNTO 0)
	);
END SUBTRACTOR;

ARCHITECTURE Behavior OF SUBTRACTOR IS

BEGIN

	Y <= (('0' & A) - ('0' & B));

END ARCHITECTURE;