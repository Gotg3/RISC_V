library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.risc_package.all;

entity PC is
	  port  (clk: 			        in std_logic;
				rst: 			        in std_logic;
				PC_src:		        in std_logic;
				PC_write:           in std_logic;  --enable register
				instruction: 	     in std_logic_vector(instruction_parallelism-1 downto 0);
				branch_instruction: in std_logic_vector(instruction_parallelism-1 downto 0);
				PC_out:  	        out std_logic_vector(instruction_parallelism-1 downto 0));
end PC;

architecture behavioural of PC is

signal address: std_logic_vector(instruction_parallelism-1 downto 0);

component mux21 is
generic(n: integer);
	port(
		in1		:in std_logic_vector(n-1 downto 0);
		in2		:in std_logic_vector(n-1 downto 0);
		sel		:in std_logic;
		output	:out std_logic_vector(n-1 downto 0)
	);
end component;

begin

address <=  std_logic_vector(unsigned(PC_out) + instruction_parallelism);

mux: mux21 generic map(instruction_parallelism) port map(address, branch_instruction, PC_src, instruction);

	process(clk, rst)
	begin
	
		if (rst = '1') then PC_out <= (others => '0');
		
		elsif(clk'event and clk = '1') then
		
			if( PC_write = '1') then PC_out <= instruction;					
			end if;
			
		end if;
		
	end process;
	
end behavioural;