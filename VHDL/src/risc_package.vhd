library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package risc_package is

    constant sel_imm					: integer:=3; 		-- immediate selector
	constant instruction_parallelism	: integer:=32;    	-- instruction parallelism
 	constant number_regs				: integer:=32;		-- number of regs in RF
	constant data_parallelism			: integer := 32;	-- data parallelism
	constant length_in_RF				: integer :=5; 		-- number of bits for the register file inputs
	constant alu_ctrl					: integer :=4; 		-- control bits for ALU
	constant srx						: integer :=5;      -- amount of right shift
	
end package risc_package;