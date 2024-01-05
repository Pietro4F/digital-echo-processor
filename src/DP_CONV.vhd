LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Data path convertitore
-------------------------------------------------

ENTITY DP_CONV IS
    PORT (
        Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Clock, Clear, Enable, Load : IN STD_LOGIC;
        Dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Val : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Valid : OUT STD_LOGIC
    );
END DP_CONV;

ARCHITECTURE behaviour OF DP_CONV IS

    COMPONENT REG IS
        GENERIC (N : INTEGER := 8); --Numero di bit
        PORT (
            R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Clock, Clear, Enable : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT COMPARATOR_T IS
        PORT (
            Dato : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Val : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT COMPARATOR_H IS
        PORT (
            Dato : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Hex : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Valid : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT SHIFT_REGISTER IS
        GENERIC (
            W : INTEGER := 4;
            D : INTEGER := 4
        );
        PORT (
            Clock, Clear, Load : IN STD_LOGIC;
            Data_in : IN STD_LOGIC_VECTOR(W - 1 DOWNTO 0);
            Data_out : OUT STD_LOGIC_VECTOR((W * D) - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Letter : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Number : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    REG_IN : REG GENERIC MAP(N => 8)PORT MAP(R => Din, Clock => Clock, Clear => Clear, Enable => Enable, Q => Letter);

    COMP_T : COMPARATOR_T PORT MAP(Dato => Letter, Val => Val);

    COMP_H : COMPARATOR_H PORT MAP(Dato => Letter, Hex => Number, Valid => Valid);

    MEM : SHIFT_REGISTER GENERIC MAP(W => 4, D => 4) PORT MAP
    (Clock => Clock, Clear => Clear, Load => Load, Data_in => Number, Data_out => Dout);

END ARCHITECTURE;