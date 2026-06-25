----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2022 12:46:38 AM
-- Design Name: 
-- Module Name: IIC_BUS_Module - Behavioral
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

entity IIC_BUS_Module is
    Port ( CLK      : in STD_LOGIC;
           SCL      : out STD_LOGIC;
           SDA      : inout STD_LOGIC;
           TAKEN    : out STD_LOGIC;
           SEND     : in STD_LOGIC;
           ID       : in STD_LOGIC_VECTOR (7 downto 0);
           REG      : in STD_LOGIC_VECTOR (7 downto 0);
           VALUE    : in STD_LOGIC_VECTOR (7 downto 0));
end IIC_BUS_Module;

architecture Behavioral of IIC_BUS_Module is

signal data_sr  : std_logic_vector(31 downto 0) := (others => '0');
signal busy_sr  : std_logic_vector(31 downto 0) := (others => '0');
signal divider  : unsigned(7 downto 0) := "00000001";

begin

process (busy_sr, data_sr(31))
begin
   if busy_sr(11 downto 10) = "10" or busy_sr(20 downto 19) = "10" or busy_sr(29 downto 28) = "10"  then
      SDA <= 'Z';
   else
      SDA <= data_sr(31);
   end if;
end process;


process (CLK)
begin
   if (CLK'event and CLK = '1') then
        TAKEN <= '0';
      if busy_sr(31) = '0' then
         SCL <= '1';
		   if SEND = '1' then
			   if divider = "00000000" then
					data_sr <= "100" &   ID & '0'  &   REG & '0' & VALUE & '0' & "01";
					busy_sr <= "111" & "111111111" & "111111111" & "111111111" & "11";
					TAKEN <= '1';
			   else
					divider <= divider + 1;
			   end if; 
		   end if;
		   
		else
			case (busy_sr(31 downto 29) & busy_sr(2 downto 0)) is
			  when "111"&"111" =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '1';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '1';
                end case;
			  when "111"&"110" =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '1';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '1';
                end case;
			  when "111"&"100" =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '0';
                    when "01"   => SCL <= '0';
                    when "10"   => SCL <= '0';
                    when others => SCL <= '0';
                end case;
			  when "110"&"000" =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '0';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '1';
                end case;
			  when "100"&"000" =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '1';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '1';
                end case;
			  when "000"&"000" =>
				  case divider(7 downto 6) is
                    when "00"   => SCL <= '1';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '1';
                end case;
			  when others =>
				 case divider(7 downto 6) is
                    when "00"   => SCL <= '0';
                    when "01"   => SCL <= '1';
                    when "10"   => SCL <= '1';
                    when others => SCL <= '0';
                end case;
		   end case;
		   
		   if divider = "11111111" then
				busy_sr <= busy_sr(30 downto 0) & '0';
				data_sr <= data_sr(30 downto 0) & '1';
				divider <= (others => '0');
			else
				divider <= divider + 1;
			end if;
      end if;
   end if;
end process;

end Behavioral;
