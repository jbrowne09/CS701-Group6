library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity NodeDac is
	port (
		clock : in  std_logic;
		full  : in  std_logic;
		put   : out std_logic;
		data  : out std_logic_vector(24 downto 0);

		send_addr : out tdma_min_addr;
		send_data : out tdma_min_data;
		recv_addr : in  tdma_min_addr;
		recv_data : in  tdma_min_data
	);
end entity;

architecture rtl of NodeDac is

	signal rate_0   : std_logic_vector(1 downto 0) := "00";
	signal rate_1   : std_logic_vector(1 downto 0) := "00";
	signal enable_0 : std_logic := '1';
	signal enable_1 : std_logic := '1';

begin

	process(clock)
	begin
		if rising_edge(clock) then

			if recv_data(31 downto 28) = "1011" then
				if recv_data(1) = '0' then
					rate_0   <= recv_data(3 downto 2);
					enable_0 <= recv_data(0);
				else
					rate_1   <= recv_data(3 downto 2);
					enable_1 <= recv_data(0);
				end if;
			end if;

		end if;
	end process;

	process(clock)
		variable tick_0 : unsigned(7 downto 0) := x"00";
		variable tick_1 : unsigned(7 downto 0) := x"00";
	begin
		if rising_edge(clock) then

			if recv_data(31 downto 28) = "1000" and recv_data(24) = '0' and enable_0 = '1' then
				if tick_0 /= 0 then
					tick_0 := tick_0 - 1;
					put <= '0';
					data <= (others => '0');
				else
					case rate_0 is
						when "11"   => tick_0 := x"ff";
						when "10"   => tick_0 := x"0f";
						when "01"   => tick_0 := x"03";
						when others => tick_0 := x"00";
					end case;
					put <= '1';
					data <= recv_data(24 downto 0);
				end if;
			elsif recv_data(31 downto 28) = "1000" and recv_data(24) = '1' and enable_1 = '1' then
				if tick_1 /= 0 then
					tick_1 := tick_1 - 1;
					put <= '0';
					data <= (others => '0');
				else
					case rate_1 is
						when "11"   => tick_1 := x"ff";
						when "10"   => tick_1 := x"0f";
						when "01"   => tick_1 := x"03";
						when others => tick_1 := x"00";
					end case;
					put <= '1';
					data <= recv_data(24 downto 0);
				end if;
			else
				put <= '0';
				data <= (others => '0');
			end if;

		end if;
	end process;

end architecture;
