LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Control Unit ricevitore uart
-------------------------------------------------

ENTITY CU_RX IS
    PORT (
        Clock, Start, Reset, Vot, TcS, Tc8, TcW : IN STD_LOGIC;
        Cnt8Clr, CntSClr, CntWClr, CntSMod, Dr, SpLe, Sp2Le, CntSE, CntWE : OUT STD_LOGIC
    );
END CU_RX;

ARCHITECTURE Behavior OF CU_RX IS

    --Definizione di un tipo di segnale che rappresenta i possibili stati della macchina
    TYPE STATE IS (RESET_S, IDLE, SHIFT, WAIT_4, SHIFT_4, C_BIT, WAIT_BIT, SHIFT_BIT, WAIT_8, SHIFT_8, RX_OK);

    SIGNAL PresentState, NextState : STATE;

BEGIN

    --Process che gestisce l'evoluzione dallo stato presente allo stato futuro
    State_registers : PROCESS (Clock, Reset)
    BEGIN

        IF (Reset = '0') THEN
            PresentState <= RESET_S;

        ELSE
            IF (Clock = '1' AND Clock'EVENT) THEN
                PresentState <= NextState;

            END IF;
        END IF;
    END PROCESS;

    State_transition : PROCESS (PresentState, Start, TcS, Tc8, TcW, Vot)
    BEGIN

        CASE PresentState IS
            WHEN RESET_S =>
                NextState <= IDLE;

            WHEN IDLE =>
                IF (Start = '1') THEN
                    NextState <= WAIT_4;
                ELSIF (Tc8 = '1') THEN
                    NextState <= Shift;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN SHIFT => --shifto la prima piso
                NextState <= IDLE;

            WHEN WAIT_4 => --centro il bit di start
                IF (Tc8 = '1') THEN
                    NextState <= SHIFT_4;
                ELSIF (TcS = '1') THEN
                    NextState <= C_BIT;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN SHIFT_4 =>
                NextState <= WAIT_4;

            WHEN C_BIT => --shifto la seconda piso
                NextState <= WAIT_BIT;

            WHEN WAIT_BIT => --centro il secondo bit
                IF (Tc8 = '1') THEN -- mi sposto di 1/8
                    NextState <= SHIFT_BIT;
                ELSIF (TcS = '1') THEN -- sono in centro al bit
                    NextState <= C_BIT;
                ELSIF (TcW = '1') THEN --
                    NextState <= WAIT_8;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN SHIFT_BIT => --shifto la prima piso
                NextState <= WAIT_BIT;

            WHEN WAIT_8 => --shifto il bit di end
                IF (Tc8 = '1') THEN
                    NextState <= SHIFT_8;
                ELSIF (TcS = '1') THEN
                    IF (Vot = '1') THEN
                        NextState <= RX_OK;
                    ELSE
                        NextState <= IDLE;
                    END IF;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN SHIFT_8 =>
                NextState <= WAIT_8;

            WHEN RX_OK => --abilito dr
                NextState <= IDLE;

            WHEN OTHERS => NextState <= RESET_S;

        END CASE;

    END PROCESS;

    --Process che gestice l'output di ogni stato
    Output_process : PROCESS (PresentState)
    BEGIN

        CASE PresentState IS

            WHEN RESET_S =>
                Cnt8Clr <= '1';
                CntSClr <= '1';
                CntWClr <= '1';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN IDLE =>
                Cnt8Clr <= '0';
                CntSClr <= '1';
                CntWClr <= '1';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN SHIFT =>
                Cnt8Clr <= '1';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '1';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN WAIT_4 =>
                Cnt8Clr <= '0';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '1';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN SHIFT_4 =>
                Cnt8Clr <= '1';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '1';
                Dr <= '0';
                SpLe <= '1';
                Sp2Le <= '0';
                CntSE <= '1';
                CntWE <= '0';

            WHEN C_BIT =>
                Cnt8Clr <= '0';
                CntSClr <= '1';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '1';
                CntSE <= '0';
                CntWE <= '1';

            WHEN WAIT_BIT =>
                Cnt8Clr <= '0';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN SHIFT_BIT =>
                Cnt8Clr <= '1';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '1';
                Sp2Le <= '0';
                CntSE <= '1';
                CntWE <= '0';

            WHEN WAIT_8 =>
                Cnt8Clr <= '0';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN SHIFT_8 =>
                Cnt8Clr <= '1';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '1';
                Sp2Le <= '0';
                CntSE <= '1';
                CntWE <= '0';

            WHEN RX_OK =>
                Cnt8Clr <= '0';
                CntSClr <= '0';
                CntWClr <= '0';
                CntSMod <= '0';
                Dr <= '1';
                SpLe <= '0';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

            WHEN OTHERS =>
                Cnt8Clr <= '0';
                CntSClr <= '1';
                CntWClr <= '1';
                CntSMod <= '0';
                Dr <= '0';
                SpLe <= '1';
                Sp2Le <= '0';
                CntSE <= '0';
                CntWE <= '0';

        END CASE;

    END PROCESS;

END ARCHITECTURE;