-------------------------------------------------------------------------------
--
--  Testbench for the 'logging' package.
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

use work.logging.all;
use work.txtutils.all;                  -- print

entity tb_logging is
end entity tb_logging;

architecture test of tb_logging is
begin
  p_test : process
  begin
    init("test/logging.txt");
    debug("logger1", "logger1 debug message");
    info("logger1", "logger1 info message");
    warning("logger1", "logger1 warning message");
    error("logger1", "logger1 error message");
    failure("logger1", "logger1 failure message");
    print("---------------------------------");
    print("Simulation completed successfully");
    print("---------------------------------");
    wait;
  end process;

end architecture test;

