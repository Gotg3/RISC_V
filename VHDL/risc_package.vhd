library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package risc_package is

	constant instruction_parallelism: integer:=32;    -- instruction parallelism
	constant number_regs: integer:=32;
	constant data_parallelism: integer := 64; --data parallelism
	constant length_in_RF: integer :=5; -- number of bits for the register file inputs
	
end package risc_package;