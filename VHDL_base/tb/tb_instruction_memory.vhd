library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity tb_instruction_memory is     -- entity declaration 
end tb_instruction_memory; 

architecture dut of tb_instruction_memory is 



component instruction_memory

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
end component;
	
	
signal clk 			:std_logic:='0';
signal ADDR			:std_logic_vector(address_parallelism-1 downto 0);
signal DATA_IN		:std_logic_vector(data_parallelism-1 downto 0):=(others=>'0');
signal RAM_WR		:std_logic; 				
signal DATA_OUT		:std_logic_vector(data_parallelism-1 downto 0);
signal ADDR0			:std_logic_vector(address_parallelism-1 downto 0):=(others=>'0');
signal IF_ID_write   	: std_logic:='0';
signal rst				:std_logic:='0';
signal PC_write		:std_logic:='0';
begin

IM: instruction_memory
port map(
	CLK=>clk,
	ADDR=>ADDR,
	DATA_IN  =>DATA_IN,
    RAM_WR   =>RAM_WR,
    DATA_OUT =>DATA_OUT,
	 rst=>rst,
	 PC_write=>PC_write,
	 IF_ID_write=>IF_ID_write
);


clk <= not(clk) after 20 ns;--periodo 40 ns



read_prc: process(clk)

	variable read_reg: integer := 4194304;
	
	begin
	
	if(clk'event and clk = '1') then
    
   
    if (read_reg= 4194388) then
			read_reg:=4194304;
		else
		
		read_reg :=read_reg + 4;
		end if;
	end if;
	ADDR<=std_logic_vector(to_unsigned(read_reg, address_parallelism));
end process;



stimuli: process
begin

RAM_WR<='0'; -- read
wait for 160 ns;
PC_write<='1'; -- hold prev value
wait for 160 ns;
IF_ID_write<='1';
wait;
end process;
end architecture;










