LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Top Level generatore di eco
-------------------------------------------------

ENTITY ECHO IS
	PORT (
		Clock, Reset, ValidIn : IN STD_LOGIC;
		Command : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		ConverterIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		Din : IN sfixed(-1 DOWNTO -8);
		ValidOut : OUT STD_LOGIC;
		Dout : OUT sfixed(-1 DOWNTO -8)
	);
END ECHO;

ARCHITECTURE Behavior OF ECHO IS

	COMPONENT CU_ECO IS
		PORT (
			Clock, Reset, ValidIn, TcAddrCnt : IN STD_LOGIC;
			EnReg1, ClrReg1, EnAddrCnt, ClrAddrCnt, MemREn, MemWEn, ClrReg2, EnReg2, ValidOut, ClrRegDelay, ClrRegDecay, ClrRegMix : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT DP_ECO IS
		PORT (
			Clock, EnReg1, ClrReg1, EnAddrCnt, ClrAddrCnt, MemREn, MemWEn, EnReg2, ClrReg2, ClrRegDelay, ClrRegDecay, ClrRegMix : IN STD_LOGIC;
			Command : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Din : IN sfixed(-1 DOWNTO -8);
			ConverterIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			TcAddrCnt : OUT STD_LOGIC;
			Dout : OUT sfixed(-1 DOWNTO -8)
		);
	END COMPONENT;

	SIGNAL TcAddrCnt_i, EnReg1_i, ClrReg1_i, EnAddrCnt_i, ClrAddrCnt_i, MemREn_i, MemWEn_i, ClrReg2_i, EnReg2_i, ClrRegDelay_i, ClrRegDecay_i, ClrRegMix_i : STD_LOGIC;

BEGIN

	DP : DP_ECO PORT MAP(
		Clock => Clock, EnReg1 => EnReg1_i, ClrReg1 => ClrReg1_i, EnAddrCnt => EnAddrCnt_i,
		ClrAddrCnt => ClrAddrCnt_i, MemREn => MemREn_i, MemWEn => MemWEn_i, EnReg2 => EnReg2_i,
		ClrReg2 => ClrReg2_i, Command => Command, Din => Din, ConverterIn => ConverterIn,
		TcAddrCnt => TcAddrCnt_i, Dout => Dout, ClrRegDelay => ClrRegDelay_i, ClrRegDecay => ClrRegDecay_i, ClrRegMix => ClrRegMix_i);

	CU : CU_ECO PORT MAP(
		Clock => Clock, Reset => Reset, ValidIn => ValidIn, TcAddrCnt => TcAddrCnt_i, EnReg1 => EnReg1_i,
		ClrReg1 => ClrReg1_i, EnAddrCnt => EnAddrCnt_i, ClrAddrCnt => ClrAddrCnt_i, MemREn => MemREn_i,
		MemWEn => MemWEn_i, ClrReg2 => ClrReg2_i, EnReg2 => EnReg2_i, ValidOut => ValidOut, ClrRegDelay => ClrRegDelay_i, ClrRegDecay => ClrRegDecay_i, ClrRegMix => ClrRegMix_i);

END ARCHITECTURE;