LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

-------------------------------------------------
-- Datapath ricevitore uart
-------------------------------------------------

ENTITY DP_RX IS
	PORT (
		Clock, Rx, Cnt8Clr, CntSClr, CntWClr, CntSMod, SpLe, Sp2Le, CntSE, CntWE : IN STD_LOGIC;
		Vot : BUFFER STD_LOGIC;
		Start, TcS, Tc8, TcW : OUT STD_LOGIC;
		Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END DP_RX;

ARCHITECTURE Behavior OF DP_RX IS

	COMPONENT SIPO IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			R : IN STD_LOGIC;
			Clock, Clear, Load : IN STD_LOGIC;
			Q : BUFFER STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT COMPARATOR IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			A, B : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			Equal : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT VOTER_3BIT IS
		PORT (
			Din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Dout : OUT STD_LOGIC
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

	COMPONENT CNT_SEL IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			Enable, Clock, Clear : IN STD_LOGIC;
			Module : IN UNSIGNED(N - 1 DOWNTO 0);
			Tc : OUT STD_LOGIC;
			Q : BUFFER UNSIGNED(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT MUX2to1_Nbit IS
		GENERIC (N : INTEGER := 1); --Numero di bit
		PORT (
			X, Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			S : IN STD_LOGIC;
			M : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL SP1_Q : STD_LOGIC_VECTOR(7 DOWNTO 0); --Output del registro di input
	SIGNAL Module_S : STD_LOGIC_VECTOR(3 DOWNTO 0); --Uscita multiplexer di selezione del terminal count

BEGIN

	--Contatore con velocità otto volte maggiore del tempo di bit
	COUNTER_8 : CNT GENERIC MAP(M => 128)
	PORT MAP(Enable => '1', Clock => Clock, Clear => Cnt8Clr, TC => Tc8);

	--Contatore del numero di bit ricevuti
	COUNTER_W : CNT GENERIC MAP(M => 9)
	PORT MAP(Enable => CntWE, Clock => Clock, Clear => CntWClr, TC => TcW);

	--Multiplexer per seleione del terminal count contatore di sincronizzazione
	MUX : MUX2to1_Nbit GENERIC MAP(N => 4)
	PORT MAP(X => "1000", Y => "0100", S => CntSMod, M => Module_S);

	--Contatore di sincronizzazione del campionamento
	COUNTER_SYNC : CNT_SEL GENERIC MAP(N => 4)
	PORT MAP(Enable => CntSE, Clock => Clock, Clear => CntSClr, Module => unsigned(Module_S), TC => TcS);

	--Registro di input
	INPUT_REGISTER : SIPO GENERIC MAP(N => 8)
	PORT MAP(R => Rx, Clock => CLock, Clear => '0', Load => SpLe, Q => SP1_Q);

	--Votatore di maggioranza
	VOTER : VOTER_3BIT
	PORT MAP(Din => SP1_Q(5 DOWNTO 3), Dout => Vot);

	--Comparatore per rilevamento del bit di start
	COMPARATORE : COMPARATOR GENERIC MAP(N => 8)
	PORT MAP(A => SP1_Q, B => "00001111", Equal => Start);

	--Registro di uscita
	OUTPUT_REGISTER : SIPO GENERIC MAP(N => 8)
	PORT MAP(R => Vot, Clock => CLock, Clear => '0', Load => Sp2Le, Q => Dout);

END ARCHITECTURE;