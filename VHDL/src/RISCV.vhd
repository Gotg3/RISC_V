library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity RISCV is
port(
	--in
	clk					:in std_logic;
	rst                 :in std_logic;
	Instr_mem_in		:in std_logic_vector(instruction_parallelism-1 downto 0);	
	Readdata_data_mem   :in std_logic_vector(data_parallelism-1 downto 0);
	
	--out
	IF_ID_write			:out std_logic;
	MemRead_data_mem	:out std_logic;
	memWrite_data_mem   :out std_logic;
	Add_data_mem        :out std_logic_vector(data_parallelism-1 downto 0);
	Writedata_data_mem  :out std_logic_vector(data_parallelism-1 downto 0);
);


architecture structural of RISCV is

	component EX_stage
	port(
		--in	
		rst						:in std_logic;
		PC_EX_in				:in std_logic_vector(instruction_parallelism-1 downto 0);
		imm_EX_in				:in std_logic_vector(data_parallelism-1 downto 0);
		Read_data1_EX_in		:in std_logic_vector(data_parallelism-1 downto 0);
		Read_data2_EX_in		:in std_logic_vector(data_parallelism-1 downto 0);
		imm30_EX_in				:in std_logic;
		funct3_EX_in			:in std_logic_vector(funct-1 downto 0);
		rd_EX_in				:in std_logic_vector(dest_reg-1 downto 0);
		ALUsrc_EX_in			:in std_logic_vector(alu_src-1 downto 0);		--sel mux 3
		ALU_op_EX_in			:in std_logic_vector(aluOP-1 downto 0);
		ALU_backward_MEM_out	:in std_logic_vector(data_parallelism-1 downto 0);
		muxout_backward_WB_out	:in std_logic_vector(data_parallelism-1 downto 0);		
		--out 
		ALUout_EX_out			:out std_logic_vector(data_parallelism-1 downto 0);
		ALU_bypass_EX_out		:out std_logic_vector(data_parallelism-1 downto 0);
		z_EX_out				:out std_logic;
		TAddr_EX_out			:out std_logic_vector(instruction_parallelism-1 downto 0);	
		--forwarding unit special inputs	
		rs1_EX_in				:in std_logic_vector(source_reg-1 downto 0);
		rs2_EX_in				:in std_logic_vector(source_reg-1 downto 0);
		RegWrite_MEM_in			:in std_logic;
		RegWrite_WB_in			:in std_logic;
		rd_MEM_in				:in std_logic_vector(dest_reg-1 downto 0);
		rd_WB_in				:in std_logic_vector(dest_reg-1 downto 0)
		
	);
	end component;
	
	component ID_stage
	port(
		--in
	    clk					 	 : in  std_logic;
		rst					 	 : in  std_logic;--reset attivo alto
		sel_ID_in				 : in  std_logic_vector(sel_imm-1 downto 0);
		RegWrite_ID_in			 : in  std_logic;
		read_en_ID_in			 : in  std_logic;
		ID_EX_MemRead_ID_in      : in std_logic;-- attivo alto
		jal_ID_in				 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_in			     : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		read_register_1_ID_in    : in  std_logic_vector(length_in_RF-1 downto 0);
		read_register_2_ID_in	 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_register_ID_in	 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_data_ID_in		 : in  std_logic_vector(data_parallelism - 1 downto 0);
		instruction_ID_in        : in  std_logic_vector(instruction_parallelism - 1 downto 0);
	 	rd_backward_ID_in        : in std_logic_vector(source_reg - 1 downto 0);
		--out
		jal_ID_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		read_data_1_ID_out	 	 : out std_logic_vector(data_parallelism-1 downto 0);
		read_data_2_ID_out   	 : out std_logic_vector(data_parallelism-1 downto 0);
		immediate_ID_out         : out std_logic_vector(data_parallelism - 1 downto 0);
		to_ALU_control_ID_out    : out std_logic_vector(alu_ctrl - 1 downto 0);
		rd_ID_out			     : out std_logic_vector(rd_length - 1 downto 0);
		PCWrite_ID_out			 : out std_logic;
		IF_ID_Write_ID_out		 : out std_logic;
		q_ID_out				 : out std_logic_vector(out_ctrl -1 downto 0)	
	);    
	
	component reg_instruction_IF_ID
	port(
		clk        : in std_logic;
		rst        : in std_logic;
		IF_ID_write: in std_logic;
		d          :  in std_logic_vector(instruction_parallelism-1 downto 0);
		q          :  out std_logic_vector(instruction_parallelism-1 downto 0)		
	);    
	
	component reg_jal_PC_IF_ID
	port(
		clk			: in std_logic;
		rst			: in std_logic;
		IF_ID_write : in std_logic;
		d 			:  in std_logic_vector(instruction_parallelism-1 downto 0);
		q 			:  out std_logic_vector(instruction_parallelism-1 downto 0)
	);
	
	component reg
	port(
		clk	: in std_logic;
		rst : in std_logic;
		r   :  in std_logic_vector(n-1 downto 0);
		q   :  out std_logic_vector(n-1 downto 0)
	);
	
	begin