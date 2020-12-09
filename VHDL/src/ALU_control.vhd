library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity ALU_control is
port
	(
	ALUop	:in std_logic_vector(aluOP-1 downto 0);
	imm30	:in std_logic;
	funct3	:in std_logic_vector(funct-1 downto 0);
	rst		:in std_logic;
	ctrlALU :out std_logic_vector(alu_ctrl-1 downto 0)
);

end entity;

architecture structural of ALU_control is



	begin

		process(rst,funct3,ALUop,imm30)
		
		begin
			
			if(rst='1') then 
			
				ctrlALU<=(others=>'1'); --null command
			else
			
			
				case ALUop is
				
					when "000" => ctrlALU<="0000"; --LW
					
					when "001" =>
						
						if(imm30='1') then
							
							 ctrlALU<="0010"; --SRAI
						
						else
						
							if(funct3="000") then
							
								ctrlALU<="0001"; --ADDI
							
							else
								
								ctrlALU<="0011"; --ANDI
							
							end if;
						end if;
					
					when "010" =>  ctrlALU<="0100"; --AUIPC
					
					when "011" =>  ctrlALU<="0101"; --SW
					
					when "100" =>  
					
						if (funct3="000") then
						
						ctrlALU<="0110"; --ADD
						
						elsif (funct3="010") then
						
						ctrlALU<="1000"; --SLT
						
						else
						
						ctrlALU<="0111"; --XOR
						
						end if;
					
					when "101" =>  ctrlALU<="1010"; --BEQ
					
					when others => ctrlALU<=(others=>'1'); 
							 
				end case;		 
							 
			end if;			 
										
		end process;
	
	end structural;
