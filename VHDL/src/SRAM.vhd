library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use work.risc_package.all;

entity SRAM is
	port (
			ADDR: 	 in std_logic_vector(6 downto 0);
			DATA_IN:  in std_logic_vector(7 downto 0);
			RAM_WR:   in std_logic;
			CLK: 		 in std_logic;
			DATA_OUT: out std_logic_vector(7 downto 0)
			);
end SRAM;

architecture Behavioral of SRAM is

type RAM_ARRAY is array (0 to 34) of std_logic_vector (31 downto 0);

signal RAM: RAM_ARRAY :=(
   x"0000",x"0000",-- 0x00: 
   x"0000",x"0000",-- 0x02:
   x"0000",x"0000",-- 0x04: 
   x"0000",x"0000",-- 0x06: 
   x"0000",x"0000",-- 0x08: 
   x"0000",x"0000",-- 0x0A: 
   x"0000",x"0000",-- 0x0C: 
   x"0000",x"0000",-- 0x0E: 
   x"0000",x"0000",-- 0x10: 
   x"0000",x"0000",-- 0x12: 
   x"0000",x"0000",-- 0x14: 
   x"0000",x"0000",-- 0x16: 
   x"0000",x"0000",-- 0x18: 
   x"0000",x"0000",-- 0x1A: 
   x"0000",x"0000",-- 0x1C: 
   x"0000",x"0000",-- 0x1E: 
   x"0000",x"0000" -- 0x20: 
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