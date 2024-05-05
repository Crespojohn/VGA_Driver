----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2024 04:06:44 PM
-- Design Name: 
-- Module Name: VGA_Driver_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Driver_tb is
--  Port ( );
end VGA_Driver_tb;

architecture Behavioral of VGA_Driver_tb is
signal clk_r : std_logic := '0';
signal rst_r : std_logic := '0';
begin

process(all)
begin
  clk_r <= not clk_r after 5ns;
end process;

vga_sync_controller_i: entity work.vga_sync_controller
  port map (
    clk_i       => clk_r,
    rst_i       => rst_r
  );

reference_module_i: entity work.vga_sync --Module used to reference for developer
  port map(
    clk   => clk_r,
    reset => rst_r
    
  );

end Behavioral;
