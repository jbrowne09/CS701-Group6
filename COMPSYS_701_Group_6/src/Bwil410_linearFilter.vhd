library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_linearFilter is
	port (
		clock : in std_logic;
		data : in  std_logic_vector(23 downto 0);
		linear : in std_logic;
		reset : in std_logic;
		enable : in std_logic;
		outputData : out std_logic_vector(23 downto 0);
		loadData : out std_logic
	);
end entity;

architecture rtl of Bwil410_linearFilter is
begin

	process(clock)
	variable Count : unsigned(2 downto 0) := "000";
	variable Idata : signed(23 downto 0);
	variable Odata : signed(23 downto 0);
	variable load : std_logic;

	begin
		if rising_edge(clock) then
			if(reset = '1') then 
				Count := "000";
				Idata := "000000000000000000000000";
				Odata := "000000000000000000000000";
				load := '0';
			else
				if(linear = '1' and enable = '1') then
					if(Count = "011") then
						Odata := shift_right(signed(signed(Idata) + signed(data)), 2);
						Count := "100";
						Idata := "000000000000000000000000";
						load := '1';
					elsif(Count = "100") then
						Count := "100";
						load := '1';
					else
						Count := Count + "001";
						Idata := signed(data) + signed(Idata);
						load := '0';
					end if;
				end if;
			end if;
		end if;
		loadData <= load;
		outputdata <= std_logic_vector(Odata);
	end process;

end architecture;