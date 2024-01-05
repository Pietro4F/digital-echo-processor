LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Multiplexer a due ingressi con numero
-- di bit impostabile parametricamente
-------------------------------------------------

ENTITY MUX2to1_Nbit IS
    GENERIC (N : INTEGER := 1); --Numero di bit
    PORT (
        X, Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        S : IN STD_LOGIC;
        M : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END MUX2to1_Nbit;

ARCHITECTURE Behavior OF MUX2to1_Nbit IS

BEGIN

    WITH S SELECT
        M <= X WHEN '0',
        Y WHEN OTHERS;

END ARCHITECTURE;