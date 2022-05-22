library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

library work;

entity MagnitudeComparator is
port (
	A		: in std_logic_vector(15 downto 0);
	B		: in std_logic_vector(15 downto 0);
	AltB		: out std_logic
);
end MagnitudeComparator;

architecture rtl of MagnitudeComparator is
begin
	AltB <= '1' when A < B else '0';
end architecture;