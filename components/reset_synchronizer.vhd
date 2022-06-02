-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
-- Copyright (c) 2012-2022 Guy Eschemann
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
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
