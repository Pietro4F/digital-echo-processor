LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- SHIFT REGISTER in cui abbiamo i 4 bit campionati che vengono salvati come LSB
-- In uscita abbiamo tutti i bit in parallelo
-------------------------------------------------

ENTITY SHIFT_REGISTER IS
    GENERIC (
        W : INTEGER := 4;
        D : INTEGER := 4
    );
    PORT (
        Clock, Clear, Load : IN STD_LOGIC;
        Data_in : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
        Data_out : BUFFER STD_LOGIC_VECTOR((W * D) - 1 DOWNTO 0)
    );
END SHIFT_REGISTER;

ARCHITECTURE behaviour OF SHIFT_REGISTER IS

BEGIN

    Shift_process : PROCESS (Clock)

    BEGIN

        IF (Clock'EVENT AND Clock = '1') THEN

            IF (Clear = '1') THEN
                Data_out <= (OTHERS => '0'); --Reset del valore memorizzato

            ELSIF (Load = '1') THEN
                Data_out <= Data_out((W * D) - 5 DOWNTO 0) & Data_in; --Operazione di shift
            END IF;

        END IF;

    END PROCESS;

END ARCHITECTURE;