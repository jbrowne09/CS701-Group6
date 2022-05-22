library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity sbol998_CalculationUnit is
	port (
		clk         : in std_logic;
		enable      : in std_logic;
		instruction : in std_logic_vector(2 downto 0);
		data_in     : in std_logic_vector(24 downto 0);
		data_out    : out std_logic_vector(24 downto 0));
end entity sbol998_CalculationUnit;

architecture rtl of sbol998_CalculationUnit is

	signal channel : std_logic := '0';
	signal register_one : std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal register_two : std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal register_three : std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal register_four : std_logic_vector(25 downto 0) := "00000000000000000000000000";
	signal output_holding : std_logic_vector(25 downto 0) := "00000000000000000000000000";
	
	signal output_sel   : std_logic_vector(1 downto 0) := "00";
	signal register_sel   : std_logic_vector(1 downto 0) := "00";
	signal register_reset   : std_logic_vector(3 downto 0) := "0000";
	signal register_enable   : std_logic_vector(3 downto 0) := "0000";
	signal shift_sel : std_logic := '0';
	
begin

	controller : entity work.sbol998_ASPController 
	port map(
		clk => clk,
		enable => enable,
		instruction => instruction,
		shift_sel => shift_sel,
		output_sel => output_sel,
		register_sel => register_sel,
		register_enable => register_enable,
		register_reset => register_reset);

	process(clk)
	begin
		if rising_edge(clk) then
			channel <= data_in(24);
			case output_sel is 
				when "01" =>
				
					if register_enable(0) = '1' then
						register_one <= std_logic_vector(unsigned(register_one) + unsigned(data_in));
					end if;
					if register_enable(1) = '1' then
						register_two <= std_logic_vector(unsigned(register_two) + unsigned(data_in));
					end if;
					if register_enable(2) = '1' then
						register_three <= std_logic_vector(unsigned(register_three) + unsigned(data_in));
					end if;
					if register_enable(3) = '1' then
						register_four <= std_logic_vector(unsigned(register_four) + unsigned(data_in));
					end if;
				
					case register_sel is
						when "00" =>
							output_holding <= register_one;
						when "01" =>
							output_holding <= register_two;
						when "10" =>
							output_holding <= register_three;
						when others =>
							output_holding <= register_four;
						end case;
						
						if shift_sel = '0' then
							data_out <= channel & output_holding(23 downto 0);
						else
							data_out <= channel & output_holding(25 downto 2);
						end if;
						
						if register_reset(0) = '1' then
							register_one <= "00000000000000000000000000";
						end if;
						if register_reset(1) = '1' then
							register_two <= "00000000000000000000000000";
						end if;
						if register_reset(2) = '1' then
							register_three <= "00000000000000000000000000";
						end if;
						if register_reset(3) = '1' then
							register_four <= "00000000000000000000000000";
						end if;
						
						
				when "10" =>
					if register_reset(0) = '1' then
						register_one <= "00000000000000000000000000";
					elsif register_enable(0) = '1' and register_one < data_in then
						register_one <= "00"&data_in(23 downto 0);
					end if;
					output_holding <= register_one;
					if shift_sel = '0' then
						data_out <= channel & output_holding(23 downto 0);
					else
						data_out <= channel & output_holding(25 downto 2);
					end if;
					
				when "11" =>
					if register_reset(0) = '1' then
						register_one <= "00000000000000000000000000";
					elsif register_enable(0) = '1' and register_one > data_in then
						register_one <= "00"&data_in(23 downto 0);
					end if;
					output_holding <= register_one;
					if shift_sel = '0' then
						data_out <= channel & output_holding(23 downto 0);
					else
					data_out <= channel & output_holding(25 downto 2);
					end if;
				when others =>
					data_out <= data_in;
					if register_reset = "1111" then
						register_one <= "00000000000000000000000000";
						register_two <= "00000000000000000000000000";
						register_three <= "00000000000000000000000000";
						register_four <= "00000000000000000000000000";
					end if;
			end case;
		end if;
	end process;
end architecture;