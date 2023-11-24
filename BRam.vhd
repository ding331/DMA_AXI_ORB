library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Read_BRAM is
generic(				//one pixel one address 
    data_depth : integer    :=  800*525;		--1440
    data_bits  : integer    :=  8 		--64
);
port
(
    rclk  : in std_logic;
    raddr : in integer range 0 to data_depth-1;
    rdata : out std_logic_vector(data_bits-1 downto 0)
);
end Read_BRAM;

architecture rtl of Read_BRAM is
----------------------------------------
type type_bram is array (integer range 0 to data_depth-1) of std_logic_vector(data_bits-1 downto 0);
signal bram : type_bram := (others => '0');		--array width of depth
---------------------------------------- ---------------------------------------- ----------------------------------------
begin
---------------------------------------- ----------------------------------------
-- write_add:process(rclk)
-- variable down_col : integer range 0 to 600-1;
-- variable right_row : integer range 0 to 800-1;
-- begin			
	-- if falling_edge(rclk) then                         --RGB(8bits)
		-- bram(400 + 800*down_col + right_row) <= (others => '1'); 

	-- end if;
-- end process;
----------------------------------------
process (rclk)
	begin
	if rising_edge(rclk) then
		rdata <= bram(raddr);
	end if;
end process;
---------------------------------------- ---------------------------------------- ----------------------------------------
end rtl;