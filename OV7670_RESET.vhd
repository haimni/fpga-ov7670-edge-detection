----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 02:27:54 PM
-- Design Name: 
-- Module Name: OV7670_RESET - Behavioral
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

entity OV7670_RESET is
    Port ( CLK      : in STD_LOGIC;
           BTNC     : in STD_LOGIC;
           RST_OUT  : out STD_LOGIC);
end OV7670_RESET;

architecture Behavioral of OV7670_RESET is

begin

process (CLK)
begin
   if (CLK'event and CLK = '1') then
      if BTNC = '1' then
         RST_OUT <= '1';
      else
         RST_OUT <= '0';
      end if;
   end if;
end process;
				
end Behavioral;
