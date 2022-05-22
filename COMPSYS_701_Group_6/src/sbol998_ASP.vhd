library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

library work;
use work.TdmaMinTypes.all;

entity sbol998_ASP is
	port (
		clock : in  std_logic;
		recv_addr : in  tdma_min_addr;
		recv_data : in  tdma_min_data;

		send_addr : out tdma_min_addr;
		send_data : out tdma_min_data
	);
end entity sbol998_ASP;



architecture rtl of sbol998_ASP is

	signal enable 	     : std_logic := '0';
	signal instruction  : std_logic_vector(2 downto 0)  := "000";
	signal address      : std_logic_vector(3 downto 0)  := "0000";
	signal data_in      : std_logic_vector(24 downto 0) := "0000000000000000000000000";
	signal data_out     : std_logic_vector(24 downto 0) := "0000000000000000000000000";

begin

	-- Assigning Instructions
	process(clock)
	begin
		if rising_edge(clock) then
			if recv_data(31 downto 28) = "1001" then
				enable      <= recv_data(0);
				instruction <= recv_data(3 downto 1);
				address     <= recv_data(7 downto 4);
			end if;
		end if;
	end process;
	
	-- Reading Data
	process(clock)
	begin
		if rising_edge(clock) then
			if recv_data(31 downto 28) = "1000" and enable = '1' then
				data_in <= recv_data(24 downto 0);
			end if;
		end if;
	end process;
	
	-- Process Data
	calculation : entity work.sbol998_CalculationUnit 
	port map(
		clk => clock,
		enable => enable,
		instruction => instruction,
		data_in => data_in,
		data_out => data_out
	);
	
	-- Output
	send_addr <= "0000" & address when enable = '1' else  (others => '0');
	send_data <= "1000000" & data_out when enable = '1' else  (others => '0');
	
end architecture;