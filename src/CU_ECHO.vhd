LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Control Unit generatore di eco
-------------------------------------------------

ENTITY CU_ECO IS
	PORT (
		Clock, Reset, ValidIn, TcAddrCnt : IN STD_LOGIC;
		EnReg1, ClrReg1, EnAddrCnt, ClrAddrCnt, MemREn, MemWEn, ClrReg2, EnReg2, ValidOut, ClrRegDelay, ClrRegDecay, ClrRegMix : OUT STD_LOGIC
	);
END CU_ECO;

ARCHITECTURE Behaviuor OF CU_ECO IS

	--Definizione di un tipo di segnale che rappresenta i possibili stati della macchina
	TYPE STATE IS (RESET_S, IDLE, READ_MEM, UPDATE_OUT, VALID, RESET_CNT);

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
	State_transition : PROCESS (PresentState, ValidIn, TcAddrCnt)
	BEGIN

		CASE PresentState IS

			WHEN RESET_S => --Stato di reset
				NextState <= IDLE;

			WHEN IDLE => --Stato di idle (campionamento ingresso)
				IF (ValidIn = '1') THEN --Se ricevuto campione di ingresso valido
					NextState <= READ_MEM;
				ELSE
					NextState <= PresentState;
				END IF;

			WHEN READ_MEM => --Lettura memoria
				NextState <= UPDATE_OUT;

			WHEN UPDATE_OUT => --Scrittura memorie e campionamento output
				NextState <= VALID;

			WHEN VALID => --Segnalazione output valido
				IF (TcAddrCnt = '1') THEN --Se terminal count contatore indirizzi attivo
					NextState <= RESET_CNT;
				ELSE
					NextState <= IDLE;
				END IF;

			WHEN RESET_CNT => --reset contatore indirizzi
				NextState <= IDLE;

			WHEN OTHERS => NextState <= RESET_S;

		END CASE;

	END PROCESS;

	--Process che gestice l'output di ogni stato
	Output_process : PROCESS (PresentState)
	BEGIN

		CASE PresentState IS

			WHEN RESET_S =>
				EnReg1 <= '0';
				ClrReg1 <= '1';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '1';
				MemREn <= '0';
				MemWEn <= '0';
				ClrReg2 <= '1';
				EnReg2 <= '0';
				ValidOut <= '0';
				ClrRegDelay <= '1';
				ClrRegDecay <= '1';
				ClrRegMix <= '1';

			WHEN IDLE =>
				EnReg1 <= '1';
				ClrReg1 <= '0';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '0';
				MemREn <= '0';
				MemWEn <= '0';
				ClrReg2 <= '0';
				EnReg2 <= '0';
				ValidOut <= '0';
				ClrRegDelay <= '0';
				ClrRegDecay <= '0';
				ClrRegMix <= '0';

			WHEN READ_MEM =>
				EnReg1 <= '0';
				ClrReg1 <= '0';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '0';
				MemREn <= '1';
				MemWEn <= '0';
				ClrReg2 <= '0';
				EnReg2 <= '0';
				ValidOut <= '0';
				ClrRegDelay <= '0';
				ClrRegDecay <= '0';
				ClrRegMix <= '0';

			WHEN UPDATE_OUT =>
				EnReg1 <= '0';
				ClrReg1 <= '0';
				EnAddrCnt <= '1';
				ClrAddrCnt <= '0';
				MemREn <= '0';
				MemWEn <= '1';
				ClrReg2 <= '0';
				EnReg2 <= '1';
				ValidOut <= '0';
				ClrRegDelay <= '0';
				ClrRegDecay <= '0';
				ClrRegMix <= '0';

			WHEN VALID =>
				EnReg1 <= '0';
				ClrReg1 <= '0';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '0';
				MemREn <= '0';
				MemWEn <= '0';
				ClrReg2 <= '0';
				EnReg2 <= '0';
				ValidOut <= '1';
				ClrRegDelay <= '0';
				ClrRegDecay <= '0';
				ClrRegMix <= '0';

			WHEN RESET_CNT =>
				EnReg1 <= '0';
				ClrReg1 <= '0';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '1';
				MemREn <= '0';
				MemWEn <= '0';
				ClrReg2 <= '0';
				EnReg2 <= '0';
				ValidOut <= '0';
				ClrRegDelay <= '0';
				ClrRegDecay <= '0';
				ClrRegMix <= '0';

			WHEN OTHERS =>
				EnReg1 <= '0';
				ClrReg1 <= '1';
				EnAddrCnt <= '0';
				ClrAddrCnt <= '1';
				MemREn <= '0';
				MemWEn <= '0';
				ClrReg2 <= '1';
				EnReg2 <= '0';
				ValidOut <= '0';
				ClrRegDelay <= '1';
				ClrRegDecay <= '1';
				ClrRegMix <= '1';

		END CASE;

	END PROCESS;

END ARCHITECTURE;