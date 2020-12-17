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

type RAM_ARRAY is array (0 to 21) of std_logic_vector (instruction_parallelism-1 downto 0);

signal RAM: RAM_ARRAY :=(
   x"00000000011100000000100000010011",
   x"00001111110000010000001000010111",
   x"11111111110000100000001000010011", 
   x"00001111110000010000001010010111", 
   x"00000001000000101000001010010011",
   x"01000000000000000000011010110111",
   x"11111111111101101000011010010011",
   x"00000010000010000000100001100011", 
   x"00000000000000100010010000000011",
   x"01000001111101000101010010010011", 
   x"00000000100101000100010100110011", 
   x"00000000000101001111010010010011",
   x"00000000100101010000010100110011",
   x"00000000010000100000001000010011", 
   x"11111111111110000000100000010011", 
   x"00000000110101010010010110110011",
   x"11111100000001011000111011100011", 
	x"00000000000001010000011010110011",
   x"11111101010111111111000011101111",
   x"00000000110100101010000000100011", 
   x"00000000000000000000000011101111", 
   x"00000000000000000000000000010011"
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