-------------------------------------------------------------------------------
--
--  Testbench for the 'reset_synchronizer' component.
--
--  This file is part of the noasic library.
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
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
use work.print.all;
use work.waitclk.all;

entity tb_reset_synchronizer is
end entity tb_reset_synchronizer;

architecture test of tb_reset_synchronizer is
  constant G_RELEASE_DELAY_CYCLES : natural   := 5;
  signal i_reset                  : std_logic;
  signal o_reset                  : std_logic;
  signal i_clk                    : std_logic := '0';

begin
  i_clk <= not i_clk after 1 ns;

  p_test : process
  begin
    i_reset <= '0';

    -- Check that reset is activated at power-up
    wait for 1 ps;
    assert o_reset = '1' severity failure;

    for i in 0 to G_RELEASE_DELAY_CYCLES - 1 loop
      waitclk(i_clk, 1);
      assert o_reset = '1' severity failure;
    end loop;

    -- Check that power-up reset gets cleared:
    waitclk(i_clk, 1);
    assert o_reset = '0' severity failure;

    waitclk(i_clk, 10);

    -- Apply asynchronous reset:
    wait for 500 ps;
    i_reset <= '1';
    wait for 1 ps;
    i_reset <= '0';
    wait for 1 ps;

    -- Check that reset output is activated asynchronously:
    assert o_reset = '1' severity failure;

    for i in 0 to G_RELEASE_DELAY_CYCLES - 1 loop
      waitclk(i_clk, 1);
      assert o_reset = '1' severity failure;
    end loop;

    -- Check that reset gets cleared:
    waitclk(i_clk, 1);
    assert o_reset = '0' severity failure;

    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    report "Simulation completed (not an error)." severity failure;
    wait;
  end process;

  uut : entity work.reset_synchronizer
    generic map(
      G_RELEASE_DELAY_CYCLES => G_RELEASE_DELAY_CYCLES
    )
    port map(
      i_reset => i_reset,
      i_clk   => i_clk,
      o_reset => o_reset);

end architecture test;

