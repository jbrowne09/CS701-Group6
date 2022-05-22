library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity RecopALU is
	port (
		ALUop				: in std_logic_vector(2 downto 0);
		inA				: in std_logic_vector(15 downto 0);
		inB				: in std_logic_vector(15 downto 0);
		
		resultOut		: out std_logic_vector(15 downto 0);
		zero				: out std_logic
	);
end entity;


architecture rtl of RecopALU is
begin
	--ALUOP:
	--"000" = AND
	--"001" = OR
	--"010" = ADD
	--"011" = SUB
	--"100" = Shift_left_logical
	--"101" = Shift_right_logical
	process(inA, inB, ALUop)
	
		variable result : std_logic_vector(15 downto 0) := (others=>'0');
		
	begin
		case ALUop is
			when "000" =>
				result := inA and inB;
			when "001" =>
				result := inA or inB;
			when "010" =>
				result := std_logic_vector(signed(inA) + signed(inB));
			when "011" =>
				result := std_logic_vector(signed(inA) - signed(inB));
			when "100" =>
				result := std_logic_vector(shift_left(unsigned(inA), to_integer(unsigned(inB))));
			when "101" =>
				result := std_logic_vector(shift_right(unsigned(inA), to_integer(unsigned(inB))));
			when others =>
				result := (others => '0');
		end case;
		
		if result = "0000000000000000" then
			zero <= '1';
		else
			zero <= '0';
		end if;
		resultOut <= result;
		
	end process;
end architecture;