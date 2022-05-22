library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Bwil410_peakDetection is
	port (
		clock : in std_logic;
		data : in  std_logic_vector(23 downto 0);
		peakMax : in std_logic;
		peakMin : in std_logic;
		enable : in std_logic;
		reset : in std_logic;
		outputData : out std_logic_vector(23 downto 0);
		loadData : out std_logic
	);
end entity;

architecture rtl of Bwil410_peakDetection is
begin

	process(clock)
	variable Count : unsigned(2 downto 0) := "000";
	variable Idata : std_logic_vector(23 downto 0);
	variable Odata : std_logic_vector(23 downto 0);
	variable load : std_logic;

	begin
		if rising_edge(clock) then
			if(reset = '1') then 
				Count := "000";
				Idata := "000000000000000000000000";
				load := '0';
				Odata := "000000000000000000000000";
			else
				if((peakMin = '1' or peakMax = '1') and enable = '1') then
					if(Count = "011") then
						if(data >= Odata) then
							if(peakMax = '1') then
								Odata := data;
							else
								Odata := Idata;
							end if;
						else
							if(peakMax = '1') then 
								Odata := Idata;
							else
								Odata := data;
							end if;
						end if;
						Count := "100";
						Idata := "000000000000000000000000";
						load := '1';
					elsif(Count = "100") then
						load := '1';
						Count := "100";
					elsif(Count = "000") then
						Count := Count + "001";
						Idata := data;
						load := '0';
					else 
						Count := Count + "001";
						if(data >= Odata) then
							if(peakMax = '1') then
								Idata := data;
							else
								Idata := Idata;
							end if;
						else
							if(peakMax = '1') then 
								Idata := Idata;
							else
								Idata := data;
							end if;
						end if;
						load := '0';
					end if;
				end if;
			end if;
		end if;
		loadData <= load;
		outputdata <= Odata;
	end process;

end architecture;