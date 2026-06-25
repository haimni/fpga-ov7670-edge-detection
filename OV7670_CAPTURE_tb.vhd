----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2022 03:08:18 PM
-- Design Name: 
-- Module Name: OV7670_CAPTURE_tb - Behavioral
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

entity OV7670_CAPTURE_tb is
--  Port ( );
end OV7670_CAPTURE_tb;

architecture Behavioral of OV7670_CAPTURE_tb is
  
--Input signals
signal PCLK 	: STD_LOGIC := '0';
signal VSYNC	: STD_LOGIC := '0';
signal HREF 	: STD_LOGIC := '0';
signal DATA		: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
--Output signals
signal address	: STD_LOGIC_VECTOR (17 downto 0);
signal Dout   	: STD_LOGIC_VECTOR (11 downto 0);
signal WE     	: STD_LOGIC;

signal v_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
signal h_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
constant H_FP        : natural := 640+16; --H front porch width (pixels)
constant H_PW        : natural := 640+16+96; --H sync pulse width (pixels)
constant H_MAX       : natural := 800; --H total period (pixels)
constant V_FP         : natural := 480+10;--V front porch width (lines)
constant V_PW         : natural := 480+10+2;--V sync pulse width (lines)
constant V_MAX        : natural := 525;--V total period (lines)
constant H_POL        : std_logic := '0';
constant V_POL        : std_logic := '0';

-- Clock period definitions
constant PERIOD : time := 40 ns;

component OV7670_CAPTURE
port (
   PCLK     : in STD_LOGIC;
   VSYNC    : in STD_LOGIC;
   HREF     : in STD_LOGIC;
   DATA     : in STD_LOGIC_VECTOR (7 downto 0);
   address  : out STD_LOGIC_VECTOR (17 downto 0);
   Dout     : out STD_LOGIC_VECTOR (11 downto 0);
   WE       : out STD_LOGIC);
end component;

begin

UUT : OV7670_CAPTURE
port map (
   PCLK  	=> PCLK,
   VSYNC    => VSYNC,
   HREF     => HREF, 
   DATA  	=> DATA, 
   address	=> address,
   Dout     => Dout,   
   WE       => WE 
);


--Clock generation
PCLK <= not PCLK after PERIOD/2;

--------------------------------------------------------------------------------
--Counter for synchronization signals, VSYNC and HREF
--------------------------------------------------------------------------------
process (PCLK)
begin
    if (PCLK'event and PCLK = '0') then
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


process (PCLK)
begin
  if (PCLK'event and PCLK = '0') then
     if v_cntr_reg > H_FP and v_cntr_reg <= H_PW then
        HREF <= H_POL;
     else
        HREF <= not H_POL;
     end if;
     
      
     if h_cntr_reg >= V_FP and h_cntr_reg < V_PW then
        VSYNC <= not V_POL;
     else
        VSYNC <= V_POL;
     end if;
  end if;     
end process;

--------------------------------------------------------------------------------
--Reading from a file, and inserting data into the DATA input
--------------------------------------------------------------------------------
process
    --input file definition 
    file infile : text is in "C:\Users\haimn\OneDrive\Documents\VHDL\logtel\course part 2\project\EdgeDetectionFilter\yelement102_dirt.txt";
--    file inflie : text open read_mode is "C:\Users\haimn\OneDrive\Documents\VHDL\logtel\course part 2\project\EdgeDetectionFilter\yelement102_dirt.txt";
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
           DATA <= std_logic_vector(to_signed(int_val,8));
       end loop;
    end loop;
end process;

end Behavioral;
