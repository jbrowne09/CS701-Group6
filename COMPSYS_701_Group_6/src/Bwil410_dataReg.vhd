library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_dataReg is
	port (
		clock : in std_logic;
		data : in  std_logic_vector(23 downto 0);
		enableData11 : in std_logic;
		sData12 : out std_logic_vector(23 downto 0);
		enabledd : out std_logic
	);
end entity;

architecture rtl of Bwil410_dataReg is
begin

	process(clock)
	variable Idata : std_logic_vector(23 downto 0);
	begin
		if rising_edge(clock) then
			if(enableData11 = '1') then
				Idata := data;
			else
				Idata := Idata;
			end if;
		end if;
		sData12 <= Idata;
		enabledd <= enableData11;
	end process;

end architecture;