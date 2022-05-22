library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity DataMemory is
port (
	clock : in std_logic;
	memWrite : in std_logic;
	memRead  : in std_logic;
	address : in std_logic_vector(15 downto 0);
	writeData : in std_logic_vector(15 downto 0);
	readData : out std_logic_vector(15 downto 0)
);
end DataMemory;

architecture Behavior of DataMemory is
	type memoryArray is array (0 to 16) of std_logic_vector (15 downto 0);
begin
	process(clock) 
		variable memory: memoryArray;
	begin
		if(rising_edge(clock)) then
			if(memWrite = '1') then
				memory(to_integer(unsigned(address))) := writeData;
			elsif (memRead = '1') then
				readData <= memory(to_integer(unsigned(address)));
			else
				readData <= (others=>'0');
			end if;
		end if;
	end process;
end Behavior;