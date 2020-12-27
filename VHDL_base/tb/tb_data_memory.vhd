library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity tb_data_memory is     -- entity declaration 
end tb_data_memory; 

architecture dut of tb_data_memory is 



component data_memory

	port (
			ADDR: 	 		in std_logic_vector(address_parallelism-1 downto 0);
			DATA_IN:  		in std_logic_vector(data_parallelism-1 downto 0);
			RAM_WR:   		in std_logic;
			CLK: 			in std_logic;
			DATA_OUT: 		out std_logic_vector(data_parallelism-1 downto 0);
			rst:				in std_logic
			);
end component;
	
	
signal clk 			:std_logic:='0';
signal ADDR			:std_logic_vector(address_parallelism-1 downto 0);
signal DATA_IN		:std_logic_vector(data_parallelism-1 downto 0):=(others=>'0');
signal RAM_WR		:std_logic; 				
signal DATA_OUT		:std_logic_vector(data_parallelism-1 downto 0);
signal ADDR0			:std_logic_vector(address_parallelism-1 downto 0):=(others=>'0');
signal rst				:std_logic:='0';
begin

DM: data_memory
port map(
	CLK=>clk,
	ADDR=>ADDR,
	DATA_IN  =>DATA_IN,
    RAM_WR   =>RAM_WR,
    DATA_OUT =>DATA_OUT,
	 rst      =>rst
);


clk <= not(clk) after 20 ns;--periodo 40 ns



read_prc: process(clk)

	variable read_reg: integer := 268500992;
	
	begin
	
	if(clk'event and clk = '1') then
    
   
    if (read_reg= 268501020) then
			read_reg:=268500992;
		else
		
		read_reg :=read_reg + 4;
		end if;
	end if;
	ADDR<=std_logic_vector(to_unsigned(read_reg, address_parallelism));
end process;



stimuli: process
begin

RAM_WR<='0'; -- read

wait;
end process;




end architecture;










