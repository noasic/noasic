-------------------------------------------------------------------------------
--
--  Logging Package.
--
--  This file is part of the noasic library.
--
--  Dependencies:
--    * txtutils package
--
--  See also:
--    * http://noasic.com/blog/adding-logging-to-a-vhdl-simulation/
--
--  Author(s):
--    Guy Eschemann, Guy.Eschemann@gmail.com
--
-------------------------------------------------------------------------------
--
--  Copyright (c) 2012 Guy Eschemann
--
--  This source file may be used and dilog2ibuted without relog2iction provided
--  that this copyright statement is not removed from the file and that any
--  derivative work contains the original copyright notice and the associated
--  disclaimer.
--
--  This source file is free software: you can redilog2ibute it and/or modify it
--  under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or (at your
--  option) any later version.
--
--  This source file is dilog2ibuted in the hope that it will be useful, but
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
use std.textio.all;
use work.txtutils.all;

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

  -- Maximum number of allowed loggers (increase if needed)
  constant MAX_LOGGERS : natural := 50;

  -- Maximum string length (for a logger's name)
  constant MAX_STRING_LENGTH : natural := 256;

end package logging;

package body logging is

  -- pragma translate_off

  -- The allowed logging levels
  type t_logging_level is (DEBUG, INFO, WARNING, ERROR, FAILURE);

  -- A configuration entry for a single logger
  type t_logging_config_entry is record
    logger : string(1 to MAX_STRING_LENGTH);
    level  : t_logging_level;
  end record;

  -- A collection of configuration entries for up to MAX_LOGGERS loggers
  type t_logging_config_array is array (0 to MAX_LOGGERS - 1) of t_logging_config_entry;

  -- The logging type. Using a protected type for thread safety, as the logging 
  -- procedures may be called from within different processes.
  type t_logging is protected

    -- Initialize the logging package using a configuration file
    procedure init(config_filename : string);

    -- Get the current logging level of a given logger
    impure function get_level(logger : string) return t_logging_level;

    -- Output a logging message to the simulator's standard output, provided 
    -- the given level is greater than or equal to the logger's current 
    -- logging level
    procedure trace(level : string; logger : string; message : string);

  end protected;

  type t_logging is protected body
    variable v_num_config_entries : natural;
    variable v_config_entries     : t_logging_config_array := (others => ((others => ' '), DEBUG));

    procedure init(config_filename : string) is
      file config_file : TEXT;
      variable v_line   : line;
      variable v_status : FILE_OPEN_STATUS;
    begin
      v_num_config_entries := 0;
      file_open(v_status, config_file, config_filename, READ_MODE);
      assert v_status = OPEN_OK report "ERROR: could not open file " & config_filename severity failure;
      while not endfile(config_file) loop
        if v_num_config_entries >= MAX_LOGGERS then
          report "too many loggers" severity warning;
          exit;
        end if;
        readline(config_file, v_line);
        assert v_line'length > 0 report "ERROR: file contains an empty line" severity failure;
        v_config_entries(v_num_config_entries).logger(strip(v_line.all)'range) := strip(v_line.all);
        readline(config_file, v_line);
        if strip(v_line.all) = string'("debug") then
          v_config_entries(v_num_config_entries).level := DEBUG;
        elsif strip(v_line.all) = string'("info") then
          v_config_entries(v_num_config_entries).level := INFO;
        elsif strip(v_line.all) = string'("warning") then
          v_config_entries(v_num_config_entries).level := WARNING;
        elsif strip(v_line.all) = string'("error") then
          v_config_entries(v_num_config_entries).level := ERROR;
        elsif strip(v_line.all) = string'("failure") then
          v_config_entries(v_num_config_entries).level := FAILURE;
        else
          report "ERROR: unsupported logging level" severity failure;
        end if;
        v_num_config_entries := v_num_config_entries + 1;
      end loop;
      file_close(config_file);
    end procedure;

    impure function get_level(logger : string) return t_logging_level is
    begin
      for i in 0 to v_num_config_entries loop
        if strip(v_config_entries(i).logger) = strip(logger) then
          return v_config_entries(i).level;
        end if;
      end loop;
      return DEBUG;                     -- unknown logger -> use lowest-possible logging level
    end function;

    procedure trace(level : string; logger : string; message : string) is
    begin
      print(time'image(now) & ": " & level & ": " & strip(logger) & ": " & message);
    end procedure;

  end protected body;

  shared variable sv_config : t_logging;

  -- pragma translate_on

  procedure init(config_filename : string) is
  begin
    -- pragma translate_off
    sv_config.init(config_filename);
  -- pragma translate_on    
  end procedure;

  procedure debug(logger : string; message : string) is
  begin
    -- pragma translate_off
    if sv_config.get_level(logger) <= DEBUG then
      sv_config.trace("DEBUG", logger, message);
    end if;
  -- pragma translate_on    
  end procedure;

  procedure info(logger : string; message : string) is
  begin
    -- pragma translate_off  
    if sv_config.get_level(logger) <= INFO then
      sv_config.trace("INFO", logger, message);
    end if;
  -- pragma translate_on    
  end procedure;

  procedure warning(logger : string; message : string) is
  begin
    -- pragma translate_off  
    if sv_config.get_level(logger) <= WARNING then
      sv_config.trace("WARNING", logger, message);
    end if;
  -- pragma translate_on    
  end procedure;

  procedure error(logger : string; message : string) is
  begin
    -- pragma translate_off  
    if sv_config.get_level(logger) <= ERROR then
      sv_config.trace("ERROR", logger, message);
    end if;
  -- pragma translate_on    
  end procedure;

  procedure failure(logger : string; message : string) is
  begin
    -- pragma translate_off  
    if sv_config.get_level(logger) <= FAILURE then
      sv_config.trace("FAILURE", logger, message);
    end if;
  -- pragma translate_on    
  end procedure;

end package body logging;
