LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

-------------------------------------------------
-- Generatore di eco con interfaccia per la ricezione
-- dei parametri tramite UART
-------------------------------------------------

ENTITY ECHO_WITH_INTERFACE IS
	PORT (
		Clock, Reset, ValidIn, InRx : IN STD_LOGIC;
		ValidOut, OutTx : OUT STD_LOGIC;
		Din : IN sfixed(-1 DOWNTO -8);
		Dout : OUT sfixed(-1 DOWNTO -8)
	);
END ECHO_WITH_INTERFACE;

ARCHITECTURE Behavior OF ECHO_WITH_INTERFACE IS

	COMPONENT RX IS
		PORT (
			Clock, Reset, Rx : IN STD_LOGIC;
			Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			Dr : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT TX IS
		PORT (
			Clock, Reset, Te : IN STD_LOGIC;
			Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Tx : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT CONV IS
		PORT (
			Clock, Reset, Dir : IN STD_LOGIC;
			Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			Command : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ECHO IS
		PORT (
			Clock, Reset, ValidIn : IN STD_LOGIC;
			Command : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			ConverterIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			Din : IN sfixed(-1 DOWNTO -8);
			ValidOut : OUT STD_LOGIC;
			Dout : OUT sfixed(-1 DOWNTO -8)
		);
	END COMPONENT;

	SIGNAL UartRecive_i : STD_LOGIC;
	SIGNAL Command_i : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL UartData_i : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ConvertedData_i : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	RX_UART : RX PORT MAP(
		Clock => Clock, Reset => Reset, Rx => InRx, Dout => UartData_i, Dr => UartRecive_i);

	TX_UART : TX PORT MAP(
		Clock => Clock, Reset => Reset, Te => UartRecive_i, Din => UartData_i, Tx => OutTx);

	CONVERTER : CONV PORT MAP(
		Clock => Clock, Reset => Reset, Dir => UartRecive_i, Din => UartData_i,
		Dout => ConvertedData_i, Command => Command_i);

	DELAY : ECHO PORT MAP(
		Clock => Clock, Reset => Reset, ValidIn => ValidIn, Command => Command_i, ConverterIn => ConvertedData_i,
		Din => Din, ValidOut => ValidOut, Dout => Dout);

END ARCHITECTURE;