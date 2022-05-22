library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_Config is
	port (
		clock : in std_logic;
		data : in  std_logic_vector(3 downto 0);
		enableASP : in std_logic;
		config2 : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of Bwil410_Config is
begin

	process(clock)
	variable Iconfig : std_logic_vector(3 downto 0);
	begin
		if rising_edge(clock) then
			if(enableASP = '1') then
				Iconfig := data;
			else
				Iconfig := Iconfig;
			end if;
		end if;
		config2 <= Iconfig; 
	end process;

end architecture;