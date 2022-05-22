library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

library work;
use work.TdmaMinTypes.all;

entity AdcDac is
	port (
		clock         : in    std_logic;
		fpga_i2c_sclk : out   std_logic;
		fpga_i2c_sdat : inout std_logic;
		aud_adcdat    : in    std_logic;
		aud_adclrck   : inout std_logic;
		aud_bclk      : inout std_logic;
		aud_dacdat    : out   std_logic;
		aud_daclrck   : inout std_logic;
		aud_xck       : out   std_logic;
		
		adc_send_addr : out tdma_min_addr;
		adc_send_data : out tdma_min_data;
		adc_recv_addr : in  tdma_min_addr;
		adc_recv_data : in  tdma_min_data;
		
		dac_send_addr : out tdma_min_addr;
		dac_send_data : out tdma_min_data;
		dac_recv_addr : in  tdma_min_addr;
		dac_recv_data : in  tdma_min_data
	);
end entity;

architecture rtl of AdcDac is

	signal adc_empty : std_logic;
	signal adc_get   : std_logic;
	signal adc_data  : std_logic_vector(24 downto 0);
	signal dac_full  : std_logic;
	signal dac_put   : std_logic;
	signal dac_data  : std_logic_vector(24 downto 0);

begin

	audio_clock : entity ip.AudioClock
	port map (
		audio_clk_clk      => AUD_XCK,
		ref_clk_clk        => clock,
		ref_reset_reset    => open,
		reset_source_reset => open
	);

	audio_control : entity work.AudioControl
	port map (
		clock => clock,
		scl   => FPGA_I2C_SCLK,
		sda   => FPGA_I2C_SDAT
	);

	audio_adc : entity work.AudioIn
	port map (
		clock  => clock,
		empty  => adc_empty,
		get    => adc_get,
		data   => adc_data,
		bclk   => AUD_BCLK,
		adcdat => AUD_ADCDAT,
		adclrc => AUD_ADCLRCK
	);

	audio_dac : entity work.AudioOut
	port map (
		clock  => clock,
		full   => dac_full,
		put    => dac_put,
		data   => dac_data,
		bclk   => AUD_BCLK,
		dacdat => AUD_DACDAT,
		daclrc => AUD_DACLRCK
	);

	node_adc : entity work.NodeAdc
	port map (
		clock     => clock,
		empty     => adc_empty,
		get       => adc_get,
		data      => adc_data,

		send_addr => adc_send_addr,
		send_data => adc_send_data,
		recv_addr => adc_recv_addr,
		recv_data => adc_recv_data
	);

	node_dac : entity work.NodeDac
	port map (
		clock     => clock,
		full      => dac_full,
		put       => dac_put,
		data      => dac_data,

		send_addr => dac_send_addr,
		send_data => dac_send_data,
		recv_addr => dac_recv_addr,
		recv_data => dac_recv_data
	);

end architecture;
