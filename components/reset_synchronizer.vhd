-------------------------------------------------------------------------------
--
--  Reset reset_synchronizer.
--
--  This file is part of the noasic library.
--
--  Description:  
--    Sychronizes an asynchronous reset into a signal that can be used as a
--    synchronous reset in a given clock domain. Upon activation of the i_reset
--    input, the o_reset output is activated immediately (asynchronously). The
--    o_reset output is de-activated synchronously a number of cycles 
--    (G_RELEASE_DELAY_CYCLES) after i_reset is de-activated.
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2013 Guy Eschemann
--
--  This source file may be used and distributed without restriction provided
--  that this copyright statement is not removed from the file and that any
--  derivative work contains the original copyright notice and the associated
--  disclaimer.
--
--  This source file is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or (at your
--  option) any later version.
--
--  This source file is distributed in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
--  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with the noasic library.  If not, see http://www.gnu.org/licenses
--
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;

entity reset_synchronizer is
  generic(
    G_RELEASE_DELAY_CYCLES : natural := 2); -- delay between the de-assertion of the asynchronous and synchronous resets  
  port(
    i_reset : in  std_logic;            -- asynchronous input reset
    i_clk   : in  std_logic;            -- destination clock
    o_reset : out std_logic);           -- synchronous output reset
begin
  assert G_RELEASE_DELAY_CYCLES >= 2 report "delay must be >= 2 to prevent metastable output" severity failure;
end reset_synchronizer;

architecture RTL of reset_synchronizer is

  -------------------------------------------------------------------------------
  -- Component declarations
  --
  component synchronizer
    generic(G_INIT_VALUE    : std_logic := '0';
            G_NUM_GUARD_FFS : positive  := 1);
    port(i_reset : in  std_logic;
         i_clk   : in  std_logic;
         i_data  : in  std_logic;
         o_data  : out std_logic);
  end component synchronizer;

begin

  -------------------------------------------------------------------------------
  -- Synchronizer
  --
  inst_synchronizer : synchronizer
    generic map(
      G_INIT_VALUE    => '1',
      G_NUM_GUARD_FFS => G_RELEASE_DELAY_CYCLES - 1)
    port map(
      i_reset => i_reset,
      i_clk   => i_clk,
      i_data  => '0',
      o_data  => o_reset);

end RTL;
