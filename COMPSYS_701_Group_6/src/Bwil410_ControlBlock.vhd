library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_ControlBlock is
	port (
		data : in  std_logic_vector(2 downto 0);
		clock : in std_logic;
		enable : in std_logic;
		filter : out std_logic;
		peakMax : out std_logic;
		peakMin : out std_logic;
		direct : out std_logic;
		reset : out std_logic
		
	);
end entity;

architecture rtl of Bwil410_ControlBlock is
TYPE State_type IS (idle, pass, linear, peakMa, peakMi);
signal state : state_type := idle;
begin

	process(clock)
	variable currentState : state_type := idle;
	variable idirect, ifilter, ipeakMax, ipeakMin : std_logic;
	variable Ireset : std_logic;
	begin
		if rising_edge(clock) then
			if(enable = '0') then
				state <= idle;
				reset <= '1';
			else
				case data is
					when "000" => state <= pass;
					when "001" => state <= linear;
					when "010" => state <= peakMa;
					when "011" => state <= peakMi;
					when others => state <= idle;
				end case;
				if(state = idle) then
					direct <= '0';
					filter <= '0';
					peakMax <= '0';
					peakMin <= '0';
					reset <= '1';
				elsif(state = pass) then
					direct <= '1';
					filter <= '0';
					peakMax <= '0';
					peakMin <= '0';
					reset <= '0';
				elsif(state = linear) then
					direct <= '0';
					filter <= '1';
					peakMax <= '0';
					peakMin <= '0';
					reset <= '0';
				elsif(state = peakMa) then
					direct <= '0';
					filter <= '0';
					peakMax <= '1';
					peakMin <= '0';
					reset <= '0';
				elsif(state = peakMi) then
					direct <= '0';
					filter <= '0';
					peakMax <= '0';
					peakMin <= '1';
					reset <= '0';
				end if;
			end if;
		end if;
	end process;

end architecture;