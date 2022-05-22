library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestTopLevel is
	generic (
		nodes : positive := 8
	);
end entity;

architecture sim of TestTopLevel is

	signal clock : std_logic := '1';

	signal send_addrs : tdma_min_addrs(0 to nodes-1);
	signal send_datas : tdma_min_ports(0 to nodes-1);
	signal recv_addrs : tdma_min_addrs(0 to nodes-1);
	signal recv_datas : tdma_min_ports(0 to nodes-1);

begin

	clock <= not clock after 10 ns;

	tdma_min : entity work.TdmaMin
	generic map (
		nodes => nodes
	)
	port map (
		clock      => clock,
		send_addrs => send_addrs,
		send_datas => send_datas,
		recv_addrs => recv_addrs,
		recv_datas => recv_datas
	);

	node_audio : entity work.NodeAudio
	port map (
		clock     => clock,
		send_addr => send_addrs(2),
		send_data => send_datas(2),
		recv_addr => recv_addrs(2),
		recv_data => recv_datas(2)
	);

end architecture;
