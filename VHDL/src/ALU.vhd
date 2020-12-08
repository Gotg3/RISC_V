library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity ALU is
port(
	in1    :in std_logic_vector(data_parallelism-1 downto 0); --rs1
	in2    :in std_logic_vector(data_parallelism-1 downto 0); --rs2,IMM,PC
	output :out std_logic_vector(data_parallelism-1 downto 0);
	z      :out std_logic;
	ctrl   :in std_logic_vector(alu_ctrl-1 downto 0);
	shamt  :in std_logic_vector(srx-1 downto 0);
	rst    :in std_logic
	
	);
end entity;
	
	architecture behavioural of ALU is
	
	signal output_s :std_logic_vector(data_parallelism-1 downto 0):=(others=>'0');
	signal in1_s	:std_logic_vector(data_parallelism-1 downto 0):=(others=>'0');
	signal in2_s	:std_logic_vector(data_parallelism-1 downto 0):=(others=>'0');
	signal z_s      :std_logic:='0';
	signal shamt_s	:std_logic_vector(srx-1 downto 0);
	
	begin
	
		op_selection: process (ctrl, in1_s,in2_s,rst,shamt_s)
		
		begin
		
			if (rst= '1') then
			
				output_s<=(others=>'0');
				z_s<='0';
				
			else
				
				case ctrl is
					
					when "0000" => output_s<=std_logic_vector( unsigned(in1_s)+unsigned(in2_s));	    --LW     unsigned for lw?
										z_s<='0';
										
					when "0001" => output_s<=std_logic_vector( signed(in1_s)+signed(in2_s)); 	 		--ADDI signed for ADDI?
										z_s<='0';
				
					when "0010" => output_s<=std_logic_vector( shift_right(unsigned(in1_s), to_integer(unsigned(shamt_s))));	--SRAI signed rs1?
										z_s<='0';
					
					when "0011" => output_s<= in1_s AND in2_s;													--AND
										z_s<='0';
					
					when "0100" => output_s<=std_logic_vector( unsigned(in1_s)+unsigned(in2_s));    	-- AUIPC usigned?
										z_s<='0';
		
					when "0101" => output_s<=std_logic_vector( unsigned(in1_s)+unsigned(in2_s));	    --SW     unsigned for sw?
										z_s<='0';
					
					when "0110" => output_s<=std_logic_vector( signed(in1_s)+signed(in2_s));			--ADD signed?
										z_s<='0';
					
					when "0111" => output_s<= in1_s XOR in2_s;											--XOR
										z_s<='0';
					
					when "1000" => 
						
									if(signed(in1_s) <= signed(in2_s)) then 
										
										output_s<=(others=>'1');
										z_s<='0';
									else
										output_s<=(others=>'0');
										z_s<='0';
									end if;
									
					
					when "1001" => 
									
									if(signed(in1_s) = signed(in2_s)) then
									
										z_s<='1'; --1 = take branch
										output_s<=(others=>'0');
										
										
									else
										z_s<='0';
										output_s<=(others=>'0');
										
									end if;
									
					when others => output_s<=(others=>'0');	
										z_s<='0';
					
				end case;

			end if;
		
		end process op_selection;
		
		in1_s<=in1;
		in2_s<=in2;
		shamt_s<=shamt;
		
		output<=output_s;
		z<=z_s;
		
	end behavioural;
		
		
		