LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY work;
USE work.fixed_pkg.ALL;

ENTITY testbench_ECO IS
END testbench_ECO;

ARCHITECTURE arch OF testbench_ECO IS

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

	SIGNAL Clock_t : STD_LOGIC := '0';
	SIGNAL Reset_t, ValidIn_t, ValidOut_t : STD_LOGIC;
	SIGNAL Command_t : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ConverterIn_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Din_t, Dout_t : sfixed(-1 DOWNTO -8);

BEGIN

	Clock_t <= NOT Clock_t AFTER 50 ns;

	test : PROCESS
	BEGIN
		Reset_t <= '0';
		ValidIn_t <= '0';
		Command_t <= "00";
		ConverterIn_t <= "XXXXXXXXXXXXXXXX";
		Din_t <= "XXXXXXXX";

		WAIT FOR 100 ns;
		Reset_t <= '1';

		WAIT FOR 100 ns;
		Command_t <= "01"; --Delay
		ConverterIn_t <= "0000000000000011";

		WAIT FOR 100 ns;
		Command_t <= "10"; --Mix
		ConverterIn_t <= "0000000001111111";

		WAIT FOR 100 ns;
		Command_t <= "11"; --Decay
		ConverterIn_t <= "0000000001111111";

		WAIT FOR 100 ns;
		Command_t <= "00";
		ConverterIn_t <= "XXXXXXXXXXXXXXXX";
		ValidIn_t <= '1';
		Din_t <= "11111111";

		WAIT FOR 100 ns;
		ValidIn_t <= '0';
		Din_t <= "XXXXXXXX";

		WAIT FOR 400 ns;
		ValidIn_t <= '1';
		Din_t <= "00000000";

		WAIT;
	END PROCESS;

	DUT : ECHO PORT MAP(
		Clock => Clock_t, Reset => Reset_t, ValidIn => ValidIn_t, Command => Command_t, ConverterIn => ConverterIn_t,
		Din => Din_t, ValidOut => ValidOut_t, Dout => Dout_t);

END ARCHITECTURE;