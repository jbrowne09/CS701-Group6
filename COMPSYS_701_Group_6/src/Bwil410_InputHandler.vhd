library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_InputHandler is
	port (
		inputi : in  std_logic_vector(31 downto 0);
		enableData7 : out std_logic;
		enableASP4 : out std_logic;
		dataOut : out std_logic_vector(31 downto 0)
	);
end entity;

architecture rtl of Bwil410_InputHandler is
begin

	process(inputi)
		variable ED : std_logic;
		variable EA : std_logic;
	begin
		case inputi(30 downto 28) is
			when "000" => ED := '1'; EA := '0'; 
			when "001" => EA := '1'; ED := '0';
			when others => ED := '0'; EA := '0'; 
		end case;
	enableData7 <= ED;
	enableASP4 <= EA;
	end process;
	
	dataOut <= inputi;
end architecture;