library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.risc_package.all;

entity IF_stage is
		port (clk: 			        in std_logic;
				rst: 			        in std_logic;
				PC_src:		        in std_logic;
				PC_write:           in std_logic;  --enable register
				instruction: 	     buffer std_logic_vector(instruction_parallelism-1 downto 0);
				branch_instruction: in std_logic_vector(instruction_parallelism-1 downto 0);
				PC_out:  	        buffer std_logic_vector(instruction_parallelism-1 downto 0);
				ADDR: 	 			  in std_logic_vector(5 downto 0);
				DATA_IN:            in std_logic_vector(instruction_parallelism-1 downto 0);
			   RAM_WR:             in std_logic;
			   DATA_OUT:           out std_logic_vector(instruction_parallelism-1 downto 0));
end IF_stage;

architecture behavioral of IF_stage is


component PC is
      port (clk: 			        in std_logic;
				rst: 			        in std_logic;
				PC_src:		        in std_logic;
				PC_write:           in std_logic;  --enable register
				instruction: 	     buffer std_logic_vector(instruction_parallelism-1 downto 0);
				branch_instruction: in std_logic_vector(instruction_parallelism-1 downto 0);
				PC_out:  	        buffer std_logic_vector(instruction_parallelism-1 downto 0));
end component;

component instruction_memory is
	   port (ADDR: 	 in std_logic_vector(5 downto 0);
				DATA_IN:  in std_logic_vector(instruction_parallelism-1 downto 0);
			   RAM_WR:   in std_logic;
			   CLK: 		 in std_logic;
			   DATA_OUT: out std_logic_vector(instruction_parallelism-1 downto 0));
end component;

begin
end architecture;