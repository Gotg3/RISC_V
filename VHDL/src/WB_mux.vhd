library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.risc_package.all;

entity WB_mux is
		   port ( seq_address:    in std_logic_vector(address_parallelism-1 downto 0);
					 offset_address: in std_logic_vector(address_parallelism-1 downto 0);
					 result_address: in std_logic_vector(address_parallelism-1 downto 0);
					 result_data:    in std_logic_vector(data_parallelism-1 downto 0);
					 sel: 			  in std_logic_vector(1 downto 0);
					 output:			  out std_logic_vector(data_parallelism-1 downto 0));
end WB_mux;

architecture behavior of WB_mux is

begin

process (sel, seq_address, offset_address, result_address, result_data) 
		begin
		
			case sel is
			
			when "00" => output<=seq_address;
						
			when "01" => output<=offset_address;
			
			when "10" => output<=result_address;
			
			when "11" => output<=result_data;
			
			end case;
		
		end process;
end behavior;

					 