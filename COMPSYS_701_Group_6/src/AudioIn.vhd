library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

entity AudioIn is
	port (
		clock  : in  std_logic;
		empty  : out std_logic;
		get    : in  std_logic;
		data   : out std_logic_vector(24 downto 0);

		bclk   : in  std_logic;
		adcdat : in  std_logic;
		adclrc : in  std_logic
	);
end entity;

architecture rtl of AudioIn is

	signal fifo_put  : std_logic := '0';
	signal fifo_data : std_logic_vector(24 downto 0);

begin

	fifo : entity ip.AudioFifo
	port map (
		data    => fifo_data,
		rdclk   => clock,
		rdreq   => get,
		wrclk   => bclk,
		wrreq   => fifo_put,
		q       => data,
		rdempty => empty,
		wrfull  => open
	);

	process(bclk)
		variable last : std_logic;
		variable bits : std_logic_vector(29 downto 0);
	begin
		if rising_edge(bclk) then

			if adclrc /= last then
				fifo_put  <= '1';
				fifo_data <= last & bits(29 downto 6);
			else
				fifo_put  <= '0';
				fifo_data <= (others => '0');
			end if;

			last := adclrc;
			bits := bits(28 downto 0) & adcdat;

		end if;
	end process;

end architecture;
