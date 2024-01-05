LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CU_CONV IS
    PORT (
        Clock, Reset, Dir, Valid : IN STD_LOGIC;
        Val : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Enable, Load, Clear : OUT STD_LOGIC;
        Command : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END CU_CONV;

ARCHITECTURE Behaviuor OF CU_CONV IS

    --Definizione di un tipo di segnale che rappresenta i possibili stati della macchina
    TYPE STATE IS (RESET_S, IDLE, LOAD0, LOAD1, T, TA, T01, T1, TB, T02, T2, TC, T03, T3, TD, T04, TOUT,
        G, GA, G01, G1, GB, G02, GOUT, D, DA, D01, D1, DB, D02, DOUT);

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
    --Process che assegna il valore a next state a partire dagli ingressi e dallo stato corrente
    State_transition : PROCESS (PresentState, Dir, Val, Valid)
    BEGIN

        CASE PresentState IS

            WHEN RESET_S =>
                NextState <= IDLE;

            WHEN IDLE => -- sono in attesa
                IF (Dir = '1') THEN
                    NextState <= LOAD0;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN LOAD0 => -- carico il primo dato
                NextState <= LOAD1;

            WHEN LOAD1 => -- capisco di quale comando si tratti
                IF (Val = "01") THEN
                    NextState <= T;
                ELSIF (Val = "10") THEN
                    NextState <= G;
                ELSIF (Val = "11") THEN
                    NextState <= D;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN T => -- resto in attesa di un nuvo comando
                IF (Dir = '1') THEN
                    NextState <= TA;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN TA => -- controllo che il dato ricevuto sia corretto
                IF (Valid = '1') THEN
                    NextState <= T01;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN T01 => -- carico il dato nella fifo
                NextState <= T1;

            WHEN T1 =>
                IF (Dir = '1') THEN
                    NextState <= TB;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN TB =>
                IF (Valid = '1') THEN
                    NextState <= T02;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN T02 =>
                NextState <= T2;

            WHEN T2 =>
                IF (Dir = '1') THEN
                    NextState <= TC;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN TC =>
                IF (Valid = '1') THEN
                    NextState <= T03;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN T03 =>
                NextState <= T3;

            WHEN T3 =>
                IF (Dir = '1') THEN
                    NextState <= TD;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN TD =>
                IF (Valid = '1') THEN
                    NextState <= T04;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN T04 =>
                NextState <= TOUT;

            WHEN TOUT =>
                NextState <= IDLE;

            WHEN G =>
                IF (Dir = '1') THEN
                    NextState <= GA;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN GA =>
                IF (Valid = '1') THEN
                    NextState <= G01;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN G01 =>
                NextState <= G1;

            WHEN G1 =>
                IF (Dir = '1') THEN
                    NextState <= GB;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN GB =>
                IF (Valid = '1') THEN
                    NextState <= G02;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN G02 =>
                NextState <= GOUT;

            WHEN GOUT =>
                NextState <= IDLE;

            WHEN D =>
                IF (Dir = '1') THEN
                    NextState <= DA;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN DA =>
                IF (Valid = '1') THEN
                    NextState <= D01;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN D01 =>
                NextState <= D1;

            WHEN D1 =>
                IF (Dir = '1') THEN
                    NextState <= DB;
                ELSE
                    NextState <= PresentState;
                END IF;

            WHEN DB =>
                IF (Valid = '1') THEN
                    NextState <= D02;
                ELSE
                    NextState <= RESET_S;
                END IF;

            WHEN D02 =>
                NextState <= DOUT;

            WHEN DOUT =>
                NextState <= IDLE;

            WHEN OTHERS => NextState <= RESET_S;

        END CASE;

    END PROCESS;

    --Process che gestice l'output di ogni stato
    Output_process : PROCESS (PresentState)
    BEGIN

        CASE PresentState IS

            WHEN RESET_S => -- resetto i registri
                Enable <= '0';
                Load <= '0';
                Clear <= '1';
                Command <= "00";

            WHEN IDLE | LOAD1 => -- sono in attesa non faccio nulla
                Enable <= '0';
                Load <= '0';
                Clear <= '0';
                Command <= "00";

            WHEN TA | TB | TC | TD | DA | DB | GA | GB => -- controllo che il dato ricevuto sia corretto
                Enable <= '0';
                Load <= '0';
                Clear <= '0';
                Command <= "00";

            WHEN T01 | T02 | T03 | T04 | D01 | D02 | G01 | G02 => --salvo il dato nella memoria FIFO
                Enable <= '0';
                Load <= '1';
                Clear <= '0';
                Command <= "00";

            WHEN LOAD0 | T | T1 | T2 | T3 | D | D1 | G | G1 => --sono in attesa di un Dir, il numero indica quanti dati ho già salvato
                Enable <= '1';
                Load <= '0';
                Clear <= '0';
                Command <= "00";

            WHEN TOUT => -- trametto il delay
                Enable <= '0';
                Load <= '0';
                Clear <= '0';
                Command <= "01";

            WHEN GOUT => -- trasmetto il gain
                Enable <= '0';
                Load <= '0';
                Clear <= '0';
                Command <= "10";

            WHEN DOUT => -- trasmetto il decay
                Enable <= '0';
                Load <= '0';
                Clear <= '0';
                Command <= "11";

            WHEN OTHERS =>
                Enable <= '0';
                Load <= '0';
                Clear <= '1';
                Command <= "00";

        END CASE;

    END PROCESS;

END ARCHITECTURE;