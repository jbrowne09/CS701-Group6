library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;  

entity RecopInstructionMemory is
	port (
		clock: in std_logic;
		pc: in std_logic_vector(15 downto 0);
		instruction: out  std_logic_vector(31 downto 0)
	);
end RecopInstructionMemory;

architecture Behavior of RecopInstructionMemory is

	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			   : STRING;
		clock_enable_input_a	   : STRING;
		clock_enable_output_a	: STRING;
		init_file				   : STRING;
		intended_device_family	: STRING;
		lpm_hint			      	: STRING;
		lpm_type				      : STRING;
		numwords_a			   	: NATURAL;
		operation_mode			   : STRING;
		outdata_aclr_a			   : STRING;
		outdata_reg_a		   	: STRING;
		widthad_a				   : NATURAL;
		width_a					   : NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	END COMPONENT;

begin
	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "instructions.mif",
		intended_device_family => "Cyclone V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 53,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 16,
		width_a => 32,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => pc,
		q_a => instruction
	);

end Behavior;