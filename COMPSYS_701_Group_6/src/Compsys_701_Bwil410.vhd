-- Copyright (C) 2019  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"
-- CREATED		"Tue Jun 09 14:49:17 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;
use work.TdmaMinTypes.all;

ENTITY Compsys_701_Bwil410 IS 
	PORT
	(
		clock :  IN  STD_LOGIC;
		INPUT 	: in  tdma_min_data;
		send_addr: in  tdma_min_addr;
		Addr_Out : out 	tdma_min_addr;
		Data_Out : out		tdma_min_data
	);
END Compsys_701_Bwil410;

ARCHITECTURE bdf_type OF Compsys_701_Bwil410 IS 

COMPONENT Bwil410_InputHandler
	PORT(inputi : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 enableData7 : OUT STD_LOGIC;
		 enableASP4 : OUT STD_LOGIC;
		 dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_controlblock
	PORT(clock : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 filter : OUT STD_LOGIC;
		 peakMax : OUT STD_LOGIC;
		 peakMin : OUT STD_LOGIC;
		 direct : OUT STD_LOGIC;
		 reset : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT Bwil410_config
	PORT(clock : IN STD_LOGIC;
		 enableASP : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 config2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_address
	PORT(clock : IN STD_LOGIC;
		 enableASP : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 address1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_dataReg
	PORT(clock : IN STD_LOGIC;
		 enableData11 : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 enabledd : OUT STD_LOGIC;
		 sData12 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_linearFilter
	PORT(clock : IN STD_LOGIC;
		 linear : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 loadData : OUT STD_LOGIC;
		 outputData : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_seloutput
	PORT(clock : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 loadLinear : IN STD_LOGIC;
		 loadPeak : IN STD_LOGIC;
		 direct : IN STD_LOGIC;
		 address2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 linerData : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 peakData : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 sdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 finaladdress : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 finalData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT Bwil410_PeakDetection
	PORT(clock : IN STD_LOGIC;
		 peakMax : IN STD_LOGIC;
		 peakMin : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 loadData : OUT STD_LOGIC;
		 outputData : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	address3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	clock1 :  STD_LOGIC;
SIGNAL	config3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	data4 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	direct3 :  STD_LOGIC;
SIGNAL	enableAS3 :  STD_LOGIC;
SIGNAL	enableData3 :  STD_LOGIC;
SIGNAL	enableDatasdd :  STD_LOGIC;
SIGNAL	finalData2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	linear3 :  STD_LOGIC;
SIGNAL	linearOutput :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	loadLinear3 :  STD_LOGIC;
SIGNAL	loadPeak3 :  STD_LOGIC;
SIGNAL	peakMax3 :  STD_LOGIC;
SIGNAL	peakMin3 :  STD_LOGIC;
SIGNAL	peakOutput :  STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	reset3 :  STD_LOGIC;
SIGNAL	sData6 :  STD_LOGIC_VECTOR(23 DOWNTO 0);


BEGIN 



b2v_inst : Bwil410_InputHandler
PORT MAP(inputi => INPUT,
		 enableData7 => enableData3,
		 enableASP4 => enableAS3,
		 dataOut => data4);


b2v_inst1 : Bwil410_controlblock
PORT MAP(clock => clock1,
		 enable => config3(0),
		 data => config3(3 DOWNTO 1),
		 filter => linear3,
		 peakMax => peakMax3,
		 peakMin => peakMin3,
		 direct => direct3,
		 reset => reset3);


b2v_inst2 : Bwil410_config
PORT MAP(clock => clock1,
		 enableASP => enableAS3,
		 data => data4(3 DOWNTO 0),
		 config2 => config3);


b2v_inst3 : Bwil410_address
PORT MAP(clock => clock1,
		 enableASP => enableAS3,
		 data => data4(7 DOWNTO 4),
		 address1 => address3);


b2v_inst4 : Bwil410_dataReg
PORT MAP(clock => clock1,
		 enableData11 => enableData3,
		 data => data4(23 DOWNTO 0),
		 enabledd => enableDatasdd,
		 sData12 => sData6);


b2v_inst5 : Bwil410_linearFilter
PORT MAP(clock => clock1,
		 linear => linear3,
		 reset => reset3,
		 enable => enableDatasdd,
		 data => sData6,
		 loadData => loadLinear3,
		 outputData => linearOutput);


b2v_inst6 : Bwil410_seloutput
PORT MAP(clock => clock1,
		 reset => reset3,
		 loadLinear => loadLinear3,
		 loadPeak => loadPeak3,
		 direct => direct3,
		 address2 => address3,
		 linerData => linearOutput,
		 peakData => peakOutput,
		 sdata => sData6,
		 finalAddress => Addr_Out,
		 finalData => finalData2);


b2v_inst7 : Bwil410_PeakDetection
PORT MAP(clock => clock1,
		 peakMax => peakMax3,
		 peakMin => peakMin3,
		 enable => enableDatasdd,
		 reset => reset3,
		 data => sData6,
		 loadData => loadPeak3,
		 outputData => peakOutput);

clock1 <= clock;
Data_Out <= finalData2;

END bdf_type;