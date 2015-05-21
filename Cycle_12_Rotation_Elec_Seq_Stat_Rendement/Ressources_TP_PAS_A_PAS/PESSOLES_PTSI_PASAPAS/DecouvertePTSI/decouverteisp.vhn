-- VHDL netlist for testled
-- Date: Wed May 20 11:06:10 2015
-- Copyright (c) Lattice Semiconductor Corporation
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PGBUFI_testled IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGBUFI_testled;

ARCHITECTURE behav OF PGBUFI_testled IS 
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

ENTITY PGXOR2_testled IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PGXOR2_testled;

ARCHITECTURE behav OF PGXOR2_testled IS 
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

ENTITY PXIN_testled IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        XI0 : IN std_logic;
        Z0 : OUT std_logic
    );
END PXIN_testled;

ARCHITECTURE behav OF PXIN_testled IS 
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

ENTITY PXOUT_testled IS 
    GENERIC (
        TRISE : TIME := 1 ns;
        TFALL : TIME := 1 ns
    );
    PORT (
        A0 : IN std_logic;
        XO0 : OUT std_logic
    );
END PXOUT_testled;

ARCHITECTURE behav OF PXOUT_testled IS 
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

ENTITY testled IS 
    PORT (
        SW1 : IN std_logic;
        LED1 : OUT std_logic
    );
END testled;


ARCHITECTURE testled_STRUCTURE OF testled IS
SIGNAL GND : std_logic := '0';
SIGNAL  IO24_IBUFO, IO23_OBUFI, BUF_663_iomux, B6_P0_xa,
	 BUF_663, B6_X3O, B6_G0, SW1X_grp,
	 B6_P0, B6_IN7 : std_logic;


  COMPONENT PGBUFI_testled
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGBUFI_testled use entity work.PGBUFI_testled(behav);

  COMPONENT PGXOR2_testled
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A1 : IN std_logic;
        A0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PGXOR2_testled use entity work.PGXOR2_testled(behav);

  COMPONENT PXIN_testled
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        XI0 : IN std_logic;
        Z0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PXIN_testled use entity work.PXIN_testled(behav);

  COMPONENT PXOUT_testled
    GENERIC (TRISE, TFALL : TIME);
    PORT (
        A0 : IN std_logic;
        XO0 : OUT std_logic
    );
  END COMPONENT;
  for all :  PXOUT_testled use entity work.PXOUT_testled(behav);

BEGIN

GLB_B6_P0 : PGBUFI_testled
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => B6_P0, A0 => B6_IN7);
GLB_B6_G0 : PGBUFI_testled
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B6_G0, A0 => GND);
GLB_B6_P0_xa : PGBUFI_testled
    GENERIC MAP (TRISE => 4.000000 ns, TFALL => 4.000000 ns)
	PORT MAP (Z0 => B6_P0_xa, A0 => B6_P0);
GLB_BUF_663 : PGBUFI_testled
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => BUF_663, A0 => B6_X3O);
GLB_B6_IN7 : PGBUFI_testled
    GENERIC MAP (TRISE => 1.300000 ns, TFALL => 1.300000 ns)
	PORT MAP (Z0 => B6_IN7, A0 => SW1X_grp);
GLB_B6_X3O : PGXOR2_testled
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => B6_X3O, A1 => B6_P0_xa, A0 => B6_G0);
IOC_IO24_IBUFO : PXIN_testled
    GENERIC MAP (TRISE => 2.600000 ns, TFALL => 2.600000 ns)
	PORT MAP (Z0 => IO24_IBUFO, XI0 => SW1);
IOC_LED1 : PXOUT_testled
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (XO0 => LED1, A0 => IO23_OBUFI);
IOC_IO23_OBUFI : PGBUFI_testled
    GENERIC MAP (TRISE => 0.700000 ns, TFALL => 0.700000 ns)
	PORT MAP (Z0 => IO23_OBUFI, A0 => BUF_663_iomux);
GRP_BUF_663_iomux : PGBUFI_testled
    GENERIC MAP (TRISE => 3.300000 ns, TFALL => 3.300000 ns)
	PORT MAP (Z0 => BUF_663_iomux, A0 => BUF_663);
GRP_SW1X_grp : PGBUFI_testled
    GENERIC MAP (TRISE => 2.000000 ns, TFALL => 2.000000 ns)
	PORT MAP (Z0 => SW1X_grp, A0 => IO24_IBUFO);
END testled_STRUCTURE;
