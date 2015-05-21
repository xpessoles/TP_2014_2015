-- VHDL netlist for principal_complet
-- Date: Mon May 09 21:47:55 2011
-- Copyright (c) Lattice Semiconductor Corporation
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGAND2_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGAND2_principal_complet;

ARCHITECTURE behav OF PGAND2_principal_complet IS 
BEGIN

    PROCESS (A1, A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF := A1 AND A0;
        if ZDF ='1' then
            Z0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            Z0 <= transport ZDF after TFALL;
        else
            Z0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGBUFI_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGBUFI_principal_complet;

ARCHITECTURE behav OF PGBUFI_principal_complet IS 
BEGIN

    PROCESS (A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF :=  A0;
        if ZDF ='1' then
            Z0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            Z0 <= transport ZDF after TFALL;
        else
            Z0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGORF72_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGORF72_principal_complet;

ARCHITECTURE behav OF PGORF72_principal_complet IS 
BEGIN

    PROCESS (A1, A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF := A1 OR A0;
        if ZDF ='1' then
            Z0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            Z0 <= transport ZDF after TFALL;
        else
            Z0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGXOR2_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGXOR2_principal_complet;

ARCHITECTURE behav OF PGXOR2_principal_complet IS 
BEGIN

    PROCESS (A1, A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF := A1 XOR A0;
        if ZDF ='1' then
            Z0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            Z0 <= transport ZDF after TFALL;
        else
            Z0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGDFFR_principal_complet IS 
    GENERIC (
        HLCQ : TIME := 1 ns;
        LHCQ : TIME := 1 ns;
        HLRQ : TIME := 1 ns;
        SUD0 : TIME := 0 ns;
        SUD1 : TIME := 0 ns;
        HOLDD0 : TIME := 0 ns;
        HOLDD1 : TIME := 0 ns;
        POSC1 : TIME := 0 ns;
        POSC0 : TIME := 0 ns;
        NEGC1 : TIME := 0 ns;
        NEGC0 : TIME := 0 ns;
        RECRC : TIME := 0 ns;
        HOLDRC : TIME := 0 ns
    );
    PORT (
        RNESET : IN std_logic;
        CD : IN std_logic;
        CLK : IN std_logic;
        D0 : IN std_logic;
        Q0 : OUT std_logic
    );
END PGDFFR_principal_complet;

ARCHITECTURE behav OF PGDFFR_principal_complet IS 
BEGIN

    PROCESS (RNESET, CD, CLK, D0)
	variable iQ0 : std_logic;
	variable pQ0 : std_logic;

	begin

		if (CD OR NOT (RNESET)) = '1' then
			if NOT (iQ0='0') then
			  iQ0 := '0';
			  Q0 <= transport iQ0  after HLRQ;
			end if;
		elsif (CD OR NOT (RNESET)) = '0' AND CLK= '1' AND CLK'EVENT then
			pQ0 := iQ0;
			if (D0'EVENT) then
				iQ0 := D0'LAST_VALUE;
			elsif NOT (D0'EVENT) then
				iQ0 := D0;
			end if;
      if pQ0 = iQ0 then 
         Q0 <= transport iQ0;
      elsif iQ0 = '1' then Q0 <= transport iQ0 after LHCQ;
      elsif iQ0 = '0' then Q0 <= transport iQ0 after HLCQ;
      else
          Q0 <= transport iQ0;
      end if;
		end if;
    END PROCESS;

	process(CLK, CD)
	 begin
		if CD'EVENT AND CD='0' AND CLK='1' then
			assert (CLK'LAST_EVENT >= HOLDRC) 
			report("HOLD TIME VIOLAION ON CD (HOLDRC)  ")
            severity WARNING;
		end if;
		if CLK'EVENT  AND CLK ='1' AND CD ='0' then
			assert ( CD'LAST_EVENT >= RECRC) 
			report("RECOVERY TIME VIOLATION on CD(RECRC) ")
            severity WARNING;
		end if;
	end process;

	process(CLK,RNESET)
	 begin
		if RNESET'EVENT AND NOT(RNESET)='0' AND CLK='1' then
			assert (CLK'LAST_EVENT >= HOLDRC) 
			report("HOLD TIME VIOLAION ON RNESET (HOLDRC)  ")
            severity WARNING;
		end if;
		if CLK'EVENT  AND CLK ='1' AND NOT(RNESET) ='0' then
			assert ( RNESET'LAST_EVENT >= RECRC) 
			report("RECOVERY TIME VIOLATION on RNESET(RECRC) ")
            severity WARNING;
		end if;
	end process;

	process(D0, CLK)

	variable R_EDGE1 : TIME := 0 ns;
	variable R_EDGE0 : TIME := 0 ns;
	variable F_EDGE1 : TIME := 0 ns;
	variable F_EDGE0 : TIME := 0 ns;

	begin
		if CLK='1' AND CLK'LAST_VALUE='0' AND NOT(D0'EVENT) then
		   if D0='1' then
			R_EDGE1 := NOW;
			assert((R_EDGE1-F_EDGE1) >= NEGC1) 
			report("NEGATIVE PULSE WIDTH VIOLATION (NEGC1) ON CLK at ")
            severity WARNING;
			elsif D0='0' then
			 R_EDGE0 := NOW;
			 assert((R_EDGE0-F_EDGE0) >= NEGC0) 
			 report("NEGATIVE PULSE WIDTH VIOLATION (NEGC0) ON CLK at ")
             severity WARNING;
			end if;
		end if;

		if CLK ='0' AND CLK'LAST_VALUE = '1' AND NOT(D0'EVENT) then
			if D0='1' then
			  F_EDGE1 := NOW;
			  assert ((F_EDGE1-R_EDGE1) >= POSC1) 
			  report("POSITIVE PULSE WIDTH VIOLATION (POSC1) ON CLK at ")
              severity WARNING;
			elsif D0='0' then
			  F_EDGE0 := NOW;
			  assert ((F_EDGE0-R_EDGE0) >= POSC0) 
			  report("POSITIVE PULSE WIDTH VIOLATION (POSC0) ON CLK at ")
              severity WARNING;
			end if;
		end if;

	end process;

	process(D0, CLK)

	begin
		if CLK = '1' AND CLK'EVENT then 
			if D0='1' then
               assert(D0'LAST_EVENT >= SUD1) 
 			   report("DATA SET-UP VIOLATION (SUD1) ")
               severity WARNING;
			elsif D0='0' then
               assert(D0'LAST_EVENT >= SUD0) 
 			   report("DATA SET-UP VIOLATION (SUD0) ")
               severity WARNING;
			end if;
		end if;

		if CLK='1' AND D0'EVENT then 
			if D0'LAST_VALUE ='1' then
			   assert(CLK'LAST_EVENT >= HOLDD1)
			   report("DATA HOLD VIOLATION (HOLDD1) ")
               severity WARNING;
			elsif D0'LAST_VALUE='0' then
			   assert(CLK'LAST_EVENT >= HOLDD0)
			   report("DATA HOLD VIOLATION (HOLDD0) ")
               severity WARNING;
			end if;
		end if;

	end process;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGINVI_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A0 : IN std_logic;
        ZN0 : OUT std_logic
    );
END PGINVI_principal_complet;

ARCHITECTURE behav OF PGINVI_principal_complet IS 
BEGIN

    PROCESS (A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF := NOT A0;
        if ZDF ='1' then
            ZN0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            ZN0 <= transport ZDF after TFALL;
        else
            ZN0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PXIN_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        XI0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PXIN_principal_complet;

ARCHITECTURE behav OF PXIN_principal_complet IS 
BEGIN

    PROCESS (XI0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF :=  XI0;
        if ZDF ='1' then
            Z0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            Z0 <= transport ZDF after TFALL;
        else
            Z0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PXOUT_principal_complet IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A0 : IN std_logic;
        XO0 : OUT std_logic
    );
END PXOUT_principal_complet;

ARCHITECTURE behav OF PXOUT_principal_complet IS 
BEGIN

    PROCESS (A0)
    VARIABLE ZDF : std_logic;
    BEGIN
        ZDF :=  A0;
        if ZDF ='1' then
            XO0 <= transport ZDF after TRISE;
        elsif ZDF ='0' then
            XO0 <= transport ZDF after TFALL;
        else
            XO0 <= transport ZDF;
        end if;
    END PROCESS;
END behav;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE work.all;

ENTITY principal_complet IS 
    PORT (
        XRESET : IN std_logic;
        SET : IN std_logic;
        SENS : IN std_logic;
        H : IN std_logic;
        S3 : OUT std_logic;
        S2 : OUT std_logic;
        S1 : OUT std_logic;
        S0 : OUT std_logic;
        PH4 : OUT std_logic;
        PH3 : OUT std_logic;
        PH2 : OUT std_logic;
        PH1 : OUT std_logic;
        LPH4 : OUT std_logic;
        LPH3 : OUT std_logic;
        LPH2 : OUT std_logic;
        LPH1 : OUT std_logic
    );
END principal_complet;


ARCHITECTURE principal_complet_STRUCTURE OF principal_complet IS
SIGNAL VCC : std_logic := '1';
SIGNAL GND : std_logic := '0';
SIGNAL  N_18_ck2f, BUF_736_ck1f, L2L_KEYWD_RESETb, IO24_IBUFO,
	 IO30_IBUFO, HX, IO23_OBUFI, S3_QB_iomux,
	 IO22_OBUFI, S2_PIN_iomux, IO21_OBUFI, S1_PIN_iomux,
	 IO20_OBUFI, S0_PIN_iomux, IO8_OBUFI, OR_749_iomux,
	 IO13_OBUFI, OR_746_iomux, IO12_OBUFI, OR_743_iomux,
	 IO9_OBUFI, OR_740_iomux, IO19_OBUFI, PH4_PIN_iomux,
	 IO18_OBUFI, PH3_PIN_iomux, IO17_OBUFI, PH2_PIN_iomux,
	 IO16_OBUFI, PH1_PIN_iomux, N_45, N_45_D0,
	 A1_CLKP, A1_P4_xa, OR_740, OR_749,
	 A1_G1, A1_F3, A1_F2, A1_P16,
	 A1_P15, N_44_grp, A1_P12, A1_IN10,
	 A1_P11, A1_IN12, A1_IN14B, A1_P10,
	 A1_IN11B, A1_IN14, N_45_ffb, A1_P4,
	 A1_IN16B, N_44, N_44_D0, A6_CLK,
	 HX_clk0, A6_P4_xa, OR_746, OR_743,
	 A6_G1, A6_F3, A6_F2, A6_P16,
	 A6_P15, A6_P11, A6_IN13, A6_IN14,
	 A6_P10, A6_IN10, A6_IN14B, N_44_ffb,
	 A6_P4, A6_IN16B, N_18, N_18_D0,
	 B0_CLK, PH4_PIN, PH3_PIN, B0_P8_xa,
	 B0_P13_xa, BUF_736, B0_X0O, B0_G3,
	 B0_G2, B0_F4, B0_F1, B0_F0,
	 N_45_grp, B0_P13, B0_IN9, N_18_ffb,
	 B0_P12, B0_IN16, B0_P8, B0_P7,
	 B0_IN2, B0_P6, B0_IN5, B0_P3,
	 B0_IN1, B0_IN3, S3_QB_grp, B0_P2,
	 B0_IN1B, B0_IN4B, S3_QB, S2_PIN,
	 S3_QB_D0, S2_PIN_D0, B2_CD, B2_CLK,
	 B2_P0_xa, B2_P4_xa, PH2_PIN, PH1_PIN,
	 B2_G1, B2_G0, B2_F3, B2_F2,
	 B2_P16, B2_IN3, B2_P15, B2_P12,
	 B2_IN7B, S1_PIN_grp, B2_P11, B2_IN1B,
	 B2_IN2, S2_PIN_ffb, SENSX_grp, B2_P10,
	 B2_IN1, B2_IN16, S3_QB_ffb, B2_P4,
	 B2_IN17B, S0_PIN_grp, B2_P0, B2_IN3B,
	 S1_PIN, S0_PIN, L2L_KEYWD_RESET_glbb, S1_PIN_D0,
	 S0_PIN_D0, B3_CD, B3_CLK, B3_P8_xa,
	 B3_P13_xa, B3_G3, B3_G2, S1_PIN_ffb,
	 B3_P13, B3_IN16, SETX_grp, B3_P12,
	 B3_IN7B, S2_PIN_grp, B3_P8, B3_IN5 : std_logic;


  COMPONENT PGAND2_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGAND2_principal_complet use entity work.PGAND2_principal_complet(behav);

  COMPONENT PGBUFI_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGBUFI_principal_complet use entity work.PGBUFI_principal_complet(behav);

  COMPONENT PGORF72_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGORF72_principal_complet use entity work.PGORF72_principal_complet(behav);

  COMPONENT PGXOR2_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGXOR2_principal_complet use entity work.PGXOR2_principal_complet(behav);

  COMPONENT PGDFFR_principal_complet
    GENERIC (HLCQ, LHCQ, HLRQ, SUD0, 
        SUD1, HOLDD0, HOLDD1, POSC1, 
        POSC0, NEGC1, NEGC0, RECRC, 
        HOLDRC : TIME);
    PORT (
        RNESET : IN std_logic;
        CD : IN std_logic;
        CLK : IN std_logic;
        D0 : IN std_logic;
        Q0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGDFFR_principal_complet use entity work.PGDFFR_principal_complet(behav);

  COMPONENT PGINVI_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A0 : IN std_logic;
        ZN0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGINVI_principal_complet use entity work.PGINVI_principal_complet(behav);

  COMPONENT PXIN_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        XI0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PXIN_principal_complet use entity work.PXIN_principal_complet(behav);

  COMPONENT PXOUT_principal_complet
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A0 : IN std_logic;
        XO0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PXOUT_principal_complet use entity work.PXOUT_principal_complet(behav);

BEGIN

GLB_A1_P16 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A1_P16, A1 => A1_IN12, A0 => A1_IN14);
GLB_A1_P15 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A1_P15, A1 => A1_IN11B, A0 => A1_IN14B);
GLB_A1_P12 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => A1_P12, A0 => A1_IN10);
GLB_A1_P11 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A1_P11, A1 => A1_IN12, A0 => A1_IN14B);
GLB_A1_P10 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A1_P10, A1 => A1_IN11B, A0 => A1_IN14);
GLB_A1_P4 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => A1_P4, A0 => A1_IN16B);
GLB_A1_G1 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A1_G1, A0 => GND);
GLB_A1_F3 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A1_F3, A1 => A1_P15, A0 => A1_P16);
GLB_A1_F2 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A1_F2, A1 => A1_P10, A0 => A1_P11);
GLB_A1_CLKP : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 6.600000 ns, TFALL => 6.600000 ns)
	PORT MAP (Z0 => A1_CLKP, A0 => A1_P12);
GLB_A1_P4_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A1_P4_xa, A0 => A1_P4);
GLB_OR_740 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => OR_740, A0 => A1_F2);
GLB_OR_749 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => OR_749, A0 => A1_F3);
GLB_A1_IN10 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A1_IN10, A0 => N_44_grp);
GLB_A1_IN12 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A1_IN12, A0 => S0_PIN_grp);
GLB_A1_IN14 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A1_IN14, A0 => SENSX_grp);
GLB_N_45_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_45_D0, A1 => A1_P4_xa, A0 => A1_G1);
GLB_N_45 : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => N_45, RNESET => L2L_KEYWD_RESET_glbb, CD => GND, CLK => A1_CLKP, 
	D0 => N_45_D0);
GLB_A1_IN14B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => A1_IN14B, A0 => SENSX_grp);
GLB_A1_IN11B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => A1_IN11B, A0 => S3_QB_grp);
GLB_A1_IN16B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => A1_IN16B, A0 => N_45_ffb);
GLB_A6_P16 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A6_P16, A1 => A6_IN13, A0 => A6_IN14B);
GLB_A6_P15 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A6_P15, A1 => A6_IN10, A0 => A6_IN14);
GLB_A6_P11 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A6_P11, A1 => A6_IN13, A0 => A6_IN14);
GLB_A6_P10 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => A6_P10, A1 => A6_IN10, A0 => A6_IN14B);
GLB_A6_P4 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => A6_P4, A0 => A6_IN16B);
GLB_A6_G1 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A6_G1, A0 => GND);
GLB_A6_F3 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A6_F3, A1 => A6_P15, A0 => A6_P16);
GLB_A6_F2 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A6_F2, A1 => A6_P10, A0 => A6_P11);
GLB_A6_CLK : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A6_CLK, A0 => HX_clk0);
GLB_A6_P4_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => A6_P4_xa, A0 => A6_P4);
GLB_OR_746 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => OR_746, A0 => A6_F2);
GLB_OR_743 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => OR_743, A0 => A6_F3);
GLB_A6_IN14 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A6_IN14, A0 => SENSX_grp);
GLB_A6_IN13 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A6_IN13, A0 => S1_PIN_grp);
GLB_A6_IN10 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => A6_IN10, A0 => S2_PIN_grp);
GLB_N_44_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_44_D0, A1 => A6_P4_xa, A0 => A6_G1);
GLB_N_44 : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => N_44, RNESET => L2L_KEYWD_RESET_glbb, CD => GND, CLK => A6_CLK, 
	D0 => N_44_D0);
GLB_A6_IN14B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => A6_IN14B, A0 => SENSX_grp);
GLB_A6_IN16B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => A6_IN16B, A0 => N_44_ffb);
GLB_B0_P13 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B0_P13, A0 => B0_IN9);
GLB_B0_P12 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B0_P12, A0 => B0_IN16);
GLB_B0_P8 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B0_P8, A0 => VCC);
GLB_B0_P7 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B0_P7, A1 => B0_IN1, A0 => B0_IN2);
GLB_B0_P6 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B0_P6, A1 => B0_IN1B, A0 => B0_IN5);
GLB_B0_P3 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B0_P3, A1 => B0_IN1, A0 => B0_IN3);
GLB_B0_P2 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B0_P2, A1 => B0_IN1B, A0 => B0_IN4B);
GLB_B0_G3 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_G3, A0 => GND);
GLB_B0_G2 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_G2, A0 => B0_F4);
GLB_B0_F4 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B0_F4, A0 => B0_P12);
GLB_B0_F1 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B0_F1, A1 => B0_P6, A0 => B0_P7);
GLB_B0_F0 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B0_F0, A1 => B0_P2, A0 => B0_P3);
GLB_B0_CLK : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_CLK, A0 => BUF_736_ck1f);
GLB_PH4_PIN : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => PH4_PIN, A0 => B0_F0);
GLB_PH3_PIN : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => PH3_PIN, A0 => B0_F1);
GLB_B0_P8_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B0_P8_xa, A0 => B0_P8);
GLB_B0_P13_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B0_P13_xa, A0 => B0_P13);
GLB_BUF_736 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => BUF_736, A0 => B0_X0O);
GLB_B0_IN9 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN9, A0 => N_45_grp);
GLB_B0_IN16 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN16, A0 => N_18_ffb);
GLB_B0_IN2 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN2, A0 => S1_PIN_grp);
GLB_B0_IN5 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN5, A0 => S2_PIN_grp);
GLB_B0_IN3 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN3, A0 => S0_PIN_grp);
GLB_B0_IN1 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B0_IN1, A0 => SENSX_grp);
GLB_N_18_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_18_D0, A1 => B0_P8_xa, A0 => B0_G2);
GLB_B0_X0O : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => B0_X0O, A1 => B0_P13_xa, A0 => B0_G3);
GLB_N_18 : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => N_18, RNESET => L2L_KEYWD_RESET_glbb, CD => GND, CLK => B0_CLK, 
	D0 => N_18_D0);
GLB_B0_IN4B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B0_IN4B, A0 => S3_QB_grp);
GLB_B0_IN1B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B0_IN1B, A0 => SENSX_grp);
GLB_B2_P16 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B2_P16, A1 => B2_IN1B, A0 => B2_IN3);
GLB_B2_P15 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B2_P15, A1 => B2_IN1, A0 => B2_IN17B);
GLB_B2_P12 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B2_P12, A0 => B2_IN7B);
GLB_B2_P11 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B2_P11, A1 => B2_IN1B, A0 => B2_IN2);
GLB_B2_P10 : PGAND2_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => B2_P10, A1 => B2_IN1, A0 => B2_IN16);
GLB_B2_P4 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B2_P4, A0 => B2_IN17B);
GLB_B2_P0 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B2_P0, A0 => B2_IN3B);
GLB_B2_G1 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_G1, A0 => GND);
GLB_B2_G0 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_G0, A0 => GND);
GLB_B2_F3 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B2_F3, A1 => B2_P15, A0 => B2_P16);
GLB_B2_F2 : PGORF72_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B2_F2, A1 => B2_P10, A0 => B2_P11);
GLB_B2_CD : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 8.700000 ns, TFALL => 8.700000 ns)
	PORT MAP (Z0 => B2_CD, A0 => B2_P12);
GLB_B2_CLK : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_CLK, A0 => N_18_ck2f);
GLB_B2_P0_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B2_P0_xa, A0 => B2_P0);
GLB_B2_P4_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B2_P4_xa, A0 => B2_P4);
GLB_PH2_PIN : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => PH2_PIN, A0 => B2_F2);
GLB_PH1_PIN : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => PH1_PIN, A0 => B2_F3);
GLB_B2_IN3 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_IN3, A0 => S0_PIN_grp);
GLB_B2_IN2 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_IN2, A0 => S1_PIN_grp);
GLB_B2_IN16 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_IN16, A0 => S2_PIN_ffb);
GLB_B2_IN1 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B2_IN1, A0 => SENSX_grp);
GLB_S3_QB_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S3_QB_D0, A1 => B2_P0_xa, A0 => B2_G0);
GLB_S2_PIN_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S2_PIN_D0, A1 => B2_P4_xa, A0 => B2_G1);
GLB_S3_QB : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => S3_QB, RNESET => L2L_KEYWD_RESET_glbb, CD => B2_CD, CLK => B2_CLK, 
	D0 => S3_QB_D0);
GLB_S2_PIN : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => S2_PIN, RNESET => L2L_KEYWD_RESET_glbb, CD => B2_CD, CLK => B2_CLK, 
	D0 => S2_PIN_D0);
GLB_B2_IN7B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B2_IN7B, A0 => SETX_grp);
GLB_B2_IN1B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B2_IN1B, A0 => SENSX_grp);
GLB_B2_IN17B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B2_IN17B, A0 => S3_QB_ffb);
GLB_B2_IN3B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B2_IN3B, A0 => S0_PIN_grp);
GLB_B3_P13 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B3_P13, A0 => B3_IN16);
GLB_B3_P12 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B3_P12, A0 => B3_IN7B);
GLB_B3_P8 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B3_P8, A0 => B3_IN5);
GLB_B3_G3 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B3_G3, A0 => GND);
GLB_B3_G2 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B3_G2, A0 => GND);
GLB_B3_CD : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 8.700000 ns, TFALL => 8.700000 ns)
	PORT MAP (Z0 => B3_CD, A0 => B3_P12);
GLB_B3_CLK : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B3_CLK, A0 => N_18_ck2f);
GLB_B3_P8_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B3_P8_xa, A0 => B3_P8);
GLB_B3_P13_xa : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B3_P13_xa, A0 => B3_P13);
GLB_B3_IN16 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B3_IN16, A0 => S1_PIN_ffb);
GLB_B3_IN5 : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B3_IN5, A0 => S2_PIN_grp);
GLB_S1_PIN_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S1_PIN_D0, A1 => B3_P8_xa, A0 => B3_G2);
GLB_S0_PIN_D0 : PGXOR2_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S0_PIN_D0, A1 => B3_P13_xa, A0 => B3_G3);
GLB_S1_PIN : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => S1_PIN, RNESET => L2L_KEYWD_RESET_glbb, CD => B3_CD, CLK => B3_CLK, 
	D0 => S1_PIN_D0);
GLB_S0_PIN : PGDFFR_principal_complet
    GENERIC MAP (HLCQ => 1.300000 ns, LHCQ => 1.300000 ns, HLRQ => 3.300000 ns, SUD0 => 2.700000 ns, 
        SUD1 => 2.700000 ns, HOLDD0 => 4.700000 ns, HOLDD1 => 4.700000 ns, POSC1 => 6.000000 ns, 
        POSC0 => 6.000000 ns, NEGC1 => 6.000000 ns, NEGC0 => 6.000000 ns, RECRC => 0.000000 ns, 
        HOLDRC => 0.000000 ns)
	PORT MAP (Q0 => S0_PIN, RNESET => L2L_KEYWD_RESET_glbb, CD => B3_CD, CLK => B3_CLK, 
	D0 => S0_PIN_D0);
GLB_B3_IN7B : PGINVI_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (ZN0 => B3_IN7B, A0 => SETX_grp);
IOC_L2L_KEYWD_RESET : PXIN_principal_complet
    GENERIC MAP (TRISE => 10.700000 ns, TFALL => 10.700000 ns)
	PORT MAP (Z0 => L2L_KEYWD_RESETb, XI0 => XRESET);
IOC_IO24_IBUFO : PXIN_principal_complet
    GENERIC MAP (TRISE => 2.600000 ns, TFALL => 2.600000 ns)
	PORT MAP (Z0 => IO24_IBUFO, XI0 => SET);
IOC_IO30_IBUFO : PXIN_principal_complet
    GENERIC MAP (TRISE => 2.600000 ns, TFALL => 2.600000 ns)
	PORT MAP (Z0 => IO30_IBUFO, XI0 => SENS);
IOC_HX : PXIN_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => HX, XI0 => H);
IOC_S3 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => S3, A0 => IO23_OBUFI);
IOC_IO23_OBUFI : PGINVI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (ZN0 => IO23_OBUFI, A0 => S3_QB_iomux);
IOC_S2 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => S2, A0 => IO22_OBUFI);
IOC_IO22_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO22_OBUFI, A0 => S2_PIN_iomux);
IOC_S1 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => S1, A0 => IO21_OBUFI);
IOC_IO21_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO21_OBUFI, A0 => S1_PIN_iomux);
IOC_S0 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => S0, A0 => IO20_OBUFI);
IOC_IO20_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO20_OBUFI, A0 => S0_PIN_iomux);
IOC_PH4 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => PH4, A0 => IO8_OBUFI);
IOC_IO8_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO8_OBUFI, A0 => OR_749_iomux);
IOC_PH3 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => PH3, A0 => IO13_OBUFI);
IOC_IO13_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO13_OBUFI, A0 => OR_746_iomux);
IOC_PH2 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => PH2, A0 => IO12_OBUFI);
IOC_IO12_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO12_OBUFI, A0 => OR_743_iomux);
IOC_PH1 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => PH1, A0 => IO9_OBUFI);
IOC_IO9_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO9_OBUFI, A0 => OR_740_iomux);
IOC_LPH4 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => LPH4, A0 => IO19_OBUFI);
IOC_IO19_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO19_OBUFI, A0 => PH4_PIN_iomux);
IOC_LPH3 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => LPH3, A0 => IO18_OBUFI);
IOC_IO18_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO18_OBUFI, A0 => PH3_PIN_iomux);
IOC_LPH2 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => LPH2, A0 => IO17_OBUFI);
IOC_IO17_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO17_OBUFI, A0 => PH2_PIN_iomux);
IOC_LPH1 : PXOUT_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => LPH1, A0 => IO16_OBUFI);
IOC_IO16_OBUFI : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO16_OBUFI, A0 => PH1_PIN_iomux);
GRP_OR_749_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => OR_749_iomux, A0 => OR_749);
GRP_OR_740_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => OR_740_iomux, A0 => OR_740);
GRP_N_45_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_45_ffb, A0 => N_45);
GRP_N_45_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.000000 ns, TFALL => 2.000000 ns)
	PORT MAP (Z0 => N_45_grp, A0 => N_45);
GRP_N_44_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.000000 ns, TFALL => 2.000000 ns)
	PORT MAP (Z0 => N_44_grp, A0 => N_44);
GRP_N_44_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_44_ffb, A0 => N_44);
GRP_S0_PIN_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.400000 ns, TFALL => 2.400000 ns)
	PORT MAP (Z0 => S0_PIN_grp, A0 => S0_PIN);
GRP_S0_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => S0_PIN_iomux, A0 => S0_PIN);
GRP_S3_QB_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.200000 ns, TFALL => 2.200000 ns)
	PORT MAP (Z0 => S3_QB_grp, A0 => S3_QB);
GRP_S3_QB_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S3_QB_ffb, A0 => S3_QB);
GRP_S3_QB_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => S3_QB_iomux, A0 => S3_QB);
GRP_SENSX_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.700000 ns, TFALL => 2.700000 ns)
	PORT MAP (Z0 => SENSX_grp, A0 => IO30_IBUFO);
GRP_OR_746_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => OR_746_iomux, A0 => OR_746);
GRP_OR_743_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => OR_743_iomux, A0 => OR_743);
GRP_S1_PIN_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.400000 ns, TFALL => 2.400000 ns)
	PORT MAP (Z0 => S1_PIN_grp, A0 => S1_PIN);
GRP_S1_PIN_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S1_PIN_ffb, A0 => S1_PIN);
GRP_S1_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => S1_PIN_iomux, A0 => S1_PIN);
GRP_S2_PIN_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => S2_PIN_ffb, A0 => S2_PIN);
GRP_S2_PIN_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.400000 ns, TFALL => 2.400000 ns)
	PORT MAP (Z0 => S2_PIN_grp, A0 => S2_PIN);
GRP_S2_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => S2_PIN_iomux, A0 => S2_PIN);
GRP_HX_clk0 : PXIN_principal_complet
    GENERIC MAP (TRISE => 4.700000 ns, TFALL => 4.700000 ns)
	PORT MAP (Z0 => HX_clk0, XI0 => HX);
GRP_PH4_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => PH4_PIN_iomux, A0 => PH4_PIN);
GRP_PH3_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => PH3_PIN_iomux, A0 => PH3_PIN);
GRP_N_18_ffb : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => N_18_ffb, A0 => N_18);
GRP_N_18_ck2f : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 6.600000 ns, TFALL => 6.600000 ns)
	PORT MAP (Z0 => N_18_ck2f, A0 => N_18);
GRP_BUF_736_ck1f : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 6.600000 ns, TFALL => 6.600000 ns)
	PORT MAP (Z0 => BUF_736_ck1f, A0 => BUF_736);
GRP_PH2_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => PH2_PIN_iomux, A0 => PH2_PIN);
GRP_PH1_PIN_iomux : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => PH1_PIN_iomux, A0 => PH1_PIN);
GRP_SETX_grp : PGBUFI_principal_complet
    GENERIC MAP (TRISE => 2.200000 ns, TFALL => 2.200000 ns)
	PORT MAP (Z0 => SETX_grp, A0 => IO24_IBUFO);
GRP_L2L_KEYWD_RESET_glb : PXIN_principal_complet
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => L2L_KEYWD_RESET_glbb, XI0 => L2L_KEYWD_RESETb);
END principal_complet_STRUCTURE;
