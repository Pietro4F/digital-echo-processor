LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Sommatore di numeri unsigned
-- con numero di bit parametrico
-------------------------------------------------

ENTITY ADDER_U IS
	GENERIC (N : INTEGER := 9);
	PORT (
		A, B : IN UNSIGNED(N - 1 DOWNTO 0);
		Y : OUT UNSIGNED(N - 1 DOWNTO 0)
	);
END ADDER_U;

ARCHITECTURE Behavior OF ADDER_U IS

BEGIN

	Y <= (A + B);

END ARCHITECTURE;