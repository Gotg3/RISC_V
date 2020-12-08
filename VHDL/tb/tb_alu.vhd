library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity tb_alu is     -- entity declaration 
end tb_alu; 

architecture dut of tb_alu is 

component ALU
	port(
	in1    :in std_logic_vector(data_parallelism-1 downto 0); --rs1
	in2    :in std_logic_vector(data_parallelism-1 downto 0); --rs2,IMM,PC
	output :out std_logic_vector(data_parallelism-1 downto 0);
	z      :out std_logic;
	ctrl   :in std_logic_vector(alu_ctrl-1 downto 0);
	shamt  :in std_logic_vector(srx-1 downto 0);
	rst    :in std_logic
	
	
	);
end component;
	
	signal in1		:std_logic_vector(data_parallelism-1 downto 0);
	signal in2		:std_logic_vector(data_parallelism-1 downto 0);
	signal output	:std_logic_vector(data_parallelism-1 downto 0);
	signal z		:std_logic;
	signal ctrl		:std_logic_vector(alu_ctrl-1 downto 0);
	signal shamt	:std_logic_vector(srx-1 downto 0);
	signal rst		:std_logic;
	signal clk	   :std_logic:='0';
	constant int1 : integer := 200;
	constant int2 : integer := 100;
	
	begin
	
   ALU_comp: ALU
		port map(
			in1 =>in1,
			in2 =>in2,
			output=>output,
			z =>z,
			ctrl =>ctrl,
			shamt =>shamt,
			rst =>rst
			);
	
	
	clk <= not(clk) after 20 ns;--periodo 40 ns
	
	
	op_prc: process(clk, rst)

	variable sel: integer := 0;
	
	begin
	
	if(rst='1') then
	
	sel:=15; -- 1111 selezione nulla
	
	else
	
	if(clk'event and clk = '1') then
    	
   
		if (sel= 10) then
				sel:=0;
			else
			
			sel :=sel + 1;
		end if;
     end if;
	end if;
	
	ctrl<= std_logic_vector(to_unsigned(sel, alu_ctrl));
	end process op_prc;
	
	
	 
	
	stimuli:process
	
	 
	
	begin
	
	
	
	rst <='1';
	in1<=(others=>'0');
	in2<=(others=>'0');
	shamt<=(others=>'0');
	
	wait for 40 ns;

	rst <='0';
	shamt<="00001";
	in1<=std_logic_vector(to_unsigned(int1, data_parallelism));
	in2<=std_logic_vector(to_unsigned(int2, data_parallelism));
	wait;
	end process stimuli;
	
	
end dut;
	
	
	
	
	
	

