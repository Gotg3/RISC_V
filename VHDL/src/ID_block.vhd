library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity ID_block is 
	port(
	
	    clk					 : in  std_logic;
		rst					 : in  std_logic;--reset attivo alto
		sel					 : in  std_logic_vector(sel_imm-1 downto 0);
		RegWrite				 : in  std_logic;
		read_en				 : in  std_logic;
		ID_EX_MemRead        : in std_logic;-- attivo alto
		jal_in				 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_in					 : in  std_logic_vector(instruction_parallelism - 1 downto 0);
		read_register_1    : in  std_logic_vector(length_in_RF-1 downto 0);
		read_register_2	 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_register		 : in  std_logic_vector(length_in_RF-1 downto 0);
		write_data_in		 : in  std_logic_vector(data_parallelism - 1 downto 0);
		instruction        : in  std_logic_vector(instruction_parallelism - 1 downto 0);
     	rd_backward                : in std_logic_vector(source_reg - 1 downto 0);
		to_control_unit_out: out std_logic_vector(instruction_parallelism - 1 downto 0);
		jal_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		pc_out				 : out std_logic_vector(instruction_parallelism - 1 downto 0);
		read_data_1_out	 : out std_logic_vector(data_parallelism-1 downto 0);
		read_data_2_out    : out std_logic_vector(data_parallelism-1 downto 0);
		immediate          : out std_logic_vector(data_parallelism - 1 downto 0);
		to_ALU_control     : out std_logic_vector(alu_ctrl - 1 downto 0);
		rd_out						 : out std_logic_vector(rd_length - 1 downto 0);
		PCWrite: out std_logic;
		IF_ID_Write: out std_logic;
		q: out std_logic_vector(out_ctrl -1 downto 0)
		
	);    
end ID_block; 

architecture behavioural of ID_block is

component imm_gen is
port(
		rst		  : in  std_logic;--reset attivo alto
		sel		  : in  std_logic_vector(sel_imm-1 downto 0);
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
        in_CU: in std_logic_vector(out_ctrl -1 downto 0);-- segnale che entra nel mux proveniente dalla CU
		zeros: in std_logic_vector(out_ctrl -1 downto 0):=(others=>'0');
		q: out std_logic_vector(out_ctrl -1 downto 0);
		sel: in std_logic
    );
end component;

signal clk_s, rst_s, RegWrite_s, read_en_s, ID_EX_MemRead_s, PCWrite_s, IF_ID_Write_s, sel_mux_s   : std_logic;
signal sel_s                                                  : std_logic_vector(sel_imm-1 downto 0);
signal rd_backward_s, rs1_s, rs2_s                            : std_logic_vector(source_reg -1 downto 0);
signal read_register_1_s, read_register_2_s, write_register_s: std_logic_vector(length_in_RF-1 downto 0);
signal write_data_in_s, read_data_1_out_s, read_data_2_out_s  : std_logic_vector(data_parallelism-1 downto 0);
signal instruction_s                                          : std_logic_vector(instruction_parallelism - 1 downto 0);
signal immediate_s                                            : std_logic_vector(data_parallelism - 1 downto 0);
signal in_CU_s,q_s                                                : std_logic_vector(out_ctrl -1 downto 0);
signal zeros_s                                                : std_logic_vector(out_ctrl -1 downto 0):=others(=>'0');

begin

clk_s <= clk;
rst_s <= rst;

RegWrite_s <= RegWrite;
read_en_s  <= read_en;
sel_s <= sel;
read_register_1_s <= read_register_1;
read_register_2_s <= read_register_2;
write_register_s  <= write_register;
write_data_in_s <= write_data_in;
instruction_s <= instruction;

read_data_1_out <= read_data_1_out_s;
read_data_2_out <= read_data_2_out_s;
immediate <= immediate_s;

rd_backward_s<=rd_backward;
ID_EX_MemRead_s<=ID_EX_MemRead;
rs1_s<=instruction(19 downto 15);
rs2_s<=instruction(24 downto 20);
rd_backward_s<=rd_backward;

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
					in_CU_s,
					zeros_s,
					q_s,
					sel_mux_s,
					
					);
						
to_control_unit_out <= instruction;
jal_out <= jal_in;
pc_out  <= pc_in;
to_ALU_control <= (instruction(30) & instruction(14 downto 12));
rd_out <= instruction(11 downto 7);
PCWrite<=PCWrite_s;
IF_ID_Write<=IF_ID_Write_s;
q<=q_s;
end behavioural;
