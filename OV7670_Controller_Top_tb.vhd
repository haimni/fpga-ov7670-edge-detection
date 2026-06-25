----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 12:09:44 AM
-- Design Name: 
-- Module Name: OV7670_Controller_Top_tb - Behavioral
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


entity OV7670_Controller_Top_tb is
--  Port ( );
end OV7670_Controller_Top_tb;

architecture Behavioral of OV7670_Controller_Top_tb is

component OV7670_Controller_Top
port (
   CLK          : in STD_LOGIC;
   RESEND       : in STD_LOGIC;
   FINISH_CONF  : out STD_LOGIC;
   SCL          : out STD_LOGIC;
   SDA          : inout STD_LOGIC;
   RESET        : out STD_LOGIC;
   PWDN         : out STD_LOGIC;
   XCLK         : out STD_LOGIC);
end component;

--Input signals
signal   CLK          : STD_LOGIC := '0';
signal   RESEND       : STD_LOGIC := '0';
signal   SDA          : STD_LOGIC;
--Output signals
signal   FINISH_CONF  : STD_LOGIC;
signal   SCL          : STD_LOGIC;
signal   RESET        : STD_LOGIC;
signal   PWDN         : STD_LOGIC;
signal   XCLK         : STD_LOGIC;   

-- Clock period definitions
constant PERIOD : time := 20 ns;

begin

UUT : OV7670_Controller_Top
port map (
   CLK        	=>  CLK,        
   RESEND       =>  RESEND,     
   FINISH_CONF  =>  FINISH_CONF,
   SCL        	=>  SCL,        
   SDA        	=>  SDA,
   RESET        =>  RESET,       
   PWDN         =>  PWDN,       
   XCLK         =>  XCLK  
);


--Clock generation
CLK <= not CLK after PERIOD/2;

--reset generation
--RESEND <= '1', '0' after PERIOD*2, '1' after PERIOD*20, '0' after PERIOD*2;

--SDA generation
--SDA <= '1', '0' after PERIOD*2, '1' after PERIOD*20, '0' after PERIOD*2;


process
begin
    wait for PERIOD*2;
        RESEND <= '1';
--        SDA <= '1';
    wait for PERIOD*10;
        RESEND <= '0';
--        SDA <= '1';
    wait for PERIOD*70;
        RESEND <= '1';
--        SDA <= '0'; 
end process;

end Behavioral;
