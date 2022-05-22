library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_seloutput is
	port (
		clock : in std_logic;
		reset : in std_logic;
		linerData : in  std_logic_vector(23 downto 0);
		loadLinear : in std_logic;
		peakData : in  std_logic_vector(23 downto 0);
		loadPeak : in std_logic;
		sdata : in std_logic_vector(23 downto 0);
		direct : in std_logic;
		address2 : in std_logic_vector(3 downto 0);
		finalData : out std_logic_vector(31 downto 0);
		finalAddress : out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of Bwil410_seloutput is
begin

	process(clock)
	variable data : std_logic_vector(23 downto 0);
	begin
		if rising_edge(clock) then
			if(loadLinear = '1') then
				data := linerData;
			elsif (loadPeak = '1') then
				data := peakData;
			elsif (direct = '1') then
				data := sData;
			elsif(reset = '1') then
				data := "000000000000000000000000";
			else
				data := data;
			end if;
		end if;
		finalData <= "10000000" & data; 
		finalAddress <= "0000" & address2;
	end process;

end architecture;