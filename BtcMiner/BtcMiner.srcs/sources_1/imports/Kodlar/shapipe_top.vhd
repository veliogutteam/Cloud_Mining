----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/07/2022 11:07:34 AM
-- Design Name: 
-- Module Name: shapipe_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use work.shatypes.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shapipe_top is
    Port ( 
        clk     : in std_logic;
        result  : out std_logic
    );
end shapipe_top;

architecture Behavioral of shapipe_top is

    signal message  : word_vector(0 to 15) :=  (x"00000000", x"00000000", x"00000000", x"00000000",
					x"00000000", x"00000000", x"00000000", x"00000000",
					x"00000000", x"00000000", x"00000000", x"00000000",
					x"00000000", x"00000000", x"00000000", x"00000000");
					
    signal hash     : word_vector(0 to 7) :=  (x"00000000", x"00000000", x"00000000", x"00000000",
					x"00000000", x"00000000", x"00000000", x"00000000");

component shapipe
	port(
		clk     : in std_logic;
		message : in word_vector(15 downto 0);
		hash    : out word_vector(7 downto 0) );
end component;

begin
    
    result <= (xor(hash(0))) xor (xor(hash(1))) xor (xor(hash(2))) xor (xor(hash(3))) xor (xor(hash(4))) xor (xor(hash(5))) xor (xor(hash(6))) xor (xor(hash(7)));

    Lshapipe : shapipe
    port map (
        clk     => clk,
        message => message,
        hash    => hash
    );

    process (clk)
    begin
        if rising_edge(clk) then
            message(0)  <= message(0) + 1;
        end if;
    end process;
    




end Behavioral;
