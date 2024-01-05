LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Datapath generatore di eco
-------------------------------------------------

ENTITY DP_ECO IS
	PORT (
		Clock, EnReg1, ClrReg1, EnAddrCnt, ClrAddrCnt, MemREn, MemWEn, EnReg2, ClrReg2, ClrRegDelay, ClrRegDecay, ClrRegMix : IN STD_LOGIC;
		Command : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Din : IN sfixed(-1 DOWNTO -8);
		ConverterIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		TcAddrCnt : OUT STD_LOGIC;
		Dout : OUT sfixed(-1 DOWNTO -8)
	);
END DP_ECO;

ARCHITECTURE Behavior OF DP_ECO IS

	COMPONENT REG IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			Clock, Clear, Enable : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT MEMORY IS
		GENERIC (
			N : INTEGER := 9;      --Numero bit
			M : INTEGER := 44100); --Numero di word
		PORT (
			Din : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			AddR, AddW : IN UNSIGNED(INTEGER(ceil(log2(real(M)))) - 1 DOWNTO 0);
			Clock, REn, WEn : IN STD_LOGIC;
			Dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
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

	COMPONENT MUX4to1_Nbit IS
		GENERIC (N : INTEGER := 1); --Numero di bit
		PORT (
			X, Y, Z, W : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			M : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ADDER IS
		GENERIC (N : INTEGER := 9);
		PORT (
			A, B : IN sfixed(-1 DOWNTO -N);
			Y : OUT sfixed(0 DOWNTO -N)
		);
	END COMPONENT;

	COMPONENT ADDER_U IS
		GENERIC (N : INTEGER := 9);
		PORT (
			A, B : IN UNSIGNED(N - 1 DOWNTO 0);
			Y : OUT UNSIGNED(N - 1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT SUBTRACTOR IS
		GENERIC (N : INTEGER := 9);
		PORT (
			A, B : IN UNSIGNED(N - 1 DOWNTO 0);
			Y : OUT UNSIGNED(N DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT MULTIPLIER IS
		GENERIC (N : INTEGER := 9);
		PORT (
			A, B : IN sfixed(-1 DOWNTO -N);
			Y : OUT sfixed(-1 DOWNTO - (2 * N))
		);
	END COMPONENT;

	COMPONENT COMPARATOR_GENERIC_VALUE IS
		GENERIC (M : INTEGER := 8); --Soglia
		PORT (
			Din : IN UNSIGNED(15 DOWNTO 0);
			Greater : OUT STD_LOGIC
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

	SIGNAL Input_Reg_out, Sat2_out : sfixed(-1 DOWNTO -8); --Uscite registro di ingresso e saturatore di uscita
	SIGNAL Add1_out, Add2_out : sfixed(0 DOWNTO -12); --Uscite sommatori signed fixed
	SIGNAL Sat1, Sat2, Sel_Delay_Mux : STD_LOGIC_VECTOR(1 DOWNTO 0); --Selettori mux a quattro ingressi
	SIGNAL Mem_in, Mem_out : sfixed(-1 DOWNTO -12); --Segnali di i/o memoria
	SIGNAL Decay, Mix : ufixed(-1 DOWNTO -8); --Uscite registri decay e mix
	SIGNAL Write_Address, Delay, Delay_Mux_out : UNSIGNED(15 DOWNTO 0);
	SIGNAL Add_tmp, Addrerss_Mux_out, Read_Address : UNSIGNED(16 DOWNTO 0);
	SIGNAL Decay_Mult_out, Mix_Mult_out : sfixed(-1 DOWNTO -24); --Uscite moltiplicatori
	SIGNAL En_Reg_Delay, En_Reg_Mix, En_Reg_Decay : STD_LOGIC; --Enable registri parametri eco
	SIGNAL Delay_OOR : STD_LOGIC; --Segnale di delay out o range (attivo se (delay > 44100) o se (delay < 0))

	--Segnali usati per estendere i valori
	SIGNAL Extended_Input, Extended_Decay, Extended_Mix : sfixed(-1 DOWNTO -12);

	--Segnali temporanei usati per i componenti standard logic
	SIGNAL Input_Reg_out_slv, Decay_slv, Mix_slv, Dout_slv, Sat2_out_slv : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Mem_out_slv, Mem_in_slv : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN

	--Enable dei contatori per campionare le variabili ricevute
	En_Reg_Delay <= (NOT Command(1)) AND Command(0);
	En_Reg_Mix <= Command(1) AND (NOT Command(0));
	En_Reg_Decay <= Command(1) AND Command(0);

	--Registro di input
	INPUT_REGISTER : REG GENERIC MAP(N => 8)
	PORT MAP(R => to_slv(Din), Clock => Clock, Clear => ClrReg1, Enable => EnReg1, Q => Input_Reg_out_slv);
	Input_Reg_out <= to_sfixed(Input_Reg_out_slv, Input_Reg_out);

	--Registro contenente il valore di delay
	DELAY_REGISTER : REG GENERIC MAP(N => 16)
	PORT MAP(R => ConverterIn, Clock => Clock, Clear => ClrRegDelay, Enable => En_Reg_Delay, UNSIGNED(Q) => Delay);

	--Registro contenente il valore di decay
	DECAY_REGISTER : REG GENERIC MAP(N => 8)
	PORT MAP(R => ConverterIn(7 DOWNTO 0), Clock => Clock, Clear => ClrRegDecay, Enable => En_Reg_Decay, Q => Decay_slv);
	Decay <= to_ufixed(Decay_slv, Decay);

	--Registro contenente il valore di mix
	MIX_REGISTER : REG GENERIC MAP(N => 8)
	PORT MAP(R => ConverterIn(7 DOWNTO 0), Clock => Clock, Clear => ClrRegMix, Enable => En_Reg_Mix, Q => Mix_slv);
	Mix <= to_ufixed(Mix_slv, Mix);

	--Registro di output
	OUTPUT_REGISTER : REG GENERIC MAP(N => 8)
	PORT MAP(R => to_slv(Sat2_out), Clock => Clock, Clear => ClrReg2, Enable => EnReg2, Q => Dout_slv);

	--Memoria usata come buffer circolare
	MEM : MEMORY GENERIC MAP(N => 12, M => 44100)
	PORT MAP(Din => to_slv(Mem_in), AddR => Read_Address(15 DOWNTO 0), AddW => Write_Address, Clock => Clock, REn => MemREn, WEn => MemWEn, Dout => Mem_out_slv);
	Mem_out <= to_sfixed(Mem_out_slv, Mem_out);

	--Verifica correttezza delay impostato (0 < DELAY < 44100)
	--Comparatore per verificare se il valore di delay sia maggiore della dimensione della memoria
	DELAY_COMPARATOR : COMPARATOR_GENERIC_VALUE GENERIC MAP(M => 44100)
	PORT MAP(Din => Delay, Greater => Sel_Delay_Mux(0));
	--Formula logica per verificare se il valore di delay è nullo
	Sel_Delay_Mux(1) <= NOT(Delay(0) OR Delay(1) OR Delay(2) OR Delay(3) OR Delay(4) OR Delay(5) OR Delay(6) OR Delay(7) OR Delay(8) OR Delay(9) OR Delay(10) OR Delay(11) OR Delay(12) OR Delay(13) OR Delay(14) OR Delay(15));
	--Multiplexer per correggere l'indirizzo di lettura (se delay > di indirizzo scrittura)
	MUX_1 : MUX2to1_Nbit GENERIC MAP(N => 17)
	PORT MAP(X => "00000000000000000", Y => "01010110001000100", S => Add_tmp(16), unsigned(M) => Addrerss_Mux_out);

	--Multiplexer per avere valore di delay accettabile
	MUX_2 : MUX4to1_Nbit GENERIC MAP(N => 16)
	PORT MAP(
		X => STD_LOGIC_VECTOR(Delay), Y => "0000000000000000",
		Z => "0000000000000001", W => STD_LOGIC_VECTOR(Delay), S => Sel_Delay_Mux, unsigned(M) => Delay_Mux_out);

	--Saturazione del valore in ingresso della memoria
	Sat1(1) <= Add1_out(0) XNOR Add1_out(-1);
	Sat1(0) <= Add1_out(0);
	MUX_3 : MUX4to1_Nbit GENERIC MAP(N => 12)
	PORT MAP(
		X => "011111111111", Y => "100000000000",
		Z => to_slv(Add1_out(-1 DOWNTO -12)), W => to_slv(Add1_out(-1 DOWNTO -12)), S => Sat1, M => Mem_in_slv);
	Mem_in <= to_sfixed(Mem_in_slv, Mem_in);

	--Saturazione del valore in uscita (Satura se Sat(1) = 0, Sat(0) indica il segno della saturazione)
	Sat2(1) <= (Add2_out(0) XNOR Add2_out(-1)) AND (Add2_out(-1) XNOR Add2_out(-2)) AND (Add2_out(-2) XNOR Add2_out(-3)) AND (Add2_out(-3) XNOR Add2_out(-4));
	Sat2(0) <= Add2_out(0);
	MUX_4 : MUX4to1_Nbit GENERIC MAP(N => 8)
	PORT MAP(
		X => "01111111", Y => "10000000",
		Z => to_slv(Add2_out(-4 DOWNTO -11)), W => to_slv(Add2_out(-4 DOWNTO -11)), S => Sat2, M => Sat2_out_slv);
	Sat2_out <= to_sfixed(Sat2_out_slv, Sat2_out);

	--Somma tra ingresso e (OUT_MEMORIA * DECAY)
	Extended_Input <= Input_Reg_out(-1) & Input_Reg_out(-1) & Input_Reg_out(-1) & Input_Reg_out & '0';
	ADDER1 : ADDER GENERIC MAP(N => 12)
	PORT MAP(A => Extended_Input, B => Decay_Mult_out(-4 DOWNTO -15), Y => Add1_out);

	--Somma tra ingresso e (OUT_MEMORIA * MIX)
	ADDER2 : ADDER GENERIC MAP(N => 12)
	PORT MAP(A => Extended_Input, B => Mix_Mult_out(-4 DOWNTO -15), Y => Add2_out);

	--Sommatore per correggere l'indirizzo di lettura (se delay > di indirizzo scrittura)
	ADDRESS_ADDER : ADDER_U GENERIC MAP(N => 17)
	PORT MAP(A => Add_tmp, B => Addrerss_Mux_out, Y => Read_Address);

	--Sottrattore per calcolare indirizzo di lettura
	ADDRESS_SUBTRACTOR : SUBTRACTOR GENERIC MAP(N => 16)
	PORT MAP(A => Write_Address, B => Delay_Mux_out, Y => Add_tmp);

	--Moltiplicazione tra uscita della memoria e decay
	Extended_Decay <= sfixed("000" & Decay & '0');
	DECAY_MULT : MULTIPLIER GENERIC MAP(N => 12)
	PORT MAP(A => Extended_Decay, B => Mem_out, Y => Decay_Mult_out);

	--Moltiplicazione tra uscita della memoria e mix
	Extended_Mix <= sfixed("000" & Mix & '0');
	MIX_MULT : MULTIPLIER GENERIC MAP(N => 12)
	PORT MAP(A => Extended_Mix, B => Mem_out, Y => Mix_Mult_out);

	--Contatore dell'indirizzo di scrittura
	ADDRESS_COUNTER : CNT GENERIC MAP(M => 44100)
	PORT MAP(Enable => EnAddrCnt, Clock => Clock, Clear => ClrAddrCnt, Tc => TcAddrCnt, Q => Write_Address);

	Dout <= to_sfixed(Dout_slv, -1, -8); --Assegnazione uscita

END ARCHITECTURE;