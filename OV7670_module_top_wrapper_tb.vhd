----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 07:03:18 PM
-- Design Name: 
-- Module Name: OV7670_module_top_wrapper_tb - Behavioral
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

library std;
use std.textio.all;
USE ieee.std_logic_textio.all;

entity OV7670_module_top_wrapper_tb is
--  Port ( );
end OV7670_module_top_wrapper_tb;

architecture Behavioral of OV7670_module_top_wrapper_tb is

--Input signals
signal	  BTNC_0 		: STD_LOGIC := '0';
signal    DATA_0 		: STD_LOGIC_VECTOR ( 7 downto 0 ) := (others => '0');
signal    HREF_0 		: STD_LOGIC := '0';
signal    PCLK_0 		: STD_LOGIC := '0';
signal    SDA_0 		: STD_LOGIC := '0';
signal    VSYNC_0 		: STD_LOGIC := '0';
signal    clk_in1_0 	: STD_LOGIC := '0';

--Output signals
signal    FINISH_CONF_0 :  STD_LOGIC;
signal    PWDN_0 		:  STD_LOGIC;
signal    RESET_0 		:  STD_LOGIC;
signal    SCL_0 		:  STD_LOGIC;
signal    VGA_BLUE_O_0 	:  STD_LOGIC_VECTOR ( 4 downto 0 );
signal    VGA_GREEN_O_0 :  STD_LOGIC_VECTOR ( 5 downto 0 );
signal    VGA_HS_O_0 	:  STD_LOGIC;
signal    VGA_RED_O_0 	:  STD_LOGIC_VECTOR ( 4 downto 0 );
signal    VGA_VS_O_0 	:  STD_LOGIC;
signal    XCLK_0 		:  STD_LOGIC;

signal v_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
signal h_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
constant H_FP         : natural := 640+16; --H front porch width (pixels)
constant H_PW         : natural := 640+16+96; --H sync pulse width (pixels)
constant H_MAX        : natural := 800; --H total period (pixels)
constant V_FP         : natural := 480+10;--V front porch width (lines)
constant V_PW         : natural := 480+10+2;--V sync pulse width (lines)
constant V_MAX        : natural := 525;--V total period (lines)
constant H_POL        : std_logic := '0';
constant V_POL        : std_logic := '0';

-- Clock period definitions
constant PERIOD_100M : time := 10 ns;
constant PERIOD_25M : time := 5 ns;

component OV7670_module_top_wrapper
port (
    BTNC_0 : in STD_LOGIC;
    DATA_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FINISH_CONF_0 : out STD_LOGIC;
    HREF_0 : in STD_LOGIC;
    PCLK_0 : in STD_LOGIC;
    PWDN_0 : out STD_LOGIC;
    RESET_0 : out STD_LOGIC;
    SCL_0 : out STD_LOGIC;
    SDA_0 : inout STD_LOGIC;
    VGA_BLUE_O_0 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    VGA_GREEN_O_0 : out STD_LOGIC_VECTOR ( 5 downto 0 );
    VGA_HS_O_0 : out STD_LOGIC;
    VGA_RED_O_0 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    VGA_VS_O_0 : out STD_LOGIC;
    VSYNC_0 : in STD_LOGIC;
    XCLK_0 : out STD_LOGIC;
    clk_in1_0 : in STD_LOGIC);
end component;


begin

UUT : OV7670_module_top_wrapper
port map (
    BTNC_0 			=>  BTNC_0, 			 
    DATA_0 			=>  DATA_0, 			 
    FINISH_CONF_0 	=>  FINISH_CONF_0, 	 
    HREF_0 			=>  HREF_0, 			 
    PCLK_0 			=>  PCLK_0, 			 
    PWDN_0 			=>  PWDN_0, 			 
    RESET_0 		=>  RESET_0, 		 
    SCL_0 			=>  SCL_0, 			 
    SDA_0 			=>  SDA_0, 			 
    VGA_BLUE_O_0 	=>  VGA_BLUE_O_0, 	 
    VGA_GREEN_O_0 	=>  VGA_GREEN_O_0, 	 
    VGA_HS_O_0 		=>  VGA_HS_O_0, 		 
    VGA_RED_O_0 	=>  VGA_RED_O_0, 	 
    VGA_VS_O_0 		=>  VGA_VS_O_0, 		 
    VSYNC_0 		=>  VSYNC_0, 		 
    XCLK_0 			=>  XCLK_0, 			 
    clk_in1_0 		=>  clk_in1_0  
);


--Clock generation
clk_in1_0 <= not clk_in1_0 after PERIOD_100M/2;

--Clock generation
PCLK_0 <= not PCLK_0 after PERIOD_25M/2;

--------------------------------------------------------------------------------
--Counter for synchronization signals, VSYNC and HREF
--------------------------------------------------------------------------------
process (PCLK_0)
begin
    if (PCLK_0'event and PCLK_0 = '0') then
      if v_cntr_reg = H_MAX-1 then
         v_cntr_reg <= (others => '0');
         
         if h_cntr_reg = V_MAX-1 then
            h_cntr_reg <= (others => '0');
         else
            h_cntr_reg <= h_cntr_reg+1;
         end if;
         
      else
         v_cntr_reg <= v_cntr_reg+1;
      end if;
   end if;
end process;


process (PCLK_0)
begin
  if (PCLK_0'event and PCLK_0 = '0') then
     if v_cntr_reg > H_FP and v_cntr_reg <= H_PW then
        HREF_0 <= H_POL;
     else
        HREF_0 <= not H_POL;
     end if;
     
      
     if h_cntr_reg >= V_FP and h_cntr_reg < V_PW then
        VSYNC_0 <= not V_POL;
     else
        VSYNC_0 <= V_POL;
     end if;
  end if;     
end process;

--------------------------------------------------------------------------------
--Reading from a file, and inserting data into the DATA input
--------------------------------------------------------------------------------
process
    --input file definition 
    file infile : text is in "C:\Users\haimn\OneDrive\Documents\VHDL\logtel\course part 2\project\EdgeDetectionFilter\yelement102_dirt.txt";
    variable out_line, my_line : line;
    variable int_val : integer;

begin
    while not(endfile(infile)) loop
       -- read a line from the input file
       readline(infile, my_line);
       for i in 0 to my_line'length-1 loop
           -- read a value from the line
           read(my_line, int_val);
           wait for 10 ns ;
           -- Transfer the information into the DATA port
           DATA_0 <= std_logic_vector(to_signed(int_val,8));
       end loop;
    end loop;
end process;


process
begin
    wait for PERIOD_100M*2;
        BTNC_0 <= '1';
--        SDA <= '1';
    wait for PERIOD_100M*10;
        BTNC_0 <= '0';
--        SDA <= '1';
    wait for PERIOD_100M*800;
        BTNC_0 <= '0';
--        SDA <= '0'; 
end process;
end Behavioral;
