----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/06/2022 09:20:15 PM
-- Design Name: 
-- Module Name: VGA_Display_Module - Behavioral
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



entity VGA_Display_Module is
    Port ( CLK_I        : in STD_LOGIC;
           -- VGA Output Signals
           VGA_HS_O     : out STD_LOGIC; -- HSYNC OUT
           VGA_VS_O     : out STD_LOGIC; -- VSYNC OUT
           VGA_RED_O    : out STD_LOGIC_VECTOR (4 downto 0); -- Red signal going to the VGA interface
           VGA_GREEN_O  : out STD_LOGIC_VECTOR (5 downto 0); -- Green signal going to the VGA interface
           VGA_BLUE_O   : out STD_LOGIC_VECTOR (4 downto 0); -- Blue signal going to the VGA interface
           -- Camera Frame I\O
           frame_pixel  : in STD_LOGIC_VECTOR (11 downto 0);
           frame_address : out STD_LOGIC_VECTOR (17 downto 0));
end VGA_Display_Module;

architecture Behavioral of VGA_Display_Module is

--VGA timing constant 

constant FRAME_WIDTH : natural := 640;
constant H_FP        : natural := 640+16; --H front porch width (pixels)
constant H_PW        : natural := 640+16+96; --H sync pulse width (pixels)
constant H_MAX       : natural := 800; --H total period (pixels)
				 
constant FRAME_HEIGHT : natural := 480;
constant V_FP         : natural := 480+10;--V front porch width (lines)
constant V_PW         : natural := 480+10+2;--V sync pulse width (lines)
constant V_MAX        : natural := 525;--V total period (lines)
				
constant H_POL        : std_logic := '0';
constant V_POL        : std_logic := '0';

--System signals 
signal v_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
signal h_cntr_reg     : unsigned( 9 downto 0) := (others => '0');
signal address        : unsigned(18 downto 0) := (others => '0');
signal blank          : std_logic := '1';

begin

frame_address <= std_logic_vector(address(18 downto 1));

--------------------------------------------------------------------------------
--Process of vertical counter and horizontal counter
--------------------------------------------------------------------------------
process (CLK_I)
begin
   if (CLK_I'event and CLK_I = '0') then
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

--------------------------------------------------------------------------------
--Pixel display control
--------------------------------------------------------------------------------
process (CLK_I)
begin
  if (CLK_I'event and CLK_I = '1') then
    if blank = '0' then
        VGA_RED_O   <= frame_pixel(11 downto 8) & "0";
        VGA_GREEN_O <= frame_pixel( 7 downto 4) & "00";
        VGA_BLUE_O  <= frame_pixel( 3 downto 0) & "0";
     else
        VGA_RED_O   <= (others => '0');
        VGA_GREEN_O <= (others => '0');
        VGA_BLUE_O  <= (others => '0');
     end if;
     
     if h_cntr_reg  >= FRAME_HEIGHT then
        address <= (others => '0');
        blank <= '1';
     else
        if v_cntr_reg  < 640 then
           blank <= '0';
           address <= address+1;
        else
           blank <= '1';
        end if;
     end if;
     
     -- Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
     if v_cntr_reg > H_FP and v_cntr_reg <= H_PW then
        VGA_HS_O <= H_POL;
     else
        VGA_HS_O <= not H_POL;
     end if;
     
      -- Are we in the vSync pulse?
     if h_cntr_reg >= V_FP and h_cntr_reg < V_PW then
        VGA_VS_O <= V_POL;
     else
        VGA_VS_O <= not V_POL;
     end if;
  end if;
  
end process;				

end Behavioral;
