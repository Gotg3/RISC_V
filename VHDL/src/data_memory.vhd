library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use work.risc_package.all;

entity data_memory is
	port (
			ADDR: 	 in std_logic_vector(address_parallelism-1 downto 0);
			DATA_IN:  in std_logic_vector(data_parallelism-1 downto 0);
			RAM_WR:   in std_logic;
			CLK: 		 in std_logic;
			DATA_OUT: out std_logic_vector(data_parallelism-1 downto 0)
			);
end data_memory;

architecture Behavioral of data_memory is

type RAM_ARRAY is array (0 to 21) of std_logic_vector (data_parallelism-1 downto 0);

signal RAM: RAM_ARRAY :=(
   x"00000000000000000000000000001010",
   x"11111111111111111111111111010001",
   x"00000000000000000000000000010110", 
   x"11111111111111111111111111111101", 
   x"00000000000000000000000000001111",
   x"00000000000000000000000000011011",
   x"11111111111111111111111111111100",
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000",
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000",
   x"00000000000000000000000000000000",
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000",
   x"00000000000000000000000000000000", 
	x"00000000000000000000000000000000",
   x"00000000000000000000000000000000",
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000", 
   x"00000000000000000000000000000000"
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