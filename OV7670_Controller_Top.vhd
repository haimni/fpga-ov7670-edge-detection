----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 12:46:38 AM
-- Design Name: 
-- Module Name: OV7670_Controller_Top - Behavioral
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

entity OV7670_Controller_Top is
    Port ( CLK          : in STD_LOGIC;
           RESEND       : in STD_LOGIC;
           FINISH_CONF  : out STD_LOGIC;
           SCL          : out STD_LOGIC;
           SDA          : inout STD_LOGIC;
           RESET        : out STD_LOGIC;
           PWDN         : out STD_LOGIC;
           XCLK         : out STD_LOGIC);
end OV7670_Controller_Top;

architecture Behavioral of OV7670_Controller_Top is

signal sys_clk  : std_logic := '0';
signal command  : std_logic_vector(15 downto 0);
signal finished : std_logic := '0';
signal taken    : std_logic := '0';
signal send     : std_logic;

constant camera_address : std_logic_vector(7 downto 0) := x"42";

component IIC_BUS_Module
port (
   CLK      : in STD_LOGIC;
   SCL      : out STD_LOGIC;
   SDA      : inout STD_LOGIC;
   TAKEN    : out STD_LOGIC;
   SEND     : in STD_LOGIC;
   ID       : in STD_LOGIC_VECTOR (7 downto 0);
   REG      : in STD_LOGIC_VECTOR (7 downto 0);
   VALUE    : in STD_LOGIC_VECTOR (7 downto 0)
);
end component;

component OV7670_Registers
port (
   CLK      : in STD_LOGIC;
   RESEND   : in STD_LOGIC;
   ADVANCE  : in STD_LOGIC;
   COMMAND  : out STD_LOGIC_VECTOR (15 downto 0);
   FINISHED : out STD_LOGIC
);
end component;

begin

FINISH_CONF <= finished;
send <= not finished;

process (CLK)
begin
   if (CLK'event and CLK = '1') then
        sys_clk <= not sys_clk;
   end if;
end process; 

IIC_BUS : IIC_BUS_Module
port map (
    CLK   => CLK,  
    SCL   => SCL,  
    SDA   => SDA,  
    TAKEN => TAKEN,
    SEND  => send, 
    ID    => camera_address,   
    REG   => command(15 downto 8),
    VALUE => command(7 downto 0)
);

RESET <= '1'; -- Normal mode
PWDN  <= '0'; -- Power device up
XCLK  <= sys_clk;  
        
Registers : OV7670_Registers
port map (
    CLK      => CLK,     
    RESEND   => RESEND,  
    ADVANCE  => taken, 
    COMMAND  => command, 
    FINISHED => finished
);


    

end Behavioral;
