library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity NodeIo is
	port (
		clock : in  std_logic;
		key   : in  std_logic_vector(3 downto 0);
		sw    : in  std_logic_vector(9 downto 0);
		ledr  : out std_logic_vector(9 downto 0);
		hex0  : out std_logic_vector(6 downto 0);
		hex1  : out std_logic_vector(6 downto 0);
		hex2  : out std_logic_vector(6 downto 0);
		hex3  : out std_logic_vector(6 downto 0);
		hex4  : out std_logic_vector(6 downto 0);
		hex5  : out std_logic_vector(6 downto 0);

		send_addr : out tdma_min_addr;
		send_data : out tdma_min_data;
		recv_addr : in  tdma_min_addr;
		recv_data : in  tdma_min_data
	);
end entity;

architecture rtl of NodeIo is

	signal hexn : std_logic_vector(23 downto 0);

begin
	--Recieving Data
	process(clock)
	begin
		if rising_edge(clock) then
			if recv_data(31 downto 28) = "1000" and recv_data(24) = '0' then
				hexn <= recv_data(23 downto 0);
			elsif recv_data(31 downto 28) = "1000" and recv_data(24) = '1' then
				hexn <= recv_data(23 downto 0);
			end if;
		end if;
	end process;
	
	--Sending Data
	process(clock)
	begin
		if rising_edge(clock) then
			send_addr <= "00000001";
			send_data <= "1000" & "00000000000000" & sw & key;
		end if;
	end process;	
	
	hs6 : entity work.HexSeg6
	port map (
		hexn => hexn,
		seg0 => hex0,
		seg1 => hex1,
		seg2 => hex2,
		seg3 => hex3,
		seg4 => hex4,
		seg5 => hex5
	);

end architecture;
