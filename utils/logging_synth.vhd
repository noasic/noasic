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
--use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
--use std.textio.all;
--use work.str.all;

package logging is

  -- The possible logging levels
  type t_logging_level is (DEBUG, INFO, WARNING, ERROR, FAILURE);

  -- Each logger has a unique logger ID
  subtype t_logger is natural;

  -- Create a new logger
  impure function logger(name : string; level : t_logging_level := INFO) return t_logger;

  -- Set the current logging level of a given logger. Messages with lower 
  -- logging levels than the current level will not be printed on the console.  
  procedure set_logging_level(logger : t_logger; level : t_logging_level);

  -- Log a DEBUG message
  procedure debug(logger : t_logger; message : string);

  -- Log an INFO message
  procedure info(logger : t_logger; message : string);

  -- Log a WARNING message
  procedure warning(logger : t_logger; message : string);

  -- Log an ERROR message
  procedure error(logger : t_logger; message : string);

  -- Log a FAILURE message, and terminates the simulation
  procedure failure(logger : t_logger; message : string; terminate : boolean := true);

  -- Print the statistics (number of failures, errors, warnings)
  procedure printstats;

  -- Configurate logging levels using a configuration text file which is 
  -- formatted as follows: <logger_name> <logging_level>
  procedure init_logging_levels(config_file_path : string);

end package logging;

package body logging is
  constant INVALID_LOGGER : t_logger := t_logger'high;

  impure function logger(name : string; level : t_logging_level := INFO) return t_logger is
  begin
    return INVALID_LOGGER;
  end function;

  procedure set_logging_level(logger : t_logger; level : t_logging_level) is
  begin
    null;
  end procedure;

  procedure debug(logger : t_logger; message : string) is
  begin
    null;
  end procedure;

  procedure info(logger : t_logger; message : string) is
  begin
    null;
  end procedure;

  procedure warning(logger : t_logger; message : string) is
  begin
    null;
  end procedure;

  procedure error(logger : t_logger; message : string) is
  begin
    null;
  end procedure;

  procedure failure(logger : t_logger; message : string; terminate : boolean := true) is
  begin
    null;
  end procedure;

  procedure printstats is
  begin
    null;
  end procedure;

  procedure init_logging_levels(config_file_path : string) is
  begin
    null;
  end procedure;

end package body logging;

