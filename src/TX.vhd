LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Trasmettitore uart
-------------------------------------------------

ENTITY TX IS
    PORT (
        Clock, Reset, Te : IN STD_LOGIC;
        Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Tx : OUT STD_LOGIC
    );
END TX;

ARCHITECTURE Behavior OF TX IS

    COMPONENT CU_TX IS
        PORT (
            Clock, Reset, Te, CntTc : IN STD_LOGIC;
            RegLe, ShLe, ShSe, CntClr, CntCe, One : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT DP_TX IS
        PORT (
            Clock, RegLe, ShLe, ShSe, CntClr, CntCe, One : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            CntTc, Tx : OUT STD_LOGIC
        );
    END COMPONENT;

    --Segnali interni di collegamento tra Datapath e Control Unit
    SIGNAL RegLe_i, ShLe_i, ShSe_i, CntClr_i, CntCe_i, One_i, CntTc_i : STD_LOGIC;

BEGIN

    CONTROL_UNIT : CU_TX PORT MAP(
        Clock => Clock, Reset => Reset, Te => Te, CntTc => CntTc_i,
        RegLe => RegLe_i, ShLe => ShLe_i, ShSe => ShSe_i, CntClr => CntClr_i, CntCe => CntCe_i, One => One_i);

    DATAPATH : DP_TX PORT MAP(
        Clock => Clock, RegLe => RegLe_i, ShLe => ShLe_i, ShSe => ShSe_i, CntClr => CntClr_i,
        CntCe => CntCe_i, One => One_i, Din => Din, CntTc => CntTc_i, Tx => Tx);

END ARCHITECTURE;