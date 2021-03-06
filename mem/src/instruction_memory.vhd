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
			DATA_OUT: out std_logic_vector(instruction_parallelism-1 downto 0);
			IF_ID_write:    in std_logic;
			PC_write:       in std_logic;
			rst		  : in std_logic
			);
end instruction_memory;

architecture Behavioral of instruction_memory is

type RAM_ARRAY is array (0 to 21) of std_logic_vector (instruction_parallelism-1 downto 0);

signal RAM: RAM_ARRAY :=(
0  =>   "00000000011100000000100000010011",
1  =>   "00001111110000010000001000010111",
2  =>   "11111111110000100000001000010011", 
3  =>   "00001111110000010000001010010111", 
4  =>   "00000001000000101000001010010011",
5  =>   "01000000000000000000011010110111",
6  =>   "11111111111101101000011010010011",
7  =>   "00000010000010000000100001100011", 
8  =>   "00000000000000100010010000000011",
9  =>   "01000001111101000101010010010011", 
10 =>   "00000000100101000100010100110011", 
11 =>   "00000000000101001111010010010011",
12 =>   "00000000100101010000010100110011",
13 =>   "00000000010000100000001000010011", 
14 =>   "11111111111110000000100000010011", 
15 =>   "00000000110101010010010110110011",
16 =>   "11111100000001011000111011100011", 
17 =>	 "00000000000001010000011010110011",
18 =>   "11111101010111111111000011101111",
19 =>   "00000000110100101010000000100011", 
20 =>   "00000000000000000000000011101111", 
21 =>   "00000000000000000000000000010011"
   ); 
	
signal decoded_address, encoded_address : std_logic_vector(address_parallelism-1 downto 0);
signal data_out_s : std_logic_vector(address_parallelism-1 downto 0):=(others=>'0');
signal PC_out_s   :std_logic_vector(address_parallelism-1 downto 0);

component reg_instruction_IF_ID
	port (
      clk: in std_logic;
		rst: in std_logic;
		IF_ID_write: in std_logic;
		d :  in std_logic_vector(address_parallelism-1 downto 0);
		q :  out std_logic_vector(address_parallelism-1 downto 0));
	end component;
	

   
	
begin

encoded_address <= ADDR;
decoded_address <= std_logic_vector((unsigned(encoded_address) - "010000000000000000000000")/4);



process(CLK) begin --in pipe stage


if(CLK'EVENT AND CLK='1') then 
 if(RAM_WR='1') then RAM(to_integer(unsigned(decoded_address))) <= DATA_IN; --synchronous write
 else 
	if( PC_write = '0') then
	DATA_OUT_s <= RAM(to_integer(unsigned(decoded_address)));
	end if;
 end if;
end if;
end process;




reg_instr_IF_ID : reg_instruction_IF_ID --out pipe stage (NOP insertion)
port map(

	clk=> CLK,
	rst => rst,
	IF_ID_write=>IF_ID_write,
	d=>data_out_s,
	q=>data_out
);


end Behavioral;