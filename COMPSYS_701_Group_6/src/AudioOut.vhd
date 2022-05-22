library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity AudioOut is
	port (
		clock  : in  std_logic;
		full   : out std_logic;
		put    : in  std_logic;
		data   : in  std_logic_vector(24 downto 0);

		bclk   : in  std_logic;
		dacdat : out std_logic;
		daclrc : in  std_logic
	);
end entity;

architecture rtl of AudioOut is

	signal fifo_get  : std_logic := '1';
	signal fifo_data : std_logic_vector(24 downto 0);

	signal channel_0 : std_logic_vector(23 downto 0);
	signal channel_1 : std_logic_vector(23 downto 0);
	signal shift     : std_logic_vector(23 downto 0);

begin

	fifo : entity ip.AudioFifo
	port map (
		data    => data,
		rdclk   => bclk,
		rdreq   => fifo_get,
		wrclk   => clock,
		wrreq   => put,
		q       => fifo_data,
		rdempty => open,
		wrfull  => full
	);

	process(bclk)
	begin
		if rising_edge(bclk) then

			if fifo_data(24) = '0' then
				channel_0 <= fifo_data(23 downto 0);
			else
				channel_1 <= fifo_data(23 downto 0);
			end if;

		end if;
	end process;

	process(bclk)
		variable last : std_logic;
	begin
		if rising_edge(bclk) then

			if daclrc /= last then
				if daclrc = '0' then
					shift <= channel_0;
				else
					shift <= channel_1;
				end if;
			else
				shift <= shift(22 downto 0) & '0';
			end if;
			last := daclrc;

		end if;
	end process;

	dacdat <= shift(23);

end architecture;
