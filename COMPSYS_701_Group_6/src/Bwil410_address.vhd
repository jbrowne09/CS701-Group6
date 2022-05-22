library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_address is
	port (
		clock : in std_logic;
		data : in  std_logic_vector(3 downto 0);
		enableASP : in std_logic;
		address1 : out std_logic_vector(3 downto 0)
	);
end entity;

architecture rtl of Bwil410_address is
begin

	process(clock)
	variable Iaddress : std_logic_vector(3 downto 0);
	begin
		if rising_edge(clock) then
			if(enableASP = '1') then
				Iaddress := data;
			else
				Iaddress := Iaddress;
			end if;
		end if;
		address1 <= Iaddress;
	end process;

end architecture;