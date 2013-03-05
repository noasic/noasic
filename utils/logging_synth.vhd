--------------------------------------------------------------------------------
--
--  Synthesis replacement for the logging package. Use this file instead of 
--  logging.vhd for synthesis, as logging.vhd is not synthesizable.
--
--  This file is part of the noasic library.
--
--  Dependencies:
--    None.
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package logging is

  -- Initialize the logging framework, i.e. declare the loggers and their 
  -- associated logging levels
  procedure init(config_filename : string);

  -- The actual logging procedures:
  procedure debug(logger : string; message : string);
  procedure info(logger : string; message : string);
  procedure warning(logger : string; message : string);
  procedure error(logger : string; message : string);
  procedure failure(logger : string; message : string);

end package logging;

package body logging is
  procedure init(config_filename : string) is
  begin
    null;
  end procedure;

  procedure debug(logger : string; message : string) is
  begin
    null;
  end procedure;

  procedure info(logger : string; message : string) is
  begin
    null;
  end procedure;

  procedure warning(logger : string; message : string) is
  begin
    null;
  end procedure;

  procedure error(logger : string; message : string) is
  begin
    null;
  end procedure;

  procedure failure(logger : string; message : string) is
  begin
    null;
  end procedure;

end package body logging;

