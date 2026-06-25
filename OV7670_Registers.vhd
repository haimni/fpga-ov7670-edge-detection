----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 12:46:38 AM
-- Design Name: 
-- Module Name: OV7670_Registers - Behavioral
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

entity OV7670_Registers is
    Port ( CLK      : in STD_LOGIC;
           RESEND   : in STD_LOGIC;
           ADVANCE  : in STD_LOGIC;
           COMMAND  : out STD_LOGIC_VECTOR (15 downto 0);
           FINISHED : out STD_LOGIC);
end OV7670_Registers;

architecture Behavioral of OV7670_Registers is

signal sreg     : std_logic_vector(15 downto 0) := (others => '0');
signal address  : std_logic_vector(7 downto 0) := (others => '0');

begin

COMMAND <= sreg;

with sreg select 
    FINISHED <= '1' when X"FFFF", '0' when others;
    

process (CLK)
begin
   if (CLK'event and CLK = '1') then
      if RESEND = '1' then
         address <= (others => '0');
      elsif ADVANCE = '1' then
		address <= std_logic_vector(unsigned(address) + 1);
      end if;
	  
	  case address is
            when X"00" => sreg <= X"1280"; -- COM7   Reset
            when X"01" => sreg <= X"1280"; -- COM7   Reset
            when X"02" => sreg <= X"1204"; -- COM7   Size & RGB output
            when X"03" => sreg <= X"1100"; -- CLKRC  Prescaler - Fin/(1+1)
            when X"04" => sreg <= X"0C00"; -- COM3   Lots of stuff, enable scaling, all others off
            when X"05" => sreg <= X"3E00"; -- COM14  PCLK scaling off
            when X"06" => sreg <= X"8C00"; -- RGB444 Set RGB format
            when X"07" => sreg <= X"0400"; -- COM1   no CCIR601
            when X"08" => sreg <= X"4010"; -- COM15  Full 0-255 output, RGB 565
            when X"09" => sreg <= X"3A04"; -- TSLB   Set UV ordering,  do not auto-reset window
            when X"0A" => sreg <= X"1438"; -- COM9  - AGC Celling
            when X"0B" => sreg <= X"4F40"; --x"4fb3"; -- MTX1  - colour conversion matrix
            when X"0C" => sreg <= X"5034"; --x"50b3"; -- MTX2  - colour conversion matrix
            when X"0D" => sreg <= X"510C"; --x"5100"; -- MTX3  - colour conversion matrix
            when X"0E" => sreg <= X"5217"; --x"523d"; -- MTX4  - colour conversion matrix
            when X"0F" => sreg <= X"5329"; --x"53a7"; -- MTX5  - colour conversion matrix
            when X"10" => sreg <= X"5440"; --x"54e4"; -- MTX6  - colour conversion matrix
            when X"11" => sreg <= X"581E"; --x"589e"; -- MTXS  - Matrix sign and auto contrast
            when X"12" => sreg <= X"3DC0"; -- COM13 - Turn on GAMMA and UV Auto adjust
            when X"13" => sreg <= X"1100"; -- CLKRC  Prescaler - Fin/(1+1)
            when X"14" => sreg <= X"1711"; -- HSTART HREF start (high 8 bits)
            when X"15" => sreg <= X"1861"; -- HSTOP  HREF stop (high 8 bits)
            when X"16" => sreg <= X"32A4"; -- HREF   Edge offset and low 3 bits of HSTART and HSTOP
            when X"17" => sreg <= X"1903"; -- VSTART VSYNC start (high 8 bits)
            when X"18" => sreg <= X"1A7B"; -- VSTOP  VSYNC stop (high 8 bits)
            when X"19" => sreg <= X"030A"; -- VREF   VSYNC low two bits
            when X"1A" => sreg <= X"0E61"; -- COM5(0x0E) 0x61
            when X"1B" => sreg <= X"0F4B"; -- COM6(0x0F) 0x4B
            when X"1C" => sreg <= X"1602"; --
            when X"1D" => sreg <= X"1E37"; -- MVFP (0x1E) 0x07  -- FLIP AND MIRROR IMAGE 0x3x
            when X"1E" => sreg <= X"2102";
            when X"1F" => sreg <= X"2291";
            when X"20" => sreg <= X"2907";
            when X"21" => sreg <= X"330B";
            when X"22" => sreg <= X"350B";
            when X"23" => sreg <= X"371D";
            when X"24" => sreg <= X"3871";
            when X"25" => sreg <= X"392A";
            when X"26" => sreg <= X"3C78"; -- COM12 (0x3C) 0x78
            when X"27" => sreg <= X"4D40";
            when X"28" => sreg <= X"4E20";
            when X"29" => sreg <= X"6900"; -- GFIX (0x69) 0x00
            when X"2A" => sreg <= X"6B4A";
            when X"2B" => sreg <= X"7410";
            when X"2C" => sreg <= X"8D4F";
            when X"2D" => sreg <= X"8E00";
            when X"2E" => sreg <= X"8F00";
            when X"2F" => sreg <= X"9000";
            when X"30" => sreg <= X"9100";
            when X"31" => sreg <= X"9600";
            when X"32" => sreg <= X"9A00";
            when X"33" => sreg <= X"B084";
            when X"34" => sreg <= X"B10C";
            when X"35" => sreg <= X"B20E";
            when X"36" => sreg <= X"B382";
            when X"37" => sreg <= X"B80A";
            when others => sreg <= X"FFFF";
         end case;
   end if;
end process;

end Behavioral;
