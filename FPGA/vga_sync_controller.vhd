library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity vga_sync_controller is 
generic (
  G_DISPLAY_RANGE_X :integer := 640;
  G_DISPLAY_RANGE_Y :integer := 480;
  --HSYNC GENERICS--
  G_H_RETRACE       :integer := 96;
  G_L_BOARDER       :integer := 48;
  G_R_BOARDER       :integer := 16;
  --VSYNC GENERICS--
  G_V_RETRACE       :integer := 2;
  G_T_BOARDER       :integer := 10;
  G_B_BOARDER       :integer := 33
);
port(
  clk_i       :in std_logic := '0';
  rst_i       :in std_logic := '0';

  hsync_o     :out std_logic := '0';
  vsync_o     :out std_logic := '0';
  pixel_clk_o :out std_logic := '0';
  pixel_en_o  :out std_logic := '0';
  x,y         :out unsigned(31 downto 0) := (others => '0')
);
end entity vga_sync_controller;
architecture rtl of vga_sync_controller is
  constant HSYNC_MAX     :integer := G_DISPLAY_RANGE_X+G_H_RETRACE+G_L_BOARDER+G_R_BOARDER - 1;
  constant VSYNC_MAX     :integer := G_DISPLAY_RANGE_Y+G_V_RETRACE+G_T_BOARDER+G_B_BOARDER - 1;

  constant START_H_TRACE :integer := G_DISPLAY_RANGE_X+G_R_BOARDER;
  constant STOP_H_TRACE  :integer := G_DISPLAY_RANGE_X+G_R_BOARDER+G_H_RETRACE-1;

  constant START_V_TRACE :integer := G_DISPLAY_RANGE_Y+G_B_BOARDER;
  constant STOP_V_TRACE  :integer := G_DISPLAY_RANGE_Y+G_B_BOARDER+G_V_RETRACE-1;

  signal hsync_counter_r :unsigned(integer(ceil(log2(real(integer(HSYNC_MAX))))) downto 0) := (others => '0'); 
  signal vsync_counter_r :unsigned(integer(ceil(log2(real(integer(VSYNC_MAX))))) downto 0) := (others => '0');
  signal pixel_clk_r     :std_logic := '0';
  signal pixel_counter_r :unsigned(1 downto 0) := (others => '0');
begin   

  pixel_clk_i: process(clk_i)
  begin
    if(rising_edge(clk_i)) then
      pixel_clk_r <= '0';
      pixel_counter_r <= pixel_counter_r + 1;
      if(pixel_counter_r = 3) then
        pixel_clk_r <= '1';
      end if;
    end if;
  end process;

  pixel_enable_i: process(pixel_clk_r)
  begin
    if(rising_edge(pixel_clk_r)) then
      hsync_counter_r <= hsync_counter_r + 1;
      vsync_counter_r <= vsync_counter_r + 1;
      pixel_en_o <= '0';
      if(hsync_counter_r >= HSYNC_MAX) then
        hsync_counter_r <= (others => '0');
      end if;

      if(vsync_counter_r >= VSYNC_MAX) then
        vsync_counter_r <= (others => '0');
      end if;

      if(hsync_counter_r >= G_DISPLAY_RANGE_X and vsync_counter_r >= G_DISPLAY_RANGE_Y) then
        pixel_en_o <= '1';
      end if;
    end if;
  end process;

  process (all)
  begin
    hsync_o <= '1';
    vsync_o <= '1';
    if(hsync_counter_r >= START_H_TRACE and hsync_counter_r <= STOP_H_TRACE) then
      hsync_o <= '0';
    end if;
    if(vsync_counter_r >= START_V_TRACE and vsync_counter_r <= STOP_V_TRACE) then
      vsync_o <= '0';
    end if;
    pixel_clk_o <= pixel_clk_r;
  end process;

end rtl ; -- arch
