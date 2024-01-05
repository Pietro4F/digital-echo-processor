LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Top Level del CONV
-------------------------------------------------

ENTITY CONV IS
    PORT (
        Clock, Reset, Dir : IN STD_LOGIC;
        Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Command : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END CONV;

ARCHITECTURE rtl OF CONV IS

    COMPONENT DP_CONV IS
        PORT (
            Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Clock, Clear, Enable, Load : IN STD_LOGIC;
            Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Val : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Valid : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT CU_CONV IS
        PORT (
            Clock, Reset, Dir, Valid : IN STD_LOGIC;
            Val : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Enable, Load, Clear : OUT STD_LOGIC;
            Command : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Clear_i, Enable_i, Load_i, Valid_i : STD_LOGIC;
    SIGNAL Val_i : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

    DP : DP_CONV PORT MAP(
        Din => Din, Clock => Clock, Clear => Clear_i, Enable => Enable_i,
        Load => Load_i, Dout => Dout, Val => Val_i, Valid => Valid_i);

    CU : CU_CONV PORT MAP(
        Clock => Clock, Reset => Reset, Dir => Dir, Valid => Valid_i,
        Val => Val_i, Enable => Enable_i, Load => Load_i, Clear => Clear_i, Command => Command);

END ARCHITECTURE;