library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;  

entity testbench_RecopInstructionMemory is
	port (
		clock: in std_logic;
		pc: in std_logic_vector(15 downto 0);
		instruction: out  std_logic_vector(31 downto 0)
	);
end testbench_RecopInstructionMemory;

architecture Behavior of testbench_RecopInstructionMemory is

begin
	process(clock) 
	
		type reg_type is array(0 to 16) of std_logic_vector(31 downto 0);
			
		variable reg_array: reg_type := 
						 ("00010110000000000000000000000000",
						  "00010110000000000000000000000000",
						  "00001110000000000000000000001000",
						  "00010010100100000000000000000101",
						  "00010010100000000000000000000110",
						  "00010110000000000000000000000000",
						  "00010110000000000000000000000000",
						  "00010110000000000000000000000000",
						  "00010010011100000000000000000111",
						  "00010010011000000000000000001000",
						  "00010010010100000000000000001001",
						  "00010010010000000000000000001010");
	begin
		if(rising_edge(clock)) then
			instruction <= reg_array(to_integer(unsigned(pc)));
		end if;
	end process;
end Behavior;