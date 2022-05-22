library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity NodeAudio is
	port (
		clock     : in  std_logic;
		send_addr : out tdma_min_addr;
		send_data : out tdma_min_data;
		recv_addr : in  tdma_min_addr;
		recv_data : in  tdma_min_data
	);
end entity;

architecture sim of NodeAudio is
begin

	send_addr <= x"00";

	process
		type binary is file of integer;
		file audio : binary;
		variable word : integer;
		variable data : std_logic_vector(31 downto 0);
	begin
		file_open(audio, "..\..\audio\awakened-forest_146970.raw", read_mode);
		while not endfile(audio) loop
			read(audio, word);
			data := std_logic_vector(to_signed(word, 32));
			send_data <= "10000000" & data(15 downto 0)  & "00000000";
			wait for 20 ns;
			send_data <= "10000001" & data(31 downto 16) & "00000000";
			wait for 20 ns;
			send_data <= (others => '0');
			wait for 280 ns;
		end loop;
		file_close(audio);
	end process;

end architecture;
