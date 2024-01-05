LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Control Unit trasmettitore uart
-------------------------------------------------

ENTITY CU_TX IS
	PORT (
		Clock, Reset, Te, CntTc : IN STD_LOGIC;
		RegLe, ShLe, ShSe, CntClr, CntCe, One : OUT STD_LOGIC
	);
END CU_TX;

ARCHITECTURE Behavior OF CU_TX IS

	--Definizione di un tipo di segnale che rappresenta i possibili stati della macchina
	TYPE STATE IS (RESET_S, IDLE, LOAD, TX0, SHIFT0, TX1, SHIFT1, TX2, SHIFT2, TX3, SHIFT3, TX4, SHIFT4, TX5, SHIFT5,
		TX6, SHIFT6, TX7, SHIFT7, TX8, SHIFT8, TX9);

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
	State_transition : PROCESS (PresentState, Te, CntTc)
	BEGIN

		CASE PresentState IS

			WHEN RESET_S =>
				NextState <= IDLE;

			WHEN IDLE =>
				IF (Te = '1') THEN
					NextState <= LOAD;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN LOAD =>
				NextState <= TX0;

			WHEN TX0 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT0;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT0 =>
				NextState <= TX1;

			WHEN TX1 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT1;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT1 =>
				NextState <= TX2;

			WHEN TX2 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT2;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT2 =>
				NextState <= TX3;

			WHEN TX3 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT3;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT3 =>
				NextState <= TX4;

			WHEN TX4 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT4;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT4 =>
				NextState <= TX5;

			WHEN TX5 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT5;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT5 =>
				NextState <= TX6;

			WHEN TX6 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT6;
				ELSE
					NextState <= PresentState;
				END IF;
			WHEN SHIFT6 =>
				NextState <= TX7;

			WHEN TX7 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT7;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT7 =>
				NextState <= TX8;

			WHEN TX8 =>
				IF (CntTc = '1') THEN
					NextState <= SHIFT8;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN SHIFT8 =>
				NextState <= TX9;

			WHEN TX9 =>
				IF (CntTc = '1') THEN
					NextState <= IDLE;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN OTHERS => NextState <= RESET_S;

		END CASE;

	END PROCESS;

	--Process che gestice l'output di ogni stato
	Output_process : PROCESS (PresentState)
	BEGIN

		CASE PresentState IS

			WHEN RESET_S =>
				RegLe <= '0';
				ShLe <= '0';
				ShSe <= '0';
				CntCe <= '0';
				CntClr <= '1';
				One <= '0';

			WHEN IDLE =>
				RegLe <= '1';
				ShLe <= '0';
				ShSe <= '0';
				CntCe <= '0';
				CntClr <= '0';
				One <= '1';

			WHEN LOAD =>
				RegLe <= '0';
				ShLe <= '1';
				ShSe <= '0';
				CntCe <= '0';
				CntClr <= '1';
				One <= '1';

			WHEN TX0 | TX1 | TX2 | TX3 | TX4 | TX5 | TX6 | TX7 | TX8 =>
				RegLe <= '0';
				ShLe <= '0';
				ShSe <= '0';
				CntCe <= '1';
				CntClr <= '0';
				One <= '0';

			WHEN SHIFT0 | SHIFT1 | SHIFT2 | SHIFT3 | SHIFT4 | SHIFT5 | SHIFT6 | SHIFT7 | SHIFT8 =>
				RegLe <= '0';
				ShLe <= '0';
				ShSe <= '1';
				CntCe <= '1';
				CntClr <= '1';
				One <= '0';

			WHEN TX9 =>
				RegLe <= '0';
				ShLe <= '0';
				ShSe <= '0';
				CntCe <= '1';
				CntClr <= '0';
				One <= '1';

			WHEN OTHERS =>
				RegLe <= '0';
				ShLe <= '0';
				ShSe <= '0';
				CntCe <= '0';
				CntClr <= '1';
				One <= '0';

		END CASE;

	END PROCESS;

END Behavior;