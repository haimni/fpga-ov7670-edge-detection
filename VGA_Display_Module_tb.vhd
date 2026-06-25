----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2022 10:33:50 PM
-- Design Name: 
-- Module Name: VGA_Display_Module_tb - Behavioral
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


entity VGA_Display_Module_tb is
--  Port ( );
end VGA_Display_Module_tb;

architecture Behavioral of VGA_Display_Module_tb is

-- Component Declaration bfor the Unit Under Test (UUT)
component VGA_Display_Module
port (
   CLK_I        : in STD_LOGIC;
   -- VGA Output Signals
   VGA_HS_O     : out STD_LOGIC; -- HSYNC OUT
   VGA_VS_O     : out STD_LOGIC; -- VSYNC OUT
   VGA_RED_O    : out STD_LOGIC_VECTOR (4 downto 0); -- Red signal going to the VGA interface
   VGA_GREEN_O  : out STD_LOGIC_VECTOR (5 downto 0); -- Green signal going to the VGA interface
   VGA_BLUE_O   : out STD_LOGIC_VECTOR (4 downto 0); -- Blue signal going to the VGA interface
   -- Camera Frame I\O
   frame_pixel  : in STD_LOGIC_VECTOR (11 downto 0);
   frame_address : out STD_LOGIC_VECTOR (17 downto 0)
);
end component;         

--Inputs
signal CLK_I 		: STD_LOGIC := '0';
signal frame_pixel 	: STD_LOGIC_VECTOR (11 downto 0) := (others => '0');

--Outputs
signal VGA_HS_O   	: STD_LOGIC;
signal VGA_VS_O   	: STD_LOGIC;
signal VGA_RED_O  	: STD_LOGIC_VECTOR (4 downto 0);
signal VGA_GREEN_O	: STD_LOGIC_VECTOR (5 downto 0);
signal VGA_BLUE_O 	: STD_LOGIC_VECTOR (4 downto 0);
signal frame_address	: STD_LOGIC_VECTOR (17 downto 0);

-- Clock period definitions
constant PERIOD : time := 40 ns;

begin

-- Instantiate the Unit Under Test (UUT)
UUT: VGA_Display_Module 
PORT MAP(
    CLK_I        => CLK_I,				
    frame_pixel  => frame_pixel,
    VGA_HS_O   	 => VGA_HS_O,   	
    VGA_VS_O   	 => VGA_VS_O,   	
    VGA_RED_O  	 => VGA_RED_O,  	
    VGA_GREEN_O	 => VGA_GREEN_O,	
    VGA_BLUE_O 	 => VGA_BLUE_O, 	
    frame_address => frame_address
);


frame_pixel_process: process
begin
    frame_pixel <= (others => '0');
    wait for PERIOD*4;
    frame_pixel <= (others => '1');
    wait for PERIOD*4;
    frame_pixel <= (others => '0');
    wait for PERIOD*4;
end process;

--Clock generation
CLK_I <= not CLK_I after PERIOD/2;

end Behavioral;
