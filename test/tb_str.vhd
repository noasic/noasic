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
