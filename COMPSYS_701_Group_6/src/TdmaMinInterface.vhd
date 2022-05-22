library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library ip;

library work;
use work.TdmaMinTypes.all;

entity TdmaMinInterface is
	generic (
		stages   : positive;
		identity : natural
	);
	port (
		clock     : in  std_logic;
		slot      : in  std_logic_vector(stages-1 downto 0);
		noc_send  : out tdma_min_data;
		noc_recv  : in  tdma_min_data;

		send_addr : in  tdma_min_addr;
		send_data : in  tdma_min_data;
		recv_addr : out tdma_min_addr;
		recv_data : out tdma_min_data
	);
end entity;

architecture rtl of TdmaMinInterface is

	constant id     : tdma_min_addr := std_logic_vector(to_unsigned(identity, tdma_min_addr'length));
	signal noc_addr : tdma_min_addr;

	signal fifo_empty : std_logic;
	signal fifo_req   : std_logic := '0';
	signal fifo_ack   : std_logic := '0';
	signal fifo_enqu  : tdma_min_fifo;
	signal fifo_dequ  : tdma_min_fifo;

	signal next_addr : tdma_min_addr;
	signal next_data : tdma_min_data;
	signal ready     : boolean;

begin

	noc_addr <= id xor (tdma_min_addr'high downto stages => '0') & slot;

	fifo : entity ip.TdmaMinFifo
	port map (
		clock => clock,
		data  => fifo_enqu,
		rdreq => fifo_ack,
		wrreq => fifo_req,
		q     => fifo_dequ,
		empty => fifo_empty,
		full  => open
	);

	-- Send interface connected to fifo
	fifo_enqu <= send_addr & send_data;
	fifo_req  <= send_data(send_data'high);

	-- Next packet for network
	next_addr <= fifo_dequ(fifo_dequ'high downto next_data'length);
	next_data <= fifo_dequ(next_data'range);

	-- Wait for network circuit
	ready    <= fifo_empty = '0' and next_addr = noc_addr;
	fifo_ack <= '1' when ready else '0';
	noc_send <= next_data when ready else (others => '0');

	-- Receive interface connected to network
	recv_addr <= noc_addr;
	recv_data <= noc_recv;

end architecture;
