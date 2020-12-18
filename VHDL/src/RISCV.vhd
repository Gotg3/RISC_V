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
	instruction_ID_in   :in std_logic_vector(instruction_parallelism-1 downto 0); --to ID stage
	
	--out
	PCWrite_ID_out      :out std_logic; --from ID stage
	IF_ID_Write_ID_out  :out std_logic; --from ID stage
	ALUout_EX_out       :out std_logic_vector(data_parallelism-1 downto 0);--from EX stage
	ALU_bypass_EX_out   :out std_logic_vector(data_parallelism-1 downto 0);--from EX stage
	
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
		PC_EX_in				   :in std_logic_vector(instruction_parallelism-1 downto 0);
		imm_EX_in				:in std_logic_vector(data_parallelism-1 downto 0);
		Read_data1_EX_in		:in std_logic_vector(data_parallelism-1 downto 0);
		Read_data2_EX_in		:in std_logic_vector(data_parallelism-1 downto 0);
		imm30_EX_in				:in std_logic;
		funct3_EX_in			:in std_logic_vector(funct-1 downto 0);
		rd_EX_in					:in std_logic_vector(dest_reg-1 downto 0);
		ALU_backward_MEM_out	:in std_logic_vector(data_parallelism-1 downto 0);
		muxout_backward_WB_out	:in std_logic_vector(data_parallelism-1 downto 0);
		JAL_PC_4_EX_in			:in std_logic_vector(instruction_parallelism-1 downto 0);
		
		-- in EX
		ALUsrc1_EX_in			:in std_logic;
		ALUsrc2_EX_in			:in std_logic;
		ALU_op_EX_in			:in std_logic_vector(aluOP-1 downto 0);
		
		
		--in WB
		WB_EX_in			    :in std_logic_vector(WB_length-1 downto 0);
		
		--in M
		M_EX_in		         	:in std_logic_vector(M_length-1 downto 0);
		
		--out 
		
		ALUout_EX_out			:out std_logic_vector(data_parallelism-1 downto 0);
		ALU_bypass_EX_out		:out std_logic_vector(data_parallelism-1 downto 0);
		z_EX_out				:out std_logic;
		TAddr_EX_out			:out std_logic_vector(instruction_parallelism-1 downto 0);
		rd_EX_out				:out std_logic_vector(dest_reg-1 downto 0);
		JAL_PC_4_EX_out		    :out std_logic_vector(instruction_parallelism-1 downto 0);
		
		--out WB
		WB_EX_out	            :out std_logic_vector(WB_length-1 downto 0);
		
		--out M
		M_EX_out			    :out std_logic_vector(M_length-1 downto 0);
		
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
		--inputs
	    clk					 : in  std_logic;
		rst					 : in  std_logic;--reset attivo alto
		RegWrite_ID_in		 : in  std_logic;
		ID_EX_MemRead_ID_in  : in std_logic;-- attivo alto
		jal_ID_in			 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_in			 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		write_register_ID_in : in  std_logic_vector(length_in_RF-1 downto 0);
		write_data_ID_in	 : in  std_logic_vector(data_parallelism - 1 downto 0);
		instruction_ID_in    : in  std_logic_vector(instruction_parallelism - 1 downto 0);
     	rd_backward_ID_in    : in std_logic_vector(source_reg - 1 downto 0);
		--outputs
		jal_ID_out			 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_out		     : out std_logic_vector(instruction_parallelism - 1 downto 0);
		read_data_1_ID_out	 : out std_logic_vector(data_parallelism-1 downto 0);
		read_data_2_ID_out   : out std_logic_vector(data_parallelism-1 downto 0);
		immediate_ID_out     : out std_logic_vector(data_parallelism - 1 downto 0);
		to_ALU_control_ID_out: out std_logic_vector(alu_ctrl - 1 downto 0);
		rd_ID_out			 : out std_logic_vector(rd_length - 1 downto 0);
		PCWrite_ID_out       : out std_logic;
		IF_ID_Write_ID_out   : out std_logic;
		WB_ID_out            : out std_logic_vector(WB_length -1 downto 0);
		M_ID_out             : out std_logic_vector(M_length -1 downto 0);
		EX_ID_out            : out std_logic_vector(EX_length -1 downto 0)
	);    
	end component;
	
	--component reg_instruction_IF_ID  --ho tolto questo registro perchè va inserito fuori dal RISC_V insieme alla instruction memory
	--port(
	--	clk        : in std_logic;
	--	rst        : in std_logic;
	--	IF_ID_write: in std_logic;
	--	d          :  in std_logic_vector(instruction_parallelism-1 downto 0);
	--	q          :  out std_logic_vector(instruction_parallelism-1 downto 0)		
	--);    
	--end component;
	
	component reg_jal_PC_IF_ID
	port(
		clk			: in std_logic;
		rst			: in std_logic;
		IF_ID_write : in std_logic;
		d 			:  in std_logic_vector(instruction_parallelism-1 downto 0);
		q 			:  out std_logic_vector(instruction_parallelism-1 downto 0)
	);
	end component;
	
	component reg
	generic ( n: integer := 32 );
	port(
		clk: in std_logic;
		rst: in std_logic;
		d :  in std_logic_vector(n-1 downto 0);
		q :  out std_logic_vector(n-1 downto 0));
	);
	end component;
	
	signal JAL_IF_out_s, PC_IF_out_s : std_logic_vector(instruction_parallelism - 1 downto 0); -- IF stage output signals --IF/ID pipeline regs input
	signal JAL_ID_in_s, PC_ID_in_s : std_logic_vector(instruction_parallelism - 1 downto 0); -- ID stage input signals --IF/ID pipeline regs output
	signal IF_ID_Write_ID_out_s: std_logic; --output signal from ID stage to IF/ID pipeline regs to hazard detection
	signal RegWrite_ID_in_s: std_logic; --from wb stage to ID stage
	signal ID_EX_MemRead_ID_in_s: std_logic; --from ex stage to ID stage
	signal write_register_ID_in_s: std_logic_vector(length_in_RF-1 downto 0); --from WB stage to ID stage
	signal write_data_ID_in_s: std_logic_vector(data_parallelism - 1 downto 0); --from WB stage to ID stage
	signal rd_backward_ID_in_s: std_logic_vector(source_reg - 1 downto 0); --from EX stage to ID stage
	signal JAL_ID_out_s, PC_ID_out_s, PC_EX_in_s, JAL_EX_in_s, TAddr_EX_out_s, JAL_PC_4_EX_out_s: std_logic_vector(instruction_parallelism - 1 downto 0);
	signal read_data_1_ID_out_s, read_data_2_ID_out_s, immediate_ID_out_s, imm_EX_in_s, Read_data1_EX_in_s, Read_data2_EX_in_s: std_logic_vector(data_parallelism-1 downto 0);
	signal to_ALU_control_ID_out_s, to_ALU_ctrl_EX_in_s: std_logic_vector(alu_ctrl - 1 downto 0);
	signal rd_ID_out_s, rd_EX_in_s: std_logic_vector(rd_length - 1 downto 0); 
	signal PCWrite_ID_out_s: std_logic; --from ID stage to PC and to instruction memory
	signal WB_ID_out_s, WB_EX_in_s, WB_EX_out_s: std_logic_vector(WB_length -1 downto 0);--from ID stage to ID/EX pipeline registers
	signal M_ID_out_s, M_EX_in_s, M_EX_out_s: std_logic_vector(M_length -1 downto 0);--from ID stage to ID/EX pipeline registers
	signal EX_ID_out_s, EX_EX_in_s: std_logic_vector(EX_length -1 downto 0);--from ID stage to ID/EX pipeline registers
	signal ALU_backward_MEM_out_s, muxout_backward_WB_out_s: std_logic_vector(data_parallelism-1 downto 0);--from MEM stage to EX stage
	signal z_EX_out_s: std_logic;--from EX stage to EX/MEM stage
	signal rs1_EX_in_s, rs2_EX_in_s: std_logic_vector(source_reg-1 downto 0);
	signal RegWrite_MEM_in_s, RegWrite_WB_in_s: std_logic;
	signal rd_MEM_in_s, rd_WB_in_s: std_logic_vector(dest_reg-1 downto 0);
	signal
	

		
		
		
	begin
	
	--IF stage
	
	--IF/ID pipeline registers
	reg_jal_IF_ID: reg_jal_PC_IF_ID port map (
											clk	=>	clk,	
	                                        rst	=>	rst,	
	                                        IF_ID_write => IF_ID_Write_ID_out_s,
	                                        d => JAL_IF_out_s,		
	                                        q => JAL_ID_in_s
											);
											
	reg_PC_IF_ID: reg_jal_PC_IF_ID port map (
											clk	=>	clk,	
	                                        rst	=>	rst,	
	                                        IF_ID_write => IF_ID_Write_ID_out_s,
	                                        d => PC_IF_out_s,		
	                                        q => PC_ID_in_s
											);
	
	--ID stage
	ID: ID_stage port map (
						--inputs
	                    clk					 => clk,
	                    rst					 => rst,
	                    RegWrite_ID_in		 => RegWrite_ID_in_s,
	                    ID_EX_MemRead_ID_in  => ID_EX_MemRead_ID_in_s,
	                    jal_ID_in			 => JAL_ID_in_s,
	                    pc_ID_in			 => PC_ID_in_s
	                    write_register_ID_in => write_register_ID_in_s,
	                    write_data_ID_in	 => write_data_ID_in_s,
	                    instruction_ID_in    => instruction_ID_in,
	                    rd_backward_ID_in    => rd_backward_ID_in_s,
	                    --outputs
	                    jal_ID_out			 => JAL_ID_out_s,
	                    pc_ID_out		     => PC_ID_out_s,
	                    read_data_1_ID_out	 => read_data_1_ID_out_s,
	                    read_data_2_ID_out   => read_data_2_ID_out_s,
	                    immediate_ID_out     => immediate_ID_out_s,
	                    to_ALU_control_ID_out=> to_ALU_control_ID_out_s,
	                    rd_ID_out			 => rd_ID_out_s,
	                    PCWrite_ID_out       => PCWrite_ID_out_s,
	                    IF_ID_Write_ID_out   => IF_ID_Write_ID_out_s,
	                    WB_ID_out            => WB_ID_out_s,
	                    M_ID_out             => M_ID_out_s,
	                    EX_ID_out  	         => EX_ID_out_s
						);
						
	--ID/EX pipeline registers
	reg_jal_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => JAL_ID_out_s,
	                                            q  	=> JAL_EX_in_s
												);
	reg_pc_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => PC_ID_out_s,
	                                            q  	=> PC_EX_in_s
												);	
	
	reg_read_data_1_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => read_data_1_ID_out_s,
	                                            q  	=> Read_data1_EX_in_s
												);
	
	reg_read_data_2_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => read_data_2_ID_out_s,
	                                            q  	=> Read_data2_EX_in_s
												);	
	
	reg_immediate_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => immediate_ID_out_s,
	                                            q  	=> imm_EX_in_s
												);	
	 
	reg_to_ALU_control_ID_EX: reg generic map(4) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => to_ALU_control_ID_out_s,
	                                            q  	=> to_ALU_ctrl_EX_in_s
												);	
	
	reg_rd_ID_EX: reg generic map(32) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => rd_ID_out_s,
	                                            q  	=> rd_EX_in_s
												);	
	
	reg_WB_ID_EX: reg generic map(4) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => WB_ID_out_s,
	                                            q  	=> WB_EX_in_s
												);
	
	reg_M_ID_EX: reg generic map(3) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => M_ID_out_s,
	                                            q  	=> M_EX_in_s
												);
	reg_EX_ID_EX: reg generic map(5) port map (
												clk => clk,
	                                            rst => rst,
	                                            d   => EX_ID_out_s,
	                                            q  	=> EX_EX_in_s
												);	
	
	--EX stage
	EX: EX_stage port map(
						--in                   
						rst					   => rst,
						PC_EX_in			   => PC_EX_in_s,
						imm_EX_in			   => imm_EX_in_s,
						Read_data1_EX_in	   => Read_data1_EX_in_s,
						Read_data2_EX_in	   => Read_data2_EX_in_s,
						imm30_EX_in			   => to_ALU_ctrl_EX_in_s(3),
						funct3_EX_in		   => to_ALU_ctrl_EX_in_s(2 downto 0),
						rd_EX_in			   => rd_EX_in_s,
						ALU_backward_MEM_out   => ALU_backward_MEM_out_s,
						muxout_backward_WB_out => muxout_backward_WB_out_s,
						JAL_PC_4_EX_in		   => JAL_EX_in_s,
											  
						-- in EX              
						ALUsrc1_EX_in		   => EX_EX_in_s(1),
						ALUsrc2_EX_in		   => EX_EX_in_s(0),
						ALU_op_EX_in		   => EX_EX_in_s(4 downto 2),
											 										 
						--in WB               
						WB_EX_in		  	   => WB_EX_in_s,
											  
						--in M                 
						M_EX_in		  		   => M_EX_in_s,
											  
						--out                 
											  
						ALUout_EX_out		   => ALUout_EX_out,
						ALU_bypass_EX_out	   => ALU_bypass_EX_out,
						z_EX_out			   => z_EX_out_s,
						TAddr_EX_out		   => TAddr_EX_out_s,
						rd_EX_out			   => rd_backward_ID_in_s,
						JAL_PC_4_EX_out	       => JAL_PC_4_EX_out_s,
											  
						--out WB               
						WB_EX_out	           => WB_EX_out_s,
											  
						--out M                
						M_EX_out	           => M_EX_out_s,
						
						
						--forwarding unit special inputs
						
						rs1_EX_in			   => rs1_EX_in_s,
						rs2_EX_in			   => rs2_EX_in_s,
						RegWrite_MEM_in	       => RegWrite_MEM_in_s,
						RegWrite_WB_in		   => RegWrite_WB_in_s,
						rd_MEM_in			   => rd_MEM_in_s,
						rd_WB_in			   => rd_WB_in_s
						);
	
    PCWrite_ID_out <= PCWrite_ID_out_s;	
	IF_ID_Write_ID_out <= IF_ID_Write_ID_out_s;
						
						
						
						
						
						
						
						
						
						
						
						
						
	--EX/MEM pipeline registers
	
	--MEM stage
	
	--