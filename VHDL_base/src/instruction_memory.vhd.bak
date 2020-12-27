library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use work.risc_package.all;

entity instruction_memory is
	port (
			ADDR: 	 in std_logic_vector(address_parallelism-1 downto 0);
			DATA_IN:  in std_logic_vector(instruction_parallelism-1 downto 0);
			RAM_WR:   in std_logic;
			CLK: 		 in std_logic;
			DATA_OUT: out std_logic_vector(instruction_parallelism-1 downto 0)
			);
end instruction_memory;

architecture Behavioral of instruction_memory is

type RAM_ARRAY is array (0 to 33) of std_logic_vector (instruction_parallelism-1 downto 0);

signal RAM: RAM_ARRAY :=(
   x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000", 
	x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000",
   x"00000000", 
   x"00000000", 
   x"00000000",
   x"00000000" 
   ); 
begin


process(CLK) begin

if(CLK'EVENT AND CLK='1') then 
 if(RAM_WR='1') then RAM(to_integer(unsigned(ADDR))) <= DATA_IN; --synchronous write
 else DATA_OUT <= RAM(to_integer(unsigned(ADDR)));
 end if;
end if;
end process;


end Behavioral;