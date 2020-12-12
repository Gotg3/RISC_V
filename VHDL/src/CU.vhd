library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity CU is 
	port(
		 rst: in std_logic; --attivo alto
	     opcode: in std_logic_vector(opcode_size -1 downto 0);
		 funct3: in std_logic_vector(funct -1 downto 0);
		 ctrl: out std_logic_vector(out_ctrl -1 downto 0) -- 3 bits immediate; 3 bits ((2 bits)MemtoReg, (1 bit) RegWrite) wb; 3 bits (MemWrite, MemRead, BranchCtrl) mem; 5 bits (ALU_op (3 bits), ALU_src1(1 bit), ALU_src2(1 bit))ex
	);
end CU;

architecture arch of CU is 

process(rst, funct3, opcode)
begin
	if(rst='1')
       ctrl<=(others'0');
	  
	else
	
	case opcode is
	
	when => "0110011"   --ADD, XOR, SLT 
	
		if (funct3="000") then --ADD
		
			ctrl<="111011100010000";
		
		elsif(funct3="100") then --XOR
		
			ctrl<="111011100010000";
		
		elsif (funct3="010") then --SLT
		
			crtl<="111011100010000";
		
		else
		
			ctrl<=(others=>'0');
		
		end if;
	
	when => "0010011" --ADDI, SRAI, ANDI
	
		if (funct3="000") then --ADDI
		
			ctrl<="000011100000101";
		
		elsif(funct3="101") then --SRAI
		
			ctrl<="101011100000101";
		
		elsif (funct3="111") then --ANDI
		
			crtl<="000011100000101";
		
		else
		
			ctrl<=(others=>'0');
		
		end if; 
		
	when => "0010111" --AUIPC
	
		crtl<="001011100001011";
		
	when => "0110111" --LUI
	
		crtl<="001010100011100";
		
	when => "1100011" --BEQ
	
		crtl<="100100000110100";
	
	when => "0000011" --LW
	
		crtl<="000000101000001";
		
	when => "1101111" --JAL
	
		crtl<="010001100011100";

	when => "0100011" --SW
	
		ctrl<="011100010001101";
		
	end case;
end arch;