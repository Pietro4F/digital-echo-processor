LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench_conv IS
END testbench_conv;

ARCHITECTURE arch OF testbench_conv IS

    COMPONENT CONV IS
        PORT (
            Clock, Reset, Dir : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Command : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Clock_t : STD_LOGIC := '0';
    SIGNAL Reset_t, Dir_t : STD_LOGIC;
    SIGNAL Din_t : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Dout_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Command_t : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

    Clock_t <= NOT Clock_t AFTER 50 ns;

    test : PROCESS
    BEGIN
        Reset_t <= '0';
        Dir_t <= '0';
        Din_t <= "XXXXXXXX";
        WAIT FOR 100 ns;

	Reset_t <= '1';
	WAIT FOR 500 ns;

        Dir_t <= '1';
        Din_t <= "01010100"; -- T
        WAIT FOR 100 ns;

        Dir_t <= '0';
        WAIT FOR 100 ns;

	Din_t <= "XXXXXXXX";
	WAIT FOR 300 ns;

        Dir_t <= '1';
        Din_t <= "01000001"; -- A
        WAIT FOR 100 ns;

        Dir_t <= '0';
        WAIT FOR 100 ns;

	Din_t <= "XXXXXXXX";
	WAIT FOR 300 ns;

        Dir_t <= '1';
        Din_t <= "01000010"; -- B
        WAIT FOR 100 ns;

        Dir_t <= '0';
        WAIT FOR 100 ns;

	Din_t <= "XXXXXXXX";
	WAIT FOR 300 ns;

        Dir_t <= '1';
        Din_t <= "01000011"; -- C
        WAIT FOR 100 ns;

        Dir_t <= '0';
        WAIT FOR 100 ns;

	Din_t <= "XXXXXXXX";
	WAIT FOR 300 ns;

        Dir_t <= '1';
        Din_t <= "01000100"; -- D
        WAIT FOR 100 ns;

        Dir_t <= '0';
        WAIT FOR 100 ns;

	Din_t <= "XXXXXXXX";
	WAIT FOR 300 ns;

        WAIT;
    END PROCESS;

    DUT : CONV PORT MAP(
        Clock => Clock_t, Reset => Reset_t, Dir => Dir_t,
        Din => Din_t, Dout => Dout_t, Command => Command_t);

END ARCHITECTURE;