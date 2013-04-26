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
--
--  Copyright (c) 2013 by the Author(s)
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

