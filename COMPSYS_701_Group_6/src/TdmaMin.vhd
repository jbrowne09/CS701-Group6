library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMin is
	generic (
		nodes : positive
	);
	port (
		clock      : in  std_logic;
		send_addrs : in  tdma_min_addrs(0 to nodes-1);
		send_datas : in  tdma_min_ports(0 to nodes-1);
		recv_addrs : out tdma_min_addrs(0 to nodes-1);
		recv_datas : out tdma_min_ports(0 to nodes-1)
	);
end entity;

architecture rtl of TdmaMin is

	constant stages : positive := log2Ceil(nodes);

	signal slot       : std_logic_vector(stages-1 downto 0);
	signal ports_send : tdma_min_ports(0 to nodes-1);
	signal ports_recv : tdma_min_ports(0 to nodes-1);

begin

	slots : entity work.TdmaMinSlots
	generic map (
		stages => stages
	)
	port map (
		clock => clock,
		slot  => slot
	);

	fabric : entity work.TdmaMinFabric
	generic map (
		stages => stages,
		nodes  => nodes
	)
	port map (
		slot       => slot,
		ports_send => ports_send,
		ports_recv => ports_recv
	);

	interfaces : for identity in 0 to nodes-1 generate
		interface : entity work.TdmaMinInterface
		generic map (
			stages   => stages,
			identity => identity
		)
		port map (
			clock     => clock,
			slot      => slot,
			noc_send  => ports_send(identity),
			noc_recv  => ports_recv(identity),

			send_addr => send_addrs(identity),
			send_data => send_datas(identity),
			recv_addr => recv_addrs(identity),
			recv_data => recv_datas(identity)
		);
	end generate;

end architecture;
