library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity RecopControlBlock is
	port (
		clock : in std_logic;
		instruction : in std_logic_vector(7 downto 0);
		jump_top		: out std_logic;
		jumpSrc_top	: out std_logic;
		jumpCond_top	: out std_logic;
		clfz_top		: out std_logic;
		writeZ_top		: out std_logic;
		memRead_top	: out std_logic;
		memWrite_top	: out std_logic;
		dataSrc_top	: out std_logic;
		addrSrc_top	: out std_logic;
		ALUop_top		: out std_logic_vector(2 downto 0);
		ALUsrc0_top	: out std_logic;
		ALUsrc1_top	: out std_logic;
		max_top			: out std_logic;
		IOwrite_top	: out std_logic;
		regWrite_top	: out std_logic;
		dataSel_top	: out std_logic_vector(2 downto 0);
		IOsel_top		: out std_logic
	);
end entity;

architecture rtl of RecopControlBlock is
	
begin
 process(instruction) 
	variable jump_top_t		: std_logic;
	variable jumpSrc_top_t	: std_logic;
	variable jumpCond_top_t : std_logic;
	variable clfz_top_t		: std_logic;
	variable writeZ_top_t		: std_logic;
	variable memRead_top_t	: std_logic;
	variable memWrite_top_t	: std_logic;
	variable dataSrc_top_t	: std_logic;
	variable addrSrc_top_t	: std_logic;
	variable ALUop_top_t		: std_logic_vector(2 downto 0);
	variable ALUsrc0_top_t	: std_logic;
	variable ALUsrc1_top_t	: std_logic;
	variable max_top_t			: std_logic;
	variable IOwrite_top_t	: std_logic;
	variable regWrite_top_t	: std_logic;
	variable dataSel_top_t	: std_logic_vector(2 downto 0);
	variable IOsel_top_t		: std_logic;

 begin
	case instruction is
			when "00000000" => 
			--AND Rz Rx #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000001" => 
			--AND Rz Rz Rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000010" => 
			--OR Rz Rx #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "001";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000011" => 
			--OR Rz Rz Rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "001";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000100" => 
			--ADD Rz Rx #Operand 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "010";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000101" => 
			--ADD Rz Rz Rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "010";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000110" => 
			--SUBV Rz Rx #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "011";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00000111" => 
			--SUB Rz #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "011";
				ALUsrc0_top_t	:= '1';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00001000" => 
			--LDR Rz #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "100";
				IOsel_top_t		:= '0';
			when "00001001" => 
			--LDR Rz Rx 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '1';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "001";
				IOsel_top_t		:= '0';
			when "00001010" => 
			--LDR Rz $Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '1';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '1';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "001";
				IOsel_top_t		:= '0';
			when "00001011" => 
			--STR Rz #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '1';
				dataSrc_top_t	:= '1';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00001100" => 
			--STR Rz Rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '1';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00001101" => 
			--STR Rx $Operand 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '1';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '1';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00001110" => 
			--JMP #Operand 
				jump_top_t		:= '1';
				jumpSrc_top_t	:= '1';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00001111" => 
			--JMP Rx
				jump_top_t		:= '1';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010000" =>  
			--IOWrite rz rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '1';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010001" => 
			--IOWrite rz #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '1';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '1';
			when "00010010" => 
			--IORead rz rx
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "011";
				IOsel_top_t		:= '0';
			when "00010011" => 
			--SZ Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '1';
				jumpCond_top_t := '1';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010100" => 
			--CLFZ
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '1';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010101" =>  	
			--NOOP 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010110" => 
			--MAX Rz #Operand 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '1';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00010111" =>  
			--STRPC $Operand 
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "010";
				IOsel_top_t		:= '0';
			when "00011000" =>
			--LSL Rz Rx #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "100";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when "00011001" =>
			--RSL Rz Rx #Operand
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '1';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "101";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '1';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '1';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
			when others =>
			--output 0's
				jump_top_t		:= '0';
				jumpSrc_top_t	:= '0';
				jumpCond_top_t := '0';
				clfz_top_t		:= '0';
				writeZ_top_t	:= '0';
				memRead_top_t	:= '0';
				memWrite_top_t	:= '0';
				dataSrc_top_t	:= '0';
				addrSrc_top_t	:= '0';
				ALUop_top_t		:= "000";
				ALUsrc0_top_t	:= '0';
				ALUsrc1_top_t	:= '0';
				max_top_t		:= '0';
				IOwrite_top_t	:= '0';
				regWrite_top_t	:= '0';
				dataSel_top_t	:= "000";
				IOsel_top_t		:= '0';
	end case; 
	jump_top <= jump_top_t; 		
	jumpSrc_top <=	jumpSrc_top_t;
	jumpCond_top <= jumpCond_top_t;
	clfz_top <=	clfz_top_t;
	writeZ_top <=	writeZ_top_t;	
	memRead_top <=	memRead_top_t;
	memWrite_top <= memWrite_top_t;	
	dataSrc_top <=	dataSrc_top_t;
	addrSrc_top <=	addrSrc_top_t;	
	ALUop_top <= ALUop_top_t;	
	ALUsrc0_top <=	ALUsrc0_top_t;	
	ALUsrc1_top <=	ALUsrc1_top_t;
	max_top <=	max_top_t;		
	IOwrite_top <=	IOwrite_top_t;	
	regWrite_top <= regWrite_top_t;	
	dataSel_top <=	dataSel_top_t;
	IOsel_top <= IOsel_top_t;		
end process;

	
	
end architecture;