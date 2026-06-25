----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2022 03:23:38 AM
-- Design Name: 
-- Module Name: OV7670_CAPTURE - Behavioral
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


entity OV7670_CAPTURE is
    Port ( PCLK     : in STD_LOGIC;
           VSYNC    : in STD_LOGIC;
           HREF     : in STD_LOGIC;
           DATA     : in STD_LOGIC_VECTOR (7 downto 0);
           address  : out STD_LOGIC_VECTOR (17 downto 0);
           Dout     : out STD_LOGIC_VECTOR (11 downto 0);
           WE       : out STD_LOGIC);
end OV7670_CAPTURE;

architecture Behavioral of OV7670_CAPTURE is

signal data_load		: std_logic_vector(15 downto 0) := (others => '0');
signal current_address	: std_logic_vector(18 downto 0) := (others => '0'); 
signal next_address		: std_logic_vector(18 downto 0) := (others => '0');
signal wr_hold			: std_logic_vector( 1 downto 0) := (others => '0');

begin

address <= current_address(18 downto 1);

process (PCLK)
begin
   if (PCLK'event and PCLK = '1') then
      if VSYNC = '1' then
         current_address	<= (others => '0'); 
         next_address		<= (others => '0');
         wr_hold	        <= (others => '0');
      else
         Dout <= data_load(15 downto 12) & data_load(10 downto 7) & data_load(4 downto 1);
         current_address <= next_address;
         WE <= wr_hold(1);
         wr_hold <= wr_hold(0) & (HREF and not wr_hold(0)); 
         data_load <= data_load(7 downto 0) & DATA;
         
         if wr_hold(1) = '1' then
            next_address <= std_logic_vector(unsigned(next_address)+1);
        end if;
      end if;
   end if;
    
end process;

--process (PCLK)
--begin
--   if (PCLK'event and PCLK = '1') then
--        if wr_hold(1) = '1' then
--            next_address <= std_logic_vector(unsigned(next_address)+1);
--        end if;
--   end if;
--end process;

				


end Behavioral;
