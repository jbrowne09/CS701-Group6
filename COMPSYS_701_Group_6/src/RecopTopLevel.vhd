library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

library work;
use work.TdmaMinTypes.all;  

entity RecopTopLevel is
port (
	clock				: in std_logic;
	
	recv_addr_top 	: in  tdma_min_addr;
	recv_data_top	: in  tdma_min_data;
	send_addr_top 	: out tdma_min_addr;
	send_data_top	: out tdma_min_data
);
end RecopTopLevel;


architecture rtl of RecopTopLevel is

	--lines in IF
	signal pc_top 				: std_logic_vector(15 downto 0);
	signal instruction_top	: std_logic_vector(31 downto 0);
	signal rx_top				: std_logic_vector(15 downto 0);
	signal rz_top				: std_logic_vector(15 downto 0);
	signal ioData_top			: std_logic_vector(15 downto 0);
	
	--lines in EX
	signal memReadEX_top		: std_logic;
	signal memWriteEX_top	: std_logic;
	signal ALUopin_top		: std_logic_vector(2 downto 0);
	signal ALUin1_top			: std_logic_vector(15 downto 0);
	signal ALUin2_top			: std_logic_vector(15 downto 0);
	signal result_top			: std_logic_vector(15 downto 0);
	signal zero_top			: std_logic;
	signal dataMemAddr_top	: std_logic_vector(15 downto 0);
	signal dataMemWrite_top	: std_logic_vector(15 downto 0);
	signal dataMemRead_top	: std_logic_vector(15 downto 0);
	signal AltB_top			: std_logic;
	
	--lines in WB	
	signal wbData_top			: std_logic_vector(15 downto 0);
	signal wbAddr_top			: std_logic_vector(3 downto 0);
	signal IOwbData_top		: std_logic_vector(15 downto 0);
	signal IOwbAddr_top		: std_logic_vector(3 downto 0);
	signal regWrite_out_top	: std_logic;
	signal IOwrite_out_top	: std_logic;
	
	--control signals (generated in IF stage)
	signal jump_top		: std_logic := '0';
	signal jumpSrc_top	: std_logic := '0';
	signal jumpCond_top	: std_logic := '0';
	signal clfz_top		: std_logic := '0';
	signal writeZ_top		: std_logic := '0';
	signal memRead_top	: std_logic := '0';
	signal memWrite_top	: std_logic := '0';
	signal dataSrc_top	: std_logic := '0';
	signal addrSrc_top	: std_logic := '0';
	signal ALUop_top		: std_logic_vector(2 downto 0) := "000";
	signal ALUsrc0_top	: std_logic := '0';
	signal ALUsrc1_top	: std_logic := '0';
	signal max_top			: std_logic := '0';
	signal IOwrite_top	: std_logic := '0';
	signal regWrite_top	: std_logic := '0';
	signal dataSel_top	: std_logic_vector(2 downto 0) := "000";
	signal IOsel_top		: std_logic := '0';
	signal flush_top		: std_logic;
	
begin
	-- Testbench instruction memory
	--IMem : entity work.RecopInstructionMemory
	--port map (
	--	clock       => clock,
	--	pc 			=> pc_top,
	--	instruction => instruction_top
	--);

	--module port maps here
	IMem : entity work.RecopInstructionMemory
	port map (
		clock       => clock,
		pc 			=> pc_top,
		instruction => instruction_top
	);
	
	ALU : entity work.RecopALU
	port map (
		ALUop 		=> ALUopin_top,
		inA			=> ALUin1_top,
		inB			=> ALUin2_top,
		resultOut	=> result_top,
		zero			=> zero_top
	);
	
	RegFile : entity work.RecopRegisterFile
	port map (
		clock 		=>	clock,
		RRegz 		=> instruction_top(23 downto 20),
		RRegx 		=> instruction_top(19 downto 16),
		WriteReg    => regWrite_out_top,
		WReg 		   => wbAddr_top,
		WData 		=> wbData_top,
		Rx 		   => rx_top,
		Rz  		   => rz_top
	);
	
	IORegFile : entity work.RecopIORegisterFile
	port map (
		clock 		=> clock,
		RAddr 		=> instruction_top(19 downto 16),
		WAddr 		=> IOwbAddr_top,
		WData 		=> IOwbData_top,	
		Data  		=> ioData_top,
		IOwrite		=> IOwrite_out_top,
		recv_addr 	=> recv_addr_top,
		recv_data 	=> recv_data_top,
		send_addr 	=> send_addr_top,
		send_data 	=> send_data_top
	);
	
	DataMemory : entity work.DataMemory
	port map(
		clock => clock,
		memWrite => memWriteEX_top,
		memRead => memReadEX_top,
		address => dataMemAddr_top,
		writeData => dataMemWrite_top,
		readData => dataMemRead_top
	);
	
	ControlBlock : entity work.RecopControlBlock
	port map(
		clock 			=> clock,
		instruction  	=> instruction_top(31 downto 24),
		jump_top		 	=> jump_top,
		jumpSrc_top	   => jumpSrc_top,
		jumpCond_top	=> jumpCond_top,
		clfz_top		 	=> clfz_top	,
		writeZ_top		=> writeZ_top,
		memRead_top	 	=> memRead_top,
		memWrite_top	=> memWrite_top,
		dataSrc_top	 	=> dataSrc_top,
		addrSrc_top	 	=> addrSrc_top,
		ALUop_top		=> ALUop_top,
		ALUsrc0_top	 	=> ALUsrc0_top,
		ALUsrc1_top	 	=> ALUsrc1_top,
		max_top			=> max_top,	
		IOwrite_top	 	=> IOwrite_top,
		regWrite_top	=> regWrite_top,
		dataSel_top	 	=> dataSel_top,
		IOsel_top		=> IOsel_top
	);

	process(clock)
	
		variable zReg : std_logic := '0';
		variable pc		:std_logic_vector(15 downto 0) := (others => '0');
		
		variable resultData_top	: std_logic_vector(15 downto 0);
		
		--pipeline inter-stage registers (IF_XX_EX indicates register
		--between IF and EX stages).
		--Data
		variable IF_instruction_EX	: std_logic_vector(31 downto 0);
		variable EX_instruction_WB	: std_logic_vector(31 downto 0);
		variable IF_rzAddr_EX		: std_logic_vector(3 downto 0);
		variable EX_rzAddr_WB		: std_logic_vector(3 downto 0);
		variable IF_rx_EX				: std_logic_vector(15 downto 0);
		variable EX_rx_WB				: std_logic_vector(15 downto 0);
		variable IF_rz_EX				: std_logic_vector(15 downto 0);
		variable IF_pc_EX				: std_logic_vector(15 downto 0);
		variable EX_pc_WB				: std_logic_vector(15 downto 0);
		variable IF_IOData_EX		: std_logic_vector(15 downto 0);
		variable EX_IOData_WB		: std_logic_vector(15 downto 0);
		variable EX_AltB_WB			: std_logic;
		variable EX_dataMemRead_WB	: std_logic_vector(15 downto 0);
		variable EX_result_WB		: std_logic_vector(15 downto 0);
		
		--Control
		variable IF_jump_EX			: std_logic;
		variable IF_jumpSrc_EX		: std_logic;
		variable IF_jumpCond_EX		: std_logic;
		variable IF_clfz_EX			: std_logic;
		variable IF_writeZ_EX		: std_logic;
		variable IF_memRead_EX		: std_logic;
		variable IF_memWrite_EX		: std_logic;
		variable IF_dataSrc_EX		: std_logic;
		variable IF_addrSrc_EX		: std_logic;
		variable IF_ALUop_EX			: std_logic_vector(2 downto 0);
		variable IF_ALUsrc0_EX		: std_logic;
		variable IF_ALUsrc1_EX		: std_logic;
		variable IF_max_EX			: std_logic;
		variable EX_max_WB			: std_logic;
		variable IF_IOwrite_EX		: std_logic;
		variable EX_IOwrite_WB		: std_logic;
		variable IF_regWrite_EX		: std_logic;
		variable EX_regWrite_WB		: std_logic;
		variable IF_dataSel_EX		: std_logic_vector(2 downto 0);
		variable EX_dataSel_WB		: std_logic_vector(2 downto 0);
		variable IF_IOsel_EX			: std_logic;
		variable EX_IOsel_WB			: std_logic;
		
	begin
		if IF_ALUsrc0_EX = '1' then
			ALUin1_top <= IF_rz_EX;
		else
			ALUin1_top <= IF_rx_EX;
		end if;
	
		if IF_ALUsrc1_EX = '1' then
			ALUin2_top <= IF_instruction_EX(15 downto 0);
		else
			ALUin2_top <= IF_rz_EX;
		end if;
		ALUopin_top <= IF_ALUop_EX;
			
		if (zReg = '1'
			and IF_jumpCond_EX = '1') or IF_jump_EX = '1' then
			flush_top <= '1';
			if IF_jumpSrc_EX = '1' then
				pc_top <= IF_instruction_EX(15 downto 0);
			else 
				pc_top <= IF_rx_EX;
			end if;
		else
			flush_top <= '0';
			pc_top <= pc;
		end if;
			
		if IF_addrSrc_EX = '1' then
			dataMemAddr_top <= IF_instruction_EX(15 downto 0);
		else
			dataMemAddr_top <= IF_rz_EX;
		end if;
		
		if IF_dataSrc_EX = '1' then
			dataMemWrite_top<= IF_instruction_EX(15 downto 0);
		else
			dataMemWrite_top <= IF_rx_EX;
		end if;
		
		if signed(IF_rz_EX) < signed(IF_instruction_EX(15 downto 0)) then
			AltB_top <= '1';
		else
			AltB_top <= '0';
		end if;
			
		--WB processing		
		case EX_dataSel_WB is
			when "000" =>
				resultData_top := EX_result_WB;
			when "001" =>
				resultData_top := EX_dataMemRead_WB;
			when "010" =>
				resultData_top := EX_pc_WB;
			when "011" =>
				resultData_top := EX_IOData_WB;
			when "100" =>
				resultData_top := EX_instruction_WB(15 downto 0);
			when others =>
				resultData_top := EX_result_WB;
		end case;
		
		if EX_AltB_WB = '1' and EX_max_WB = '1' then
			wbData_top <= EX_instruction_WB(15 downto 0);
		else
			wbData_top <= resultData_top;
		end if;
		wbAddr_top <= EX_rzAddr_WB;
			
		if EX_IOsel_WB = '1' then
			IOwbData_top <= EX_instruction_WB(15 downto 0);
		else
			IOwbData_top <= EX_rx_WB;
		end if;
		IOwbAddr_top <= EX_rzAddr_WB;
			
		if EX_regWrite_WB = '1' or (EX_AltB_WB = '1' and EX_max_WB = '1') then
			regWrite_out_top <= '1';
		else
			regWrite_out_top <= '0';
		end if;
		IOwrite_out_top <= EX_IOwrite_WB;
			
		memReadEX_top <= IF_memRead_EX;
		memWriteEX_top <= IF_memWrite_EX;
		
		if rising_edge(clock) then
			
			if IF_clfz_EX = '1' then
				zReg := '0';
			elsif IF_writeZ_EX = '1' then
				zReg := zero_top;
			end if;
			
			--IF processing & pipeline flush
			if flush_top = '1' then			
				--flush pipeline on jump
				--Data
				IF_instruction_EX	:= (others => '0');
				EX_instruction_WB	:= (others => '0');
				IF_rzAddr_EX		:= (others => '0');
				EX_rzAddr_WB		:= (others => '0');
				IF_rx_EX				:= (others => '0');
				EX_rx_WB				:= (others => '0');
				IF_rz_EX				:= (others => '0');
				IF_pc_EX				:= (others => '0');
				EX_pc_WB				:= (others => '0');
				IF_IOData_EX		:= (others => '0');
				EX_IOData_WB		:= (others => '0');
				EX_AltB_WB			:= '0';
				EX_dataMemRead_WB	:= (others => '0');
				EX_result_WB		:= (others => '0');
		
				--Control
				IF_jump_EX			:= '0';
				IF_jumpSrc_EX		:= '0';
				IF_jumpCond_EX		:= '0';
				IF_clfz_EX			:= '0';
				IF_writeZ_EX		:= '0';
				IF_memRead_EX		:= '0';
				IF_memWrite_EX		:= '0';
				IF_dataSrc_EX		:= '0';
				IF_addrSrc_EX		:= '0';
				IF_ALUop_EX			:= "000";
				IF_ALUsrc0_EX		:= '0';
				IF_ALUsrc1_EX		:= '0';
				IF_max_EX			:= '0';
				EX_max_WB			:= '0';
				IF_IOwrite_EX		:= '0';
				EX_IOwrite_WB		:= '0';
				IF_regWrite_EX		:= '0';
				EX_regWrite_WB		:= '0';
				IF_dataSel_EX		:= "000";
				EX_dataSel_WB		:= "000";
				IF_IOsel_EX			:= '0';
				EX_IOsel_WB			:= '0';
			else
				--shift control signals along the pipeline (order is important
				--WB regs must be written before IF regs otherwise values will
				--be incorrect).
				--Data
				EX_instruction_WB := IF_instruction_EX;
				IF_instruction_EX := instruction_top;
				EX_rzAddr_WB		:= IF_rzAddr_EX;
				IF_rzAddr_EX		:= instruction_top(23 downto 20);
				EX_rx_WB				:= IF_rx_EX;
				IF_rx_EX				:= rx_top;
				IF_rz_EX				:= rz_top;
				EX_pc_WB				:= IF_pc_EX;
				IF_pc_EX				:= pc_top;
				EX_IOData_WB		:= IF_IOData_EX;
				IF_IOData_EX		:= ioData_top;
				EX_AltB_WB			:= AltB_top;
				EX_dataMemRead_WB	:= dataMemRead_top;
				EX_result_WB		:= result_top;
					
				--Control
				IF_jump_EX			:= jump_top;
				IF_jumpSrc_EX		:= jumpSrc_top;
				IF_jumpCond_EX		:= jumpCond_top;
				IF_clfz_EX			:= clfz_top;
				IF_writeZ_EX		:= writeZ_top;
				IF_memRead_EX		:= memRead_top;
				IF_memWrite_EX		:= memWrite_top;
				IF_dataSrc_EX		:= dataSrc_top;
				IF_addrSrc_EX		:= addrSrc_top;
				IF_ALUop_EX			:= ALUop_top;
				IF_ALUsrc0_EX		:= ALUsrc0_top;
				IF_ALUsrc1_EX		:= ALUsrc1_top;
				EX_max_WB			:= IF_max_EX;
				IF_Max_EX			:= max_top;
				EX_IOwrite_WB		:= IF_IOwrite_EX;
				IF_IOwrite_EX		:= IOwrite_top;
				EX_regWrite_WB		:= IF_regWrite_EX;
				IF_regWrite_EX		:= regWrite_top;
				EX_dataSel_WB		:= IF_dataSel_EX;
				IF_dataSel_EX		:= dataSel_top;
				EX_IOsel_WB			:= IF_IOsel_EX;
				IF_IOsel_EX			:= IOsel_top;
			end if;
			
			pc := std_logic_vector(unsigned(pc_top) + to_unsigned(1, 16));
		end if;
	end process;

end architecture;