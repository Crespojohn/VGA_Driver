library ieee;
library defaultlib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity vga_test is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    sw    : in std_logic_vector(11 downto 0);
    hsync, vsync : out std_logic;
    rgb   : out std_logic_vector(11 downto 0)
  );
end entity vga_test;

architecture rtl of vga_test is
  signal rgb_r : std_logic_vector(11 downto 0) := (others => '0');
  signal pixel_en_r : std_logic := '0';
begin
  process(clk)
  begin
    if(rising_edge(clk)) then
      rgb_r <= sw;
      if (reset) then
        rgb_r <= (others => '0');
      end if;
    end if;
  end process;

  vga_sync_controller_i: entity defaultlib.vga_sync_controller 
  port map (
    clk_i       => clk,
    rst_i       => reset,
    hsync_o     => hsync,
    vsync_o     => vsync,
    pixel_clk_o => '0',
    pixel_en_o  => pixel_en_r
  );
  
  rgb <= rgb_r when (pixel_en_r) else (others => '0');
end architecture rtl; 