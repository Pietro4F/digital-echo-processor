LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

-------------------------------------------------
-- Datapath trasmettitore uart
-------------------------------------------------

ENTITY DP_TX IS
	PORT (
		Clock, RegLe, ShLe, ShSe, CntClr, CntCe, One : IN STD_LOGIC;
		Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CntTc, Tx : OUT STD_LOGIC
	);
END DP_TX;

ARCHITECTURE Behavior OF DP_TX IS

	COMPONENT REG IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			Clock, Clear, Enable : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT PISO IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			Clock, Clear, Load, Shift : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT CNT IS
		GENERIC (M : INTEGER := 1040); --Valore di terminal count
		PORT (
			Enable, Clock, Clear : IN STD_LOGIC;
			Tc : OUT STD_LOGIC;
			Q : BUFFER UNSIGNED(INTEGER(ceil(log2(real(M)))) - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL RegQ : STD_LOGIC_VECTOR(7 DOWNTO 0); --Segnale di collegamento tra registro di pipe e shift register
	SIGNAL ShQ : STD_LOGIC; --Uscita sequenziale dello shift register

BEGIN

	--Registro di input
	PIPE_REGISTER : REG GENERIC MAP(N => 8)
	PORT MAP(R => Din, Clock => Clock, Clear => '0', Enable => RegLe, Q => RegQ);

	--Registro di uscita
	SHIFT_REGISTER : PISO GENERIC MAP(N => 9)
	PORT MAP(
		R(0) => '0', R(8 DOWNTO 1) => RegQ, Clock => Clock,
		Clear => '0', Load => ShLe, Shift => ShSe, Q => ShQ);

	--Contatore del tempo di bit
	COUNTER : CNT GENERIC MAP(M => 1040)
	PORT MAP(Enable => CntCe, Clock => Clock, Clear => CntClr, TC => CntTc);

	Tx <= ShQ OR One; --Or tra uscita sequenziale e segnale usato per portare ad uno la linea in condizione di idle

END ARCHITECTURE;