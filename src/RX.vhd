LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Ricevitore uart
-------------------------------------------------

ENTITY RX IS
    PORT (
        Clock, Reset, Rx : IN STD_LOGIC;
        Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Dr : OUT STD_LOGIC
    );
END RX;

ARCHITECTURE arch OF RX IS

    COMPONENT CU_RX IS
        PORT (
            Clock, Start, Reset, Vot, TcS, Tc8, TcW : IN STD_LOGIC;
            Cnt8Clr, CntSClr, CntWClr, CntSMod, Dr, SpLe, Sp2Le, CntSE, CntWE : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT DP_RX IS
        PORT (
            Clock, Rx, Cnt8Clr, CntSClr, CntWClr, CntSMod, SpLe, Sp2Le, CntSE, CntWE : IN STD_LOGIC;
            Vot : BUFFER STD_LOGIC;
            Start, TcS, Tc8, TcW : OUT STD_LOGIC;
            Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    --Segnali interni di collegamento tra Datapath e Control Unit
    SIGNAL Cnt8Clr_i, CntSClr_i, CntWClr_i, CntSMod_i, SpLe_i, Sp2Le_i, CntSE_i, CntWE_i, Start_i, Vot_i, TcS_i, Tc8_i, TcW_i : STD_LOGIC;

BEGIN

    CONTROL_UNIT : CU_RX PORT MAP(
        Clock => Clock, Start => Start_i, Reset => Reset, Vot => Vot_i, TcS => TcS_i, Tc8 => Tc8_i, TcW => TcW_i, Cnt8Clr => Cnt8Clr_i,
        CntSClr => CntSClr_i, CntWClr => CntWClr_i, CntSMod => CntSMod_i, Dr => Dr, SpLe => SpLe_i, Sp2Le => Sp2Le_i, CntSE => CntSE_i, CntWE => CntWE_i);

    DATAPATH : DP_RX PORT MAP(
        Clock => Clock, Rx => Rx, Cnt8Clr => Cnt8Clr_i, CntSClr => CntSClr_i, CntWClr => CntWClr_i, CntSMod => CntSMod_i,
        SpLe => SpLe_i, Sp2Le => Sp2Le_i, CntSE => CntSE_i, CntWE => CntWE_i, Start => Start_i, Vot => Vot_i, TcS => TcS_i, Tc8 => Tc8_i, TcW => TcW_i, Dout => Dout);

END ARCHITECTURE;