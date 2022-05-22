library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity RecopRegisterFile is
port (
	clock 				: in std_logic;
	RRegz, RRegx, WReg: in std_logic_vector(3 downto 0);
	WriteReg 			: in std_logic;
	WData 				: in std_logic_vector(15 downto 0);
	Rx, Rz 				: out std_logic_vector(15 downto 0)
);
end RecopRegisterFile;


architecture rtl of RecopRegisterFile is
begin
	process(clock) 
	
		type reg_type is
			array(1 to 16) of std_logic_vector(15 downto 0);
			
		variable reg_array: reg_type;
		
	begin
		if(rising_edge(clock)) then
			if(WriteReg = '1') then
				reg_array(to_integer(unsigned(WReg))) := WData;
			end if;
		end if;
		
		if RRegz /= "0000" then
			Rz <=  reg_array(to_integer(unsigned(RRegz)));
		else
			Rz <= (others => '0');
		end if;
		if RRegx /= "0000" then
			Rx <=  reg_array(to_integer(unsigned(RRegx)));
		else
			Rx <= (others => '0');
		end if;
	end process;

end architecture;