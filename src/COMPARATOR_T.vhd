LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Controlla che il carattere ASCII in ingresso corrisponda ad un comando
-- e in uscita Val indica di quale comando si tratti
-- In caso di input non validi Val = 00
-------------------------------------------------

ENTITY COMPARATOR_T IS
    PORT (
        Dato : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Val : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END COMPARATOR_T;

ARCHITECTURE behaviour OF COMPARATOR_T IS

BEGIN

    Comaparator_process : PROCESS (Dato)

    BEGIN

        IF (Dato = "01010100") THEN -- T delay
            Val <= "01";
        ELSIF (Dato = "00101010") THEN -- * gain
            Val <= "10";
        ELSIF (Dato = "00101101") THEN -- - trattino decay
            Val <= "11";
        ELSE
            Val <= "00"; -- comando non valido
        END IF;

    END PROCESS;

END ARCHITECTURE;