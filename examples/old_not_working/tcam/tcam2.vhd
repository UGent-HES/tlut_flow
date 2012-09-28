--TMAP
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pkg2.all;

-- synopsys translate_off
library UNISIM;
use unisim.Vcomponents.all;
-- synopsys translate_on

entity tcam2 is
  port (
--    clk     : in  std_logic;
    entry   : in  entry_array;

architecture rtl of tcam2 is
component LUT1
generic (
	INIT : bit_vector := X"2");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC);
end component;
component LUT2
generic (
	INIT : bit_vector := X"4");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC);
end component;
component LUT3
generic (
	INIT : bit_vector := X"8");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC);
end component;
component LUT4
generic (
	INIT : bit_vector := X"16");
port   (O : out STD_ULOGIC; 
	I0: in STD_ULOGIC; 
	I1: in STD_ULOGIC; 
	I2: in STD_ULOGIC; 
	I3: in STD_ULOGIC);
end component;
component FD
generic (
	INIT : bit:= '1');
port   (Q : out STD_ULOGIC;
	C : in STD_ULOGIC;
	D : in STD_ULOGIC);
end component;

signal a616 : STD_ULOGIC ;
signal a636 : STD_ULOGIC ;
signal a640 : STD_ULOGIC ;
signal a696 : STD_ULOGIC ;
signal a716 : STD_ULOGIC ;
signal a720 : STD_ULOGIC ;
signal a776 : STD_ULOGIC ;
signal a796 : STD_ULOGIC ;
signal a800 : STD_ULOGIC ;
signal a856 : STD_ULOGIC ;
signal a876 : STD_ULOGIC ;
signal a880 : STD_ULOGIC ;
signal a884 : STD_ULOGIC ;
signal a940 : STD_ULOGIC ;
signal a960 : STD_ULOGIC ;
signal a964 : STD_ULOGIC ;
signal a1020 : STD_ULOGIC ;
signal a1040 : STD_ULOGIC ;
signal a1044 : STD_ULOGIC ;
signal a1100 : STD_ULOGIC ;
signal a1120 : STD_ULOGIC ;
signal a1124 : STD_ULOGIC ;
signal a1180 : STD_ULOGIC ;
signal a1200 : STD_ULOGIC ;
signal a1204 : STD_ULOGIC ;
signal a1208 : STD_ULOGIC ;
signal a1264 : STD_ULOGIC ;
signal a1284 : STD_ULOGIC ;
signal a1288 : STD_ULOGIC ;
signal a1344 : STD_ULOGIC ;
signal a1364 : STD_ULOGIC ;
signal a1368 : STD_ULOGIC ;
signal a1374 : STD_ULOGIC ;
signal a1430 : STD_ULOGIC ;
signal a1450 : STD_ULOGIC ;
signal a1454 : STD_ULOGIC ;
signal a1510 : STD_ULOGIC ;
signal a1530 : STD_ULOGIC ;
signal a1534 : STD_ULOGIC ;
signal a1540 : STD_ULOGIC ;
signal a1596 : STD_ULOGIC ;
signal a1616 : STD_ULOGIC ;
signal a1620 : STD_ULOGIC ;
signal a1676 : STD_ULOGIC ;
signal a1696 : STD_ULOGIC ;
signal a1700 : STD_ULOGIC ;
signal a1756 : STD_ULOGIC ;
signal a1776 : STD_ULOGIC ;
signal a1780 : STD_ULOGIC ;
signal a1836 : STD_ULOGIC ;
signal a1856 : STD_ULOGIC ;
signal a1860 : STD_ULOGIC ;
signal a1864 : STD_ULOGIC ;
signal a1870 : STD_ULOGIC ;
signal a1876 : STD_ULOGIC ;
signal a1878 : STD_ULOGIC ;
signal a1880 : STD_ULOGIC ;
signal a1886 : STD_ULOGIC ;
signal a1890 : STD_ULOGIC ;
signal a1896 : STD_ULOGIC ;
signal a1902 : STD_ULOGIC ;
signal a1908 : STD_ULOGIC ;
signal a1914 : STD_ULOGIC ;
signal a1920 : STD_ULOGIC ;
signal a1924 : STD_ULOGIC ;
signal a1930 : STD_ULOGIC ;
signal a1934 : STD_ULOGIC ;
signal a1940 : STD_ULOGIC ;
signal a1942 : STD_ULOGIC ;
signal a1944 : STD_ULOGIC ;
signal a1946not : STD_ULOGIC ;

attribute INIT : string;
attribute INIT of tcam2_LUT2_a616: label is "4";
attribute INIT of tcam2_LUT4_a636: label is "16";
attribute INIT of tcam2_LUT4_a640: label is "16";
attribute INIT of tcam2_LUT2_a696: label is "4";
attribute INIT of tcam2_LUT4_a716: label is "16";
attribute INIT of tcam2_LUT4_a720: label is "16";
attribute INIT of tcam2_LUT2_a776: label is "4";
attribute INIT of tcam2_LUT4_a796: label is "16";
attribute INIT of tcam2_LUT4_a800: label is "16";
attribute INIT of tcam2_LUT2_a856: label is "4";
attribute INIT of tcam2_LUT4_a876: label is "16";
attribute INIT of tcam2_LUT4_a880: label is "16";
attribute INIT of tcam2_LUT3_a884: label is "8";
attribute INIT of tcam2_LUT2_a940: label is "4";
attribute INIT of tcam2_LUT4_a960: label is "16";
attribute INIT of tcam2_LUT4_a964: label is "16";
attribute INIT of tcam2_LUT2_a1020: label is "4";
attribute INIT of tcam2_LUT4_a1040: label is "16";
attribute INIT of tcam2_LUT4_a1044: label is "16";
attribute INIT of tcam2_LUT2_a1100: label is "4";
attribute INIT of tcam2_LUT4_a1120: label is "16";
attribute INIT of tcam2_LUT4_a1124: label is "16";
attribute INIT of tcam2_LUT2_a1180: label is "4";
attribute INIT of tcam2_LUT4_a1200: label is "16";
attribute INIT of tcam2_LUT4_a1204: label is "16";
attribute INIT of tcam2_LUT3_a1208: label is "8";
attribute INIT of tcam2_LUT2_a1264: label is "4";
attribute INIT of tcam2_LUT4_a1284: label is "16";
attribute INIT of tcam2_LUT4_a1288: label is "16";
attribute INIT of tcam2_LUT2_a1344: label is "4";
attribute INIT of tcam2_LUT4_a1364: label is "16";
attribute INIT of tcam2_LUT4_a1368: label is "16";
attribute INIT of tcam2_LUT4_a1374: label is "16";
attribute INIT of tcam2_LUT2_a1430: label is "4";
attribute INIT of tcam2_LUT4_a1450: label is "16";
attribute INIT of tcam2_LUT4_a1454: label is "16";
attribute INIT of tcam2_LUT2_a1510: label is "4";
attribute INIT of tcam2_LUT4_a1530: label is "16";
attribute INIT of tcam2_LUT4_a1534: label is "16";
attribute INIT of tcam2_LUT4_a1540: label is "16";
attribute INIT of tcam2_LUT2_a1596: label is "4";
attribute INIT of tcam2_LUT4_a1616: label is "16";
attribute INIT of tcam2_LUT4_a1620: label is "16";
attribute INIT of tcam2_LUT2_a1676: label is "4";
attribute INIT of tcam2_LUT4_a1696: label is "16";
attribute INIT of tcam2_LUT4_a1700: label is "16";
attribute INIT of tcam2_LUT2_a1756: label is "4";
attribute INIT of tcam2_LUT4_a1776: label is "16";
attribute INIT of tcam2_LUT4_a1780: label is "16";
attribute INIT of tcam2_LUT2_a1836: label is "4";
attribute INIT of tcam2_LUT4_a1856: label is "16";
attribute INIT of tcam2_LUT4_a1860: label is "16";
attribute INIT of tcam2_LUT3_a1864: label is "8";
attribute INIT of tcam2_LUT4_a1870: label is "16";
attribute INIT of tcam2_LUT4_a1876: label is "16";
attribute INIT of tcam2_LUT2_a1878: label is "4";
attribute INIT of tcam2_LUT2_a1880: label is "4";
attribute INIT of tcam2_LUT4_a1886: label is "16";
attribute INIT of tcam2_LUT3_a1890: label is "8";
attribute INIT of tcam2_LUT4_a1896: label is "16";
attribute INIT of tcam2_LUT4_a1902: label is "16";
attribute INIT of tcam2_LUT4_a1908: label is "16";
attribute INIT of tcam2_LUT4_a1914: label is "16";
attribute INIT of tcam2_LUT4_a1920: label is "16";
attribute INIT of tcam2_LUT3_a1924: label is "8";
attribute INIT of tcam2_LUT3_a1930: label is "8";
attribute INIT of tcam2_LUT4_a1934: label is "16";
attribute INIT of tcam2_LUT4_a1940: label is "16";
attribute INIT of tcam2_LUT2_a1942: label is "4";
attribute INIT of tcam2_LUT2_a1944: label is "4";
attribute INIT of tcam2_LUT2_a1946not: label is "4";

attribute lock_pins : string;
attribute lock_pins of LUT1: component is "ALL";
attribute lock_pins of LUT2: component is "ALL";
attribute lock_pins of LUT3: component is "ALL";
attribute lock_pins of LUT4: component is "ALL";

begin

tcam2_LUT2_a616: LUT2
generic map (
	INIT =>X"1")
port map (O => a616,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a636: LUT4
generic map (
	INIT =>X"1")
port map (O => a636,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a640: LUT4
generic map (
	INIT =>X"1")
port map (O => a640,
	I0 => datain(7),
	I1 => a636,
	I2 => a616,
	I3 => datain(3));

tcam2_LUT2_a696: LUT2
generic map (
	INIT =>X"1")
port map (O => a696,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a716: LUT4
generic map (
	INIT =>X"1")
port map (O => a716,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a720: LUT4
generic map (
	INIT =>X"1")
port map (O => a720,
	I0 => datain(7),
	I1 => a696,
	I2 => a716,
	I3 => datain(3));

tcam2_LUT2_a776: LUT2
generic map (
	INIT =>X"1")
port map (O => a776,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a796: LUT4
generic map (
	INIT =>X"1")
port map (O => a796,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a800: LUT4
generic map (
	INIT =>X"1")
port map (O => a800,
	I0 => datain(7),
	I1 => a776,
	I2 => a796,
	I3 => datain(3));

tcam2_LUT2_a856: LUT2
generic map (
	INIT =>X"1")
port map (O => a856,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a876: LUT4
generic map (
	INIT =>X"1")
port map (O => a876,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a880: LUT4
generic map (
	INIT =>X"1")
port map (O => a880,
	I0 => datain(7),
	I1 => a876,
	I2 => a856,
	I3 => datain(3));

tcam2_LUT3_a884: LUT3
generic map (
	INIT =>X"1")
port map (O => a884,
	I0 => a880,
	I1 => a800,
	I2 => a720);

tcam2_LUT2_a940: LUT2
generic map (
	INIT =>X"1")
port map (O => a940,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a960: LUT4
generic map (
	INIT =>X"1")
port map (O => a960,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a964: LUT4
generic map (
	INIT =>X"1")
port map (O => a964,
	I0 => datain(7),
	I1 => a960,
	I2 => a940,
	I3 => datain(3));

tcam2_LUT2_a1020: LUT2
generic map (
	INIT =>X"1")
port map (O => a1020,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1040: LUT4
generic map (
	INIT =>X"1")
port map (O => a1040,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1044: LUT4
generic map (
	INIT =>X"1")
port map (O => a1044,
	I0 => datain(7),
	I1 => a1040,
	I2 => a1020,
	I3 => datain(3));

tcam2_LUT2_a1100: LUT2
generic map (
	INIT =>X"1")
port map (O => a1100,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1120: LUT4
generic map (
	INIT =>X"1")
port map (O => a1120,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1124: LUT4
generic map (
	INIT =>X"1")
port map (O => a1124,
	I0 => datain(7),
	I1 => a1100,
	I2 => a1120,
	I3 => datain(3));

tcam2_LUT2_a1180: LUT2
generic map (
	INIT =>X"1")
port map (O => a1180,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1200: LUT4
generic map (
	INIT =>X"1")
port map (O => a1200,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1204: LUT4
generic map (
	INIT =>X"1")
port map (O => a1204,
	I0 => datain(7),
	I1 => a1180,
	I2 => a1200,
	I3 => datain(3));

tcam2_LUT3_a1208: LUT3
generic map (
	INIT =>X"1")
port map (O => a1208,
	I0 => a1124,
	I1 => a1204,
	I2 => a1044);

tcam2_LUT2_a1264: LUT2
generic map (
	INIT =>X"1")
port map (O => a1264,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1284: LUT4
generic map (
	INIT =>X"1")
port map (O => a1284,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1288: LUT4
generic map (
	INIT =>X"1")
port map (O => a1288,
	I0 => datain(7),
	I1 => a1264,
	I2 => a1284,
	I3 => datain(3));

tcam2_LUT2_a1344: LUT2
generic map (
	INIT =>X"1")
port map (O => a1344,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1364: LUT4
generic map (
	INIT =>X"1")
port map (O => a1364,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1368: LUT4
generic map (
	INIT =>X"1")
port map (O => a1368,
	I0 => datain(7),
	I1 => a1344,
	I2 => a1364,
	I3 => datain(3));

tcam2_LUT4_a1374: LUT4
generic map (
	INIT =>X"1")
port map (O => a1374,
	I0 => a1368,
	I1 => a1208,
	I2 => a964,
	I3 => a1288);

tcam2_LUT2_a1430: LUT2
generic map (
	INIT =>X"1")
port map (O => a1430,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1450: LUT4
generic map (
	INIT =>X"1")
port map (O => a1450,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1454: LUT4
generic map (
	INIT =>X"1")
port map (O => a1454,
	I0 => datain(7),
	I1 => a1430,
	I2 => datain(3),
	I3 => a1450);

tcam2_LUT2_a1510: LUT2
generic map (
	INIT =>X"1")
port map (O => a1510,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1530: LUT4
generic map (
	INIT =>X"1")
port map (O => a1530,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1534: LUT4
generic map (
	INIT =>X"1")
port map (O => a1534,
	I0 => datain(7),
	I1 => a1530,
	I2 => a1510,
	I3 => datain(3));

tcam2_LUT4_a1540: LUT4
generic map (
	INIT =>X"1")
port map (O => a1540,
	I0 => a884,
	I1 => a1374,
	I2 => a1454,
	I3 => a1534);

tcam2_LUT2_a1596: LUT2
generic map (
	INIT =>X"1")
port map (O => a1596,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1616: LUT4
generic map (
	INIT =>X"1")
port map (O => a1616,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1620: LUT4
generic map (
	INIT =>X"1")
port map (O => a1620,
	I0 => datain(7),
	I1 => a1596,
	I2 => a1616,
	I3 => datain(3));

tcam2_LUT2_a1676: LUT2
generic map (
	INIT =>X"1")
port map (O => a1676,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1696: LUT4
generic map (
	INIT =>X"1")
port map (O => a1696,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1700: LUT4
generic map (
	INIT =>X"1")
port map (O => a1700,
	I0 => datain(7),
	I1 => a1676,
	I2 => datain(3),
	I3 => a1696);

tcam2_LUT2_a1756: LUT2
generic map (
	INIT =>X"1")
port map (O => a1756,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1776: LUT4
generic map (
	INIT =>X"1")
port map (O => a1776,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(4));

tcam2_LUT4_a1780: LUT4
generic map (
	INIT =>X"1")
port map (O => a1780,
	I0 => datain(7),
	I1 => a1776,
	I2 => datain(3),
	I3 => a1756);

tcam2_LUT2_a1836: LUT2
generic map (
	INIT =>X"1")
port map (O => a1836,
	I0 => datain(5),
	I1 => datain(6));

tcam2_LUT4_a1856: LUT4
generic map (
	INIT =>X"1")
port map (O => a1856,
	I0 => datain(2),
	I1 => datain(1),
	I2 => datain(0),
	I3 => datain(3));

tcam2_LUT4_a1860: LUT4
generic map (
	INIT =>X"1")
port map (O => a1860,
	I0 => datain(7),
	I1 => a1836,
	I2 => datain(4),
	I3 => a1856);

tcam2_LUT3_a1864: LUT3
generic map (
	INIT =>X"1")
port map (O => a1864,
	I0 => a880,
	I1 => a1780,
	I2 => a1860);

tcam2_LUT4_a1870: LUT4
generic map (
	INIT =>X"1")
port map (O => a1870,
	I0 => a800,
	I1 => a1864,
	I2 => a720,
	I3 => a1700);

tcam2_LUT4_a1876: LUT4
generic map (
	INIT =>X"1")
port map (O => a1876,
	I0 => a1540,
	I1 => a1870,
	I2 => a1620,
	I3 => a640);

tcam2_LUT2_a1878: LUT2
generic map (
	INIT =>X"1")
port map (O => a1878,
	I0 => a800,
	I1 => a1780);

tcam2_LUT2_a1880: LUT2
generic map (
	INIT =>X"1")
port map (O => a1880,
	I0 => a880,
	I1 => a1860);

tcam2_LUT4_a1886: LUT4
generic map (
	INIT =>X"1")
port map (O => a1886,
	I0 => a1878,
	I1 => a1880,
	I2 => a720,
	I3 => a1700);

tcam2_LUT3_a1890: LUT3
generic map (
	INIT =>X"1")
port map (O => a1890,
	I0 => a1124,
	I1 => a1204,
	I2 => a1288);

tcam2_LUT4_a1896: LUT4
generic map (
	INIT =>X"1")
port map (O => a1896,
	I0 => a1368,
	I1 => a1890,
	I2 => a964,
	I3 => a1044);

tcam2_LUT4_a1902: LUT4
generic map (
	INIT =>X"1")
port map (O => a1902,
	I0 => a1878,
	I1 => a1454,
	I2 => a1534,
	I3 => a1896);

tcam2_LUT4_a1908: LUT4
generic map (
	INIT =>X"1")
port map (O => a1908,
	I0 => a1902,
	I1 => a1620,
	I2 => a1886,
	I3 => a640);

tcam2_LUT4_a1914: LUT4
generic map (
	INIT =>X"1")
port map (O => a1914,
	I0 => a1368,
	I1 => a1454,
	I2 => a1534,
	I3 => a964);

tcam2_LUT4_a1920: LUT4
generic map (
	INIT =>X"1")
port map (O => a1920,
	I0 => a1124,
	I1 => a1204,
	I2 => a1288,
	I3 => a1044);

tcam2_LUT3_a1924: LUT3
generic map (
	INIT =>X"1")
port map (O => a1924,
	I0 => a1880,
	I1 => a1920,
	I2 => a1914);

tcam2_LUT3_a1930: LUT3
generic map (
	INIT =>X"1")
port map (O => a1930,
	I0 => a1620,
	I1 => a640,
	I2 => a1700);

tcam2_LUT4_a1934: LUT4
generic map (
	INIT =>X"1")
port map (O => a1934,
	I0 => a1924,
	I1 => a1878,
	I2 => a1930,
	I3 => a720);

tcam2_LUT4_a1940: LUT4
generic map (
	INIT =>X"1")
port map (O => a1940,
	I0 => a884,
	I1 => a1780,
	I2 => a1930,
	I3 => a1860);

tcam2_LUT2_a1942: LUT2
generic map (
	INIT =>X"1")
port map (O => a1942,
	I0 => a1920,
	I1 => a1914);

tcam2_LUT2_a1944: LUT2
generic map (
	INIT =>X"1")
port map (O => a1944,
	I0 => a1942,
	I1 => a1940);

tcam2_LUT2_a1946not: LUT2
generic map (
	INIT =>X"1")
port map (O => a1946not,
	I0 => a1942,
	I1 => a1940);
addrout(0) <= a1876;
addrout(1) <= a1908;
addrout(2) <= a1934;
addrout(3) <= a1944;
match <= a1946not;
end;