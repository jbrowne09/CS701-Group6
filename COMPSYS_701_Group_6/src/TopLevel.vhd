library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TopLevel is
 	generic (
		nodes : positive := 8
	);
	port (
		CLOCK_50      : in    std_logic;
		CLOCK2_50     : in    std_logic;
		CLOCK3_50     : in    std_logic;
		CLOCK4_50     : in    std_logic;

		KEY           : in    std_logic_vector(3 downto 0);
		SW            : in    std_logic_vector(9 downto 0);
		LEDR          : out   std_logic_vector(9 downto 0);
		HEX0          : out   std_logic_vector(6 downto 0);
		HEX1          : out   std_logic_vector(6 downto 0);
		HEX2          : out   std_logic_vector(6 downto 0);
		HEX3          : out   std_logic_vector(6 downto 0);
		HEX4          : out   std_logic_vector(6 downto 0);
		HEX5          : out   std_logic_vector(6 downto 0);

		FPGA_I2C_SCLK : out   std_logic;
		FPGA_I2C_SDAT : inout std_logic;
		AUD_ADCDAT    : in    std_logic;
		AUD_ADCLRCK   : inout std_logic;
		AUD_BCLK      : inout std_logic;
		AUD_DACDAT    : out   std_logic;
		AUD_DACLRCK   : inout std_logic;
		AUD_XCK       : out   std_logic
	);
end entity;

architecture rtl of TopLevel is

	signal send_addrs : tdma_min_addrs(0 to nodes-1);
	signal send_datas : tdma_min_ports(0 to nodes-1);
	signal recv_addrs : tdma_min_addrs(0 to nodes-1);
	signal recv_datas : tdma_min_ports(0 to nodes-1);

begin

	tdma_min : entity work.TdmaMin
	generic map (
		nodes => nodes
	)
	port map (
		clock      => CLOCK4_50,
		send_addrs => send_addrs,
		send_datas => send_datas,
		recv_addrs => recv_addrs,
		recv_datas => recv_datas
	);

	node_io : entity work.NodeIo
	port map (
		clock     => CLOCK4_50,
		key       => KEY,
		sw        => SW,
		ledr      => LEDR,
		hex0      => HEX0,
		hex1      => HEX1,
		hex2      => HEX2,
		hex3      => HEX3,
		hex4      => HEX4,
		hex5      => HEX5,

		send_addr => send_addrs(0),
		send_data => send_datas(0),
		recv_addr => recv_addrs(0),
		recv_data => recv_datas(0)
	);
	
	RECOP : entity work.RecopTopLevel
	port map (
		clock         => CLOCK4_50,
		send_addr_top => send_addrs(1),
		send_data_top => send_datas(1),
		recv_addr_top => recv_addrs(1),
		recv_data_top => recv_datas(1)
	);

	adc_dac : entity work.AdcDac
	port map (
		clock         => CLOCK4_50,
		fpga_i2c_sclk => FPGA_I2C_SCLK,
		fpga_i2c_sdat => FPGA_I2C_SDAT,
		aud_adcdat    => AUD_ADCDAT,
		aud_adclrck   => AUD_ADCLRCK,
		aud_bclk      => AUD_BCLK,
		aud_dacdat    => AUD_DACDAT,
		aud_daclrck   => AUD_DACLRCK,
		aud_xck       => AUD_XCK,

		adc_send_addr => send_addrs(2),
		adc_send_data => send_datas(2),
		adc_recv_addr => recv_addrs(2),
		adc_recv_data => recv_datas(2),

		dac_send_addr => send_addrs(3),
		dac_send_data => send_datas(3),
		dac_recv_addr => recv_addrs(3),
		dac_recv_data => recv_datas(3)
	);
	
	JBroASP : entity work.jbro682_ASP
	port map (
		clock         => CLOCK4_50,
		send_addr => send_addrs(4),
		send_data => send_datas(4),
		recv_addr => recv_addrs(4),
		recv_data => recv_datas(4)
	);
	
	SBolASP : entity work.sbol998_ASP
	port map (
		clock         => CLOCK4_50,
		send_addr => send_addrs(5),
		send_data => send_datas(5),
		recv_addr => recv_addrs(5),
		recv_data => recv_datas(5)
	);
	 
	BWilASP : entity work.Compsys_701_Bwil410
	port map (
		clock         => CLOCK4_50,
		send_addr => send_addrs(6),
		INPUT => send_datas(6),
		Addr_Out => recv_addrs(6),
		Data_Out => recv_datas(6)
	);
end architecture;
