----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 03:26:39 PM
-- Design Name: 
-- Module Name: OV7670_RESET_tb - Behavioral
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


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity OV7670_RESET_tb is
--  Port ( );
end OV7670_RESET_tb;

architecture Behavioral of OV7670_RESET_tb is

--Input signals
signal CLK 	: STD_LOGIC := '0';
signal BTNC	: STD_LOGIC := '0';

--Output signals
signal RST_OUT : STD_LOGIC;

-- Clock period definitions
constant PERIOD : time := 20 ns;

component OV7670_RESET
port (
   CLK      : in STD_LOGIC;
   BTNC     : in STD_LOGIC;
   RST_OUT  : out STD_LOGIC);
end component;

begin

UUT : OV7670_RESET
port map (
   CLK     	=> CLK,
   BTNC     => BTNC,
   RST_OUT  => RST_OUT
);


--Clock generation
CLK <= not CLK after PERIOD/2;

--BTNC generation
process
begin
    BTNC <= '0';
   wait for PERIOD/2;
    BTNC <= '1';
   wait for PERIOD*2;
    BTNC <= '0';
   wait for PERIOD*5;
    BTNC <= '1';
   wait for PERIOD*5;
end process;

end Behavioral;
