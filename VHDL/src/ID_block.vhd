library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity ID_block is 
	port(
	
	    clk					 : in  std_logic;
		rst					 : in  std_logic;--reset attivo alto
		sel_ID_in					 : in  std_logic_vector(sel_imm-1 downto 0);
		RegWrite_ID_in			 : in  std_logic;
		read_en_ID_in				 : in  std_logic;
		ID_EX_MemRead_ID_in        : in std_logic;-- attivo alto
		jal_ID_in				 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_in			     : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		read_register_1_ID_in    : in  std_logic_vector(length_in_RF-1 downto 0);
		read_register_2_ID_in	 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_register_ID_in		 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_data_ID_in		 : in  std_logic_vector(data_parallelism - 1 downto 0);
		instruction_ID_in       : in  std_logic_vector(instruction_parallelism - 1 downto 0);
     	rd_backward_ID_in                : in std_logic_vector(source_reg - 1 downto 0);
		jal_ID_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_ID_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		read_data_1_ID_out	 : out std_logic_vector(data_parallelism-1 downto 0);
		read_data_2_ID_out    : out std_logic_vector(data_parallelism-1 downto 0);
		immediate_ID_out          : out std_logic_vector(data_parallelism - 1 downto 0);
		to_ALU_control_ID_out     : out std_logic_vector(alu_ctrl - 1 downto 0);
		rd_ID_out						 : out std_logic_vector(rd_length - 1 downto 0);
		PCWrite_ID_out: out std_logic;
		IF_ID_Write_ID_out: out std_logic;
		q_ID_out: out std_logic_vector(out_ctrl -1 downto 0)
		
	);    
end ID_block; 

architecture behavioural of ID_block is

component imm_gen is
port(
		rst		  : in  std_logic;--reset attivo alto
		sel  	  : in  std_logic_vector(sel_imm-1 downto 0);
		instruction: in  std_logic_vector(instruction_parallelism - 1 downto 0);
		immediate  : out std_logic_vector(data_parallelism - 1 downto 0)
		
	); 
end component;

component register_file is
port(
		clk            : in  std_logic;
		rst            : in  std_logic;--reset attivo alto		 
		RegWrite       : in  std_logic; -- write enable
		read_en        : in  std_logic; --read enable
		read_register_1: in  std_logic_vector(length_in_RF-1 downto 0);
		read_register_2: in  std_logic_vector(length_in_RF-1 downto 0);
		write_register : in  std_logic_vector(length_in_RF-1 downto 0);
		write_data_in  : in  std_logic_vector(data_parallelism-1 downto 0);
		read_data_1_out: out std_logic_vector(data_parallelism-1 downto 0);
		read_data_2_out: out std_logic_vector(data_parallelism-1 downto 0)
		
	); 
end component;

component HDU is
port(
		ID_EX_MemRead: in std_logic;
		rs1: in std_logic_vector(length_in_RF - 1 downto 0);-- instruction bits from 19 to 15
		rs2: in std_logic_vector(length_in_RF - 1 downto 0);-- instruction bits from 24 to 20
		rd : in std_logic_vector(length_in_RF - 1 downto 0);
		PCWrite: out std_logic;
		IF_ID_Write: out std_logic;
		sel_mux: out std_logic
		
	); 
end component;

component mux_ID is
port(
        in_ctrl: in std_logic_vector(out_ctrl -1 downto 0);-- segnale che entra nel mux proveniente dalla CU
		zeros: in std_logic_vector(out_ctrl -1 downto 0):=(others=>'0');
		q: out std_logic_vector(out_ctrl -1 downto 0);
		sel: in std_logic
    );
end component;

component CU is
port(
		instruction: in std_logic_vector(out_ctrl -1 downto 0):=(others=>'0');
		ctrl: out std_logic_vector(out_ctrl -1 downto 0)
    );
end component;

signal clk_s, rst_s, RegWrite_s, read_en_s, ID_EX_MemRead_s, PCWrite_s, IF_ID_Write_s, sel_mux_s   : std_logic;
signal sel_s                                                  : std_logic_vector(sel_imm-1 downto 0);
signal rd_backward_s, rs1_s, rs2_s                            : std_logic_vector(source_reg -1 downto 0);
signal read_register_1_s, read_register_2_s, write_register_s: std_logic_vector(length_in_RF-1 downto 0);
signal write_data_in_s, read_data_1_out_s, read_data_2_out_s  : std_logic_vector(data_parallelism-1 downto 0);
signal instruction_s                                          : std_logic_vector(instruction_parallelism - 1 downto 0);
signal immediate_s                                            : std_logic_vector(data_parallelism - 1 downto 0);
signal from_CU_to_mux_s,q_s                                                : std_logic_vector(out_ctrl -1 downto 0);
signal zeros_s                                                : std_logic_vector(out_ctrl -1 downto 0):=others(=>'0');

begin

clk_s <= clk;
rst_s <= rst;

RegWrite_s <= RegWrite_ID_in;
read_en_s  <= read_en_ID_in;
sel_s <= sel_ID_in;
read_register_1_s <= read_register_1_ID_in;
read_register_2_s <= read_register_2_ID_in;
write_register_s  <= write_register_ID_in;
write_data_in_s <= write_data_ID_in;
instruction_s <= instruction_ID_in;

read_data_1_ID_out <= read_data_1_out_s;
read_data_2_ID_out <= read_data_2_out_s;
immediate_ID_out   <= immediate_s;

rd_backward_s<=rd_backward_ID_in;
ID_EX_MemRead_s<=ID_EX_MemRead_ID_in;
rs1_s<=instruction_ID_in(19 downto 15);
rs2_s<=instruction_ID_in(24 downto 20);


immediate_generator: imm_gen port map(
									rst_s, 
									sel_s, 
									instruction_s, 
									immediate_s
									);
									
RF: register_file port map(
						clk_s, 
						rst_s, 
						RegWrite_s, 
						read_en_s, 
						read_register_1_s, 
						read_register_2_s, 
						write_register_s, 
						write_data_in_s, 
						read_data_1_out_s, 
						read_data_2_out_s
						);

Hazard: HDU port map(
						ID_EX_MemRead_s,
						rs1_s,
						rs2_s,
						rd_backward_s,
						PCWrite_s,
						IF_ID_Write_s,
						sel_mux_s						
						);

mux: mux_ID port map(
					from_CU_to_mux_s,
					zeros_s,
					q_s,
					sel_mux_s					
					);

control_unit: CU port map(
					instruction_s,
					from_CU_to_mux_s
					);
						 

jal_ID_out <= jal_ID_in;
pc_ID_out  <= pc_ID_in;
to_ALU_control_ID_out <= (instruction(30) & instruction(14 downto 12));
rd_ID_out <= instruction(11 downto 7);
PCWrite_ID_out<=PCWrite_s;
IF_ID_Write_ID_out<=IF_ID_Write_s;
q_ID_out<=q_s;
end behavioural;
