LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- converte il carattere ASCII in esadecimale
-- converte sia lettere maiuscole che minuscole
-- 
--se l'input è valido in uscita Valid = 1 altrimenti è uguale a 0
-------------------------------------------------

ENTITY COMPARATOR_H IS
    PORT (
        Dato : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Hex : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        Valid : OUT STD_LOGIC
    );
END COMPARATOR_H;

ARCHITECTURE behaviour OF COMPARATOR_H IS

BEGIN

    Comaparator_process : PROCESS (Dato)

    BEGIN

        IF (Dato = "00110000") THEN -- 0
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110001") THEN -- 1
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110010") THEN -- 2
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110011") THEN -- 3
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110100") THEN -- 4
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110101") THEN -- 5
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110110") THEN -- 6
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00110111") THEN -- 7
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00111000") THEN -- 8
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "00111001") THEN -- 9
            Valid <= '1';
            Hex <= Dato(3 DOWNTO 0);
        ELSIF (Dato = "01000001" OR Dato = "01100001") THEN -- A a
            Valid <= '1';
            Hex <= "1010";
        ELSIF (Dato = "01000010" OR Dato = "01100010") THEN -- B b
            Valid <= '1';
            Hex <= "1011";
        ELSIF (Dato = "01000011" OR Dato = "01100011") THEN -- C c
            Valid <= '1';
            Hex <= "1100";
        ELSIF (Dato = "01000100" OR Dato = "01100100") THEN -- D d
            Valid <= '1';
            Hex <= "1101";
        ELSIF (Dato = "01000101" OR Dato = "01100101") THEN -- E e
            Valid <= '1';
            Hex <= "1110";
        ELSIF (Dato = "01000110" OR Dato = "01100110") THEN -- F f
            Valid <= '1';
            Hex <= "1111";
        ELSE
            Valid <= '0'; -- comando non valido
            HeX <= "0000";
        END IF;

    END PROCESS;

END ARCHITECTURE;