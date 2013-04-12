-------------------------------------------------------------------------------
--
--  Testbench for the 'str' package.
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
use ieee.numeric_std.all;
use std.textio.all;
use work.str.all;
use work.print.all;

entity tb_str is
end entity tb_str;

architecture RTL of tb_str is

  -- Tests the hstr(std_logic_vector) function
  procedure test_hstr_std_logic_vector is
  begin
    assert hstr(std_logic_vector'("0")) = "0x0" severity failure;
    assert hstr(std_logic_vector'("1")) = "0x1" severity failure;
    assert hstr(std_logic_vector'("00")) = "0x0" severity failure;
    assert hstr(std_logic_vector'("01")) = "0x1" severity failure;
    assert hstr(std_logic_vector'("10")) = "0x2" severity failure;
    assert hstr(std_logic_vector'("11")) = "0x3" severity failure;
    assert hstr(std_logic_vector'("100")) = "0x4" severity failure;
    assert hstr(std_logic_vector'("101")) = "0x5" severity failure;
    assert hstr(std_logic_vector'("110")) = "0x6" severity failure;
    assert hstr(std_logic_vector'("111")) = "0x7" severity failure;
    assert hstr(std_logic_vector'("1000")) = "0x8" severity failure;
    assert hstr(std_logic_vector'("1001")) = "0x9" severity failure;
    assert hstr(std_logic_vector'("1010")) = "0xA" severity failure;
    assert hstr(std_logic_vector'("1011")) = "0xB" severity failure;
    assert hstr(std_logic_vector'("1100")) = "0xC" severity failure;
    assert hstr(std_logic_vector'("1101")) = "0xD" severity failure;
    assert hstr(std_logic_vector'("1110")) = "0xE" severity failure;
    assert hstr(std_logic_vector'("1111")) = "0xF" severity failure;
    assert hstr(std_logic_vector'("00010010001101000101011001111000")) = "0x12345678" severity failure;
  end procedure;

  procedure test_str_integer is
  begin
    assert str(-2147483647) = "-2147483647" severity failure;
    assert str(0) = "0" severity failure;
    assert str(2147483647) = "2147483647" severity failure;
  end procedure;

  procedure test_str_unsigned is
  begin
    assert str(to_unsigned(16#7fffffff#, 32)) = "2147483647" severity failure;
    assert str(to_unsigned(0, 16)) = "0" severity failure;
  end procedure;

begin
  p_test : process
  begin
    test_hstr_std_logic_vector;
    test_str_integer;
    test_str_unsigned;
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture RTL;
