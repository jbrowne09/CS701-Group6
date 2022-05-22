library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


library work;
use work.TdmaMinTypes.all;

entity jbro682_ASP is
	port (
		clock			: in    	std_logic;
		
		recv_data	: in 		tdma_min_data;
		recv_addr	: in		tdma_min_addr;
		send_data	: out		tdma_min_data;
		send_addr	: out 	tdma_min_addr
	);
end entity;

architecture rtl of jbro682_ASP is

	signal data_count	: integer := 1;
	signal tar_addr	: std_logic_vector(3 downto 0) := "0000";
	signal mode			: std_logic_vector(2 downto 0) := "000";	
	signal enable 		: std_logic := '0';
	signal reset		: std_logic := '0';
	
begin

	process(recv_data)
	begin
		if recv_data(31 downto 28) = "1001" then
			tar_addr <= recv_data(7 downto 4);
			enable <= recv_data(0);
			mode <= recv_data(3 downto 1);
			reset <= '1';
		else
			reset <= '0';
		end if;
	end process;
	
	process(clock)
	
		variable data			: signed(23 downto 0) 	:= (others => '0');
		variable data_result	: signed(23 downto 0) 	:= (others => '0');
		variable accum			: signed(47 downto 0) 	:= (others => '0');
		variable min_peak		: signed(23 downto 0) 	:= (others => '0');
		variable max_peak		: signed(23 downto 0) 	:= (others => '0');
		variable corr_count	: integer 	:= 1;
		variable array_count	: integer 	:= 1;
		variable output_corr	: integer 	:= 1;
		
		type array_struct is
			array(1 to 28) of signed(23 downto 0);
		
		type corr_struct is
			array(1 to 19) of signed(23 downto 0);
		
		variable data_array		: array_struct;
		variable shift_array		: array_struct;
		variable corr_array		: corr_struct;
		
	begin
		if rising_edge(clock) then
		
			if recv_data(31 downto 28) = "1000" and enable = '1' and data_count < 11 then
				data := signed(recv_data(23 downto 0));
							
				case mode is
					when "000" => --Direct Passthrough
						data_result := data;
						send_data <= "1000000" & recv_data(24) & std_logic_vector(data_result);
						
					when "001" => --Linear Filter
						if data_count > 3 then
							data_result := data + data_array(1) + data_array(2) + data_array(3);
							data_result := shift_right(signed(data_result), 2);
						
							data_array(1) := data_array(2);
							data_array(2) := data_array(3);
							data_array(3) := data;
							send_data <= "1000000" & recv_data(24) & std_logic_vector(data_result);
						else
							data_array(data_count) := data;
							send_data <= (others => '0');
						end if;
						
					when "010" => --Maximum peak detection
						if data_count = 1 then
							max_peak := data;
						else
							if data > max_peak then
								max_peak := data;
							end if;
						end if;
						data_result := max_peak;
						send_data <= "1000000" & recv_data(24) & std_logic_vector(data_result);
					
					when "011" => --Minimum peak detection
						if data_count = 1 then
							min_peak := data;
						else
							if data < min_peak then
								min_peak := data;
							end if;
						end if;
						data_result := min_peak;
						send_data <= "1000000" & recv_data(24) & std_logic_vector(data_result);
						
					when "100" => --Autocorrelation
						if data_count = 1 then
							init_loop : for i in 1 to 28 loop
								data_array(i) := (others => '0');
								shift_array(i) := (others => '0');
							end loop init_loop;
						end if;
						data_array(data_count+9) := data;
						shift_array(data_count) := data;
						send_data <= (others => '0');
						
					when others =>
						null;
						
				end case;
				
				if reset = '1' then
					data_count <= 1;
				elsif mode = "100" and data_count < 11 then
					data_count <= data_count + 1;
				elsif data_count < 4 then
					data_count <= data_count + 1;
				end if;
				send_addr <= "0000" & tar_addr;	
			elsif enable = '1' then
				case mode is
					when "010" =>
						send_data <= "1000000" & recv_data(24) & std_logic_vector(max_peak);
					when "011" =>
						send_data <= "1000000" & recv_data(24) & std_logic_vector(min_peak);
					when "100" =>
						if data_count > 10 and corr_count < 20 then
						
							if array_count < 29 then
								accum := accum + data_array(array_count)*shift_array(array_count);
								array_count := array_count + 1;
							else
								shift_loop: for i in 28 downto 2 loop
									shift_array(i) := shift_array(i-1);
								end loop shift_loop;
								shift_array(1) := (others => '0');
								
								corr_array(corr_count) := resize(signed(accum), 24);
								
								corr_count := corr_count + 1;
								array_count := 1;
								accum := (others => '0');
							end if;
							
							send_data <= (others => '0');
						else 						
							if output_corr < 20 then
								data_result := corr_array(output_corr);
								
								send_data <= "1000000" & recv_data(24) & std_logic_vector(data_result);
								output_corr := output_corr + 1;
							else
								data_count <= 1;
								corr_count := 1;
								array_count := 1;
								output_corr := 1;
								accum := (others => '0');
								send_data <= (others => '0');
							end if;
						end if;
						
					when others =>
						send_data <= (others => '0');
				end case;
				send_addr <= "0000" & tar_addr;
			else
				send_data <= (others => '0');
				send_addr <= (others => '0');
			end if;	
		end if;
	end process;
	
end architecture;