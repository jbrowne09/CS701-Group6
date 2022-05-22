library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity instruction_test_bench is
end instruction_test_bench;

architecture sim of instruction_test_bench is

	signal clock_t			: std_logic := '1';
	signal send_data_t	: tdma_min_data;
	signal send_addr_t	: tdma_min_addr;
	
begin

	RecopTopLevel : entity work.RecopTopLevel
	port map (
		clock				=> clock_t,
		recv_addr_top 	=> "00000000",
		recv_data_top	=> "00000000000000000000000000000000",
		send_addr_top 	=> send_addr_t,
		send_data_top	=> send_data_t
	);

	
	clk: process
	begin
		wait for 10 ns;
		clock_t <= '0';
		wait for 10 ns;
		clock_t <= '1';
	end process;

end architecture;