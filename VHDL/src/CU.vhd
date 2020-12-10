library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_package.all;

entity CU is 
	port(
	     instruction: in std_logic_vector(out_ctrl -1 downto 0):=(others=>'0');
		 ctrl: out std_logic_vector(out_ctrl -1 downto 0)
	);
end CU;

architecture arch of CU is 

end arch;