library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity sbol998_ASPController is
	port (
		clk         : in std_logic;
		enable      : in std_logic;
		instruction : in std_logic_vector(2 downto 0);
		shift_sel      : out std_logic;
		output_sel    : out std_logic_vector(1 downto 0);
		register_sel    : out std_logic_vector(1 downto 0);
		register_enable    : out std_logic_vector(3 downto 0);
		register_reset    : out std_logic_vector(3 downto 0));
end entity sbol998_ASPController;

architecture rtl of sbol998_ASPController is

	type state_type is (idle, direct_passthrough, linear_filter, max_peak, min_peak);  -- Define the states
	signal state : state_type := idle;
	signal next_state : state_type;
	signal operation_count : std_logic_vector(8 downto 0) := "000000000";
	signal cycle_count : std_logic_vector(1 downto 0) := "00";
begin


	process(clk)
	begin
		if enable = '0'  then
			state <= idle;
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process;
	
	process(state)
	begin
	case state is
		when idle =>
			case instruction is 
				when "000" =>
					next_state <= direct_passthrough;
				when "001" =>
					next_state <= linear_filter;
				when "010" =>
					next_state <= max_peak;
				when "011" =>
					next_state <= min_peak;
				when others =>
					next_state <= idle;
			end case;
			
		when direct_passthrough =>
			output_sel <= "00";
			register_enable <= "0000";
			register_reset <= "1111";
		when linear_filter =>
			shift_sel <= '1';
			if enable = '1' then
				if operation_count = "000000000" then
					register_enable <= "1000";
					cycle_count <= "00";
				elsif operation_count = "000000001" then
					register_enable <= "1100";
					cycle_count <= "00";
				elsif operation_count = "000000010" then
					register_enable <= "1110";
					cycle_count <= "00";
				elsif operation_count = "000000011" then
					register_enable <= "1111";
					cycle_count <= "00";
				elsif operation_count < "100000000" then
					register_reset <= "0000";
					operation_count <= std_logic_vector(unsigned(operation_count) + "000000001");
				
					if (cycle_count = "00") then
						register_sel <= "00";
						register_reset <= "1000";
						cycle_count <= "01";
					elsif (cycle_count = "01") then
						register_sel <= "01";
						register_reset <= "0100";
						cycle_count <= "10";
					elsif (cycle_count = "10") then
						register_sel <= "10";
						register_reset <= "0010";
						cycle_count <= "11";
					else
						register_sel <= "11";
						register_reset <= "0001";
						cycle_count <= "00";
					end if;
				else
					register_reset <= "1111";
					operation_count <= "000000000";
					cycle_count <= "00";
				end if;
			else
				register_enable <= "0000";
			end if;
			output_sel <= "01";
			
		when max_peak =>
			shift_sel <= '0';
			if enable = '1' then
				register_enable <= "1000";
			else
				register_enable <= "0000";
			end if;
			if operation_count < "100000000" then
				register_reset <= "0000";
				operation_count <= std_logic_vector(unsigned(operation_count) + "000000001");
			else
				register_reset <= "1000";
				operation_count <= "000000000";
			end if;
			output_sel <= "10";
			
		when min_peak =>
			shift_sel <= '0';
			if enable = '1' then
				register_enable <= "1000";
			else
				register_enable <= "0000";
			end if;
			if operation_count < "100000000" then
				register_reset <= "0000";
				operation_count <= std_logic_vector(unsigned(operation_count) + "000000001");
			else
				register_reset <= "1000";
				operation_count <= "000000000";
			end if;
			output_sel <= "11";
			
		when others =>
			next_state <= idle;
			
		end case;
	end process;
end architecture;