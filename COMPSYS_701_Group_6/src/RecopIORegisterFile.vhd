library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

library work;
use work.TdmaMinTypes.all;


entity RecopIORegisterFile is
port (
	clock			: in std_logic;
	RAddr, WAddr: in std_logic_vector(3 downto 0);
	WData 		: in std_logic_vector(15 downto 0);
	IOwrite 		: in std_logic;
	Data 			: out std_logic_vector(15 downto 0);
 
 	recv_addr 	: in  tdma_min_addr;
	recv_data 	: in  tdma_min_data;
	send_addr 	: out tdma_min_addr;
	send_data 	: out tdma_min_data
);
end RecopIORegisterFile;

architecture Behavior of RecopIORegisterFile is
	signal debug : std_logic_vector(3 downto 0) := "0000";
begin
	process(clock) 
		type reg_type is
			array(1 to 11) of std_logic_vector(15 downto 0);
			
		variable reg_array: reg_type;
	begin
		debug <= reg_array(1)(15 downto 12);
	
		if(rising_edge(clock)) then
		
			if recv_data(31 downto 28) = "1000" then
				reg_array(10) := "000000" & recv_data(13 downto 4);
				reg_array(11) := "000000000000" & recv_data(3 downto 0);
			end if;
			
			if IOwrite = '1' then
				reg_array(to_integer(unsigned(WAddr))) := WData;
			end if;
			
			if IOwrite = '1' and WAddr = "0010" then
				if reg_array(3)(3 downto 0) /= "0000" and 
				reg_array(3)(3 downto 0) /= "0001" then
					send_data <= reg_array(1) & reg_array(2);
					send_addr <= reg_array(3)(7 downto 0);
				
					reg_array(6)(3 downto 0) := reg_array(3)(3 downto 0);
					reg_array(5)(3 downto 0) := '0' & reg_array(2)(3 downto 1);
					reg_array(4)(3 downto 0) := reg_array(1)(15 downto 12) and "0011";
				end if;
			else
				send_data <= "10000000" & reg_array(9)(3 downto 0) & 
				reg_array(8)(3 downto 0) & reg_array(7)(3 downto 0) & 
				reg_array(6)(3 downto 0) & reg_array(5)(3 downto 0) & 
				reg_array(4)(3 downto 0);
				send_addr <= (others => '0');
			end if;
		end if;
		
		if RAddr /= "0000" then
			Data <=  reg_array(to_integer(unsigned(RAddr)));
		else
			Data <= (others => '0');
		end if;
	end process;
end architecture;