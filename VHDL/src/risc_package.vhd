library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package risc_package is

    constant out_ctrl                  : integer :=7; -- numebr of bits at the output of the CU (VA CAMBIATO IL VALORE, QUESTO è MESSO SOLO DI PROVA, POI VANNO CONTEGGIATI QUANTI SEGNALI ABBIAMO)
	constant source_reg 			   : integer :=5; --source bits
    constant mux_ctrl 				   : integer :=2;   --mux control bit
	constant trailing_zeros            : integer :=12;  -- trailing zeros for filling operation
    constant sel_imm				   : integer :=3; 	-- immediate selector
	constant instruction_parallelism   : integer :=32;  -- instruction parallelism
 	constant number_regs			   : integer :=32;  -- number of regs in RF
	constant data_parallelism		   : integer :=32;	-- data parallelism
	constant length_in_RF			   : integer :=5;   -- number of bits of the address at the output of the register file
	constant alu_ctrl				   : integer :=4; 	-- control bits for ALU
	constant srx					   : integer :=5;   -- amount of right shift
	constant funct					   : integer :=3;  	--function bits			
	constant aluOP					   : integer :=3;  	--ALU OP bits
	constant rd_length                 : integer :=5;   --length of rd
	
end package risc_package;