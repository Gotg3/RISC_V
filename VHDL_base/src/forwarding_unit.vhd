library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity forwarding_unit is
	port(
	rwrite_ex_mem	:in std_logic;
	rwrite_mem_wb	:in std_logic;
	rd_in_ex_mem	:in std_logic_vector(source_reg-1 downto 0);
	rd_in_mem_wb	:in std_logic_vector(source_reg-1 downto 0);
	rs1_in_id_ex	:in std_logic_vector(source_reg-1 downto 0);
	rs2_in_id_ex	:in std_logic_vector(source_reg-1 downto 0);
	forward1 		:out std_logic_vector(mux_ctrl-1 downto 0);
	forward2   		:out std_logic_vector(mux_ctrl-1 downto 0)
	);
end entity;


architecture structural of forwarding_unit is
	
	signal forward1_s :std_logic_vector(mux_ctrl-1 downto 0):="00";
	signal forward2_s :std_logic_vector(mux_ctrl-1 downto 0):="00";
	
	begin

	process (rwrite_ex_mem,rwrite_mem_wb,rd_in_ex_mem,rd_in_mem_wb,rs1_in_id_ex)
	begin

		if(rwrite_ex_mem = '1') then --la condizione 11 é coperta con "00" prende il path normale
		
			if(unsigned(rd_in_ex_mem) /= to_unsigned(0, rd_in_ex_mem'length)) then  --compare with a vector of 0s
			
				if( rd_in_ex_mem = rs1_in_id_ex ) then 
					
					forward1_s<="01"; -- select EX/MEM forward
					
				else
				
					forward1_s<="00"; -- normal selection from RF
				
				end if;
				
			else 
			
			forward1_s<="00"; -- normal selection from RF
				
			end if;
			
		
			
			
		
		elsif(rwrite_mem_wb = '1') then
		
			if(unsigned(rd_in_mem_wb) /= to_unsigned(0, rd_in_mem_wb'length)) then 
			
				if( rd_in_mem_wb = rs1_in_id_ex ) then 
					
					forward1_s<="10"; -- select MEM/WB forward
				
				else 
				
				forward1_s<="00"; -- normal selection from RF
				
				end if;
				
			else
			
			forward1_s<="00"; -- normal selection from RF
				
			end if;
		
		
		
						
		
		else
		
			forward1_s<="00"; -- normal selection from RF
			
		
		
		
		end if;
	
		
	end process;
	
	
	
	process (rwrite_ex_mem,rwrite_mem_wb,rd_in_ex_mem,rd_in_mem_wb,rs2_in_id_ex)
	
	begin

	
	
	if(rwrite_ex_mem = '1') then
		
			if(unsigned(rd_in_ex_mem) /= to_unsigned(0, rd_in_ex_mem'length)) then 
			
				if( rd_in_ex_mem = rs2_in_id_ex ) then 
					
					forward2_s<="01"; -- select EX/MEM forward
				
				else
				
				forward2_s<="00"; -- normal selection from RF
				
				end if;
				
			else
				
			forward2_s<="00"; -- normal selection from RF
				
			end if;
			
			
		elsif(rwrite_mem_wb = '1') then
		
			if(unsigned(rd_in_mem_wb) /= to_unsigned(0, rd_in_mem_wb'length)) then 
			
				if( rd_in_mem_wb = rs2_in_id_ex ) then 
					
					forward2_s<="10"; -- select MEM/WB forward
				
				else
				
				forward2_s<="00"; -- normal selection from RF
				
				end if;
				
			else
				
			forward2_s<="00"; -- normal selection from RF
				
			end if;
			
		else 
			
			
			forward2_s<="00"; -- normal selection from RF
			
		end if;
		
	end process;
	
	
	
	
	
	
	
	forward1<=forward1_s;
	forward2<=forward2_s;
	
end structural;