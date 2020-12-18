library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.risc_package.all;

entity IF_stage is
		port (clk: 			                in std_logic;
				rst: 			                in std_logic;
				PC_src:		                in std_logic;
				PC_write:                   in std_logic;  --enable register
				branch_address_instruction: in std_logic_vector(address_parallelism-1 downto 0);
				seq_address:					out std_logic_vector(address_parallelism-1 downto 0);
			   current_instruction:        out std_logic_vector(instruction_parallelism-1 downto 0));
end IF_stage;

architecture behavioral of IF_stage is


component PC is
      port  (clk: 			             in std_logic;
				rst: 			        		    in std_logic;
				PC_src:		                in std_logic;
				PC_write:           			 in std_logic;  --enable register
				branch_instruction_address: in std_logic_vector(address_parallelism-1 downto 0);
				PC_out:  	        			 out std_logic_vector(address_parallelism-1 downto 0);
				seq_address:					 out std_logic_vector(address_parallelism-1 downto 0));
end component;

signal current_address : std_logic_vector(address_parallelism-1 downto 0);

begin

PC0: PC port map(clk, rst, PC_src, PC_write, branch_address_instruction, current_address, seq_address);

end architecture;