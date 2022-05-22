library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinFabric is
	generic (
		stages : positive;
		nodes  : positive
	);
	port (
		slot       : in  std_logic_vector(stages-1 downto 0);
		ports_send : in  tdma_min_ports(0 to nodes-1);
		ports_recv : out tdma_min_ports(0 to nodes-1)
	);
end entity;

architecture rtl of TdmaMinFabric is

	signal link_10 : tdma_min_data;
	signal link_11 : tdma_min_data;
	signal link_12 : tdma_min_data;
	signal link_13 : tdma_min_data;
	signal link_14 : tdma_min_data;
	signal link_15 : tdma_min_data;
	signal link_16 : tdma_min_data;
	signal link_17 : tdma_min_data;
	signal link_20 : tdma_min_data;
	signal link_21 : tdma_min_data;
	signal link_22 : tdma_min_data;
	signal link_23 : tdma_min_data;
	signal link_24 : tdma_min_data;
	signal link_25 : tdma_min_data;
	signal link_26 : tdma_min_data;
	signal link_27 : tdma_min_data;

begin

	s00 : entity work.TdmaMinSwitch
	port map (
		s => slot(2),
		a => ports_send(0),
		b => ports_send(4),
		x => link_10,
		y => link_11
	);

	s01 : entity work.TdmaMinSwitch
	port map (
		s => slot(2),
		a => ports_send(1),
		b => ports_send(5),
		x => link_12,
		y => link_13
	);

	s02 : entity work.TdmaMinSwitch
	port map (
		s => slot(2),
		a => ports_send(2),
		b => ports_send(6),
		x => link_14,
		y => link_15
	);

	s03 : entity work.TdmaMinSwitch
	port map (
		s => slot(2),
		a => ports_send(3),
		b => ports_send(7),
		x => link_16,
		y => link_17
	);

	s10 : entity work.TdmaMinSwitch
	port map (
		s => slot(1),
		a => link_10,
		b => link_14,
		x => link_20,
		y => link_21
	);

	s11 : entity work.TdmaMinSwitch
	port map (
		s => slot(1),
		a => link_11,
		b => link_15,
		x => link_22,
		y => link_23
	);

	s12 : entity work.TdmaMinSwitch
	port map (
		s => slot(1),
		a => link_12,
		b => link_16,
		x => link_24,
		y => link_25
	);

	s13 : entity work.TdmaMinSwitch
	port map (
		s => slot(1),
		a => link_13,
		b => link_17,
		x => link_26,
		y => link_27
	);

	s20 : entity work.TdmaMinSwitch
	port map (
		s => slot(0),
		a => link_20,
		b => link_24,
		x => ports_recv(0),
		y => ports_recv(1)
	);

	s21 : entity work.TdmaMinSwitch
	port map (
		s => slot(0),
		a => link_21,
		b => link_25,
		x => ports_recv(2),
		y => ports_recv(3)
	);

	s22 : entity work.TdmaMinSwitch
	port map (
		s => slot(0),
		a => link_22,
		b => link_26,
		x => ports_recv(4),
		y => ports_recv(5)
	);

	s23 : entity work.TdmaMinSwitch
	port map (
		s => slot(0),
		a => link_23,
		b => link_27,
		x => ports_recv(6),
		y => ports_recv(7)
	);

end architecture;
