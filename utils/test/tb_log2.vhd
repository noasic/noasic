-------------------------------------------------------------------------------
--
--  Testbench for the 'log2' package.
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
use work.log2.all;
use work.print.all;

entity tb_log2 is
end entity tb_log2;

architecture RTL of tb_log2 is

  -- Tests the log2() function
  procedure test_log2 is
    variable v : natural;
  begin
    for i in 0 to 30 loop
      v := 2 ** i;
      assert log2(v) = i severity failure;
    end loop;
    assert log2(2147483647) = 31 severity failure; -- 2**31-1
  end procedure;

begin
  p_test : process
  begin
    test_log2;
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;
