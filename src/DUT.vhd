LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.fixed_pkg.ALL;

ENTITY dut IS
	PORT (
		-- Main clock input
		clk : IN STD_LOGIC;
		-- Main reset input (active high)
		reset : IN STD_LOGIC;
		-- Input port
		dataIn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		validIn : IN STD_LOGIC;
		-- Output port
		dataOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		validOut : OUT STD_LOGIC;
		-- UART interface (input only)
		confRx : IN STD_LOGIC
	);
END dut;

ARCHITECTURE Behavior OF dut IS

	COMPONENT ECHO_WITH_INTERFACE IS
		PORT (
			Clock, Reset, ValidIn, InRx : IN STD_LOGIC;
			ValidOut, OutTx : OUT STD_LOGIC;
			Din : IN sfixed(-1 DOWNTO -8);
			Dout : OUT sfixed(-1 DOWNTO -8)
		);
	END COMPONENT;

	SIGNAL dataIn_sf, dataOut_sf : sfixed(-1 DOWNTO -8);
	SIGNAL nReset : STD_LOGIC;

BEGIN

	dataIn_sf <= to_sfixed(dataIn, dataIn_sf);
	dataOut <= to_slv(dataOut_sf);
	nReset <= NOT reset;

	DELAY : ECHO_WITH_INTERFACE PORT MAP(
		Clock => clk, Reset => nReset, ValidIn => validIn, InRx => confRx,
		Din => dataIn_sf, ValidOut => validOut, Dout => dataOut_sf);

END ARCHITECTURE;