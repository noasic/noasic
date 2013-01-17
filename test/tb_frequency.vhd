-------------------------------------------------------------------------------
--
--  Testbench for the 'frequency' package.
--
--  This file is part of the noasic library.
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2012 Guy Eschemann
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
use work.frequency.all;
use work.print.all;

entity tb_frequency is
end entity tb_frequency;

architecture RTL of tb_frequency is
begin
  p_test : process
  begin
    assert 1 / 1 kHz = 1 ms severity failure;
    assert 1 / 1 MHz = 1 us severity failure;
    assert 1 / 1 GHz = 1 ns severity failure;
    --
    assert 1 / 1 ms = 1 kHz severity failure;
    assert 1 / 1 us = 1 MHz severity failure;
    assert 1 / 1 ns = 1 GHz severity failure;
    --
    assert 1 kHz * 1 ms = 1.0 severity failure;
    assert 1 MHz * 1 us = 1.0 severity failure;
    assert 1 GHz * 1 ns = 1.0 severity failure;
    --
    assert 1 ms * 1 kHz = 1.0 severity failure;
    assert 1 us * 1 MHz = 1.0 severity failure;
    assert 1 ns * 1 GHz = 1.0 severity failure;
    --
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;
