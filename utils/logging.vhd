--------------------------------------------------------------------------------
--
--  A logging package. Write messages on the simulator's console with different
--  logging levels.
--
--  This file is part of the noasic library.
--
--  Dependencies:
--    Requires the noasic 'str' package
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
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.str.all;

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

  function strlen(str : string) return natural is
    variable v_length : natural := 0;
  begin
    for i in str'range loop
      exit when str(i) = NUL;
      v_length := v_length + 1;
    end loop;
    return v_length;
  end function;

  function str(value : t_logging_level) return string is
  begin
    case value is
      when DEBUG   => return "DEBUG";
      when INFO    => return "INFO";
      when WARNING => return "WARNING";
      when ERROR   => return "ERROR";
      when FAILURE => return "FAILURE";
    end case;
  end function;

  type t_logger_lst is protected
    impure function logger(name : string; level : t_logging_level := INFO) return t_logger;
    procedure set_logging_level(logger : t_logger; level : t_logging_level);
    procedure debug(logger : t_logger; message : string);
    procedure info(logger : t_logger; message : string);
    procedure warning(logger : t_logger; message : string);
    procedure error(logger : t_logger; message : string);
    procedure failure(logger : t_logger; message : string; terminate : boolean);
    procedure printstats;
    impure function get_logger_by_name(name : string) return t_logger;
  end protected;

  type t_logger_lst is protected body
    type t_logger_struct;
    type t_logger_ptr is access t_logger_struct;
    type t_logger_struct is record
      id           : natural;
      name         : string(1 to 256);
      level        : t_logging_level;
      num_failures : natural;
      num_errors   : natural;
      num_warnings : natural;
      next_logger  : t_logger_ptr;
    end record;

    variable v_logger_ptr : t_logger_ptr := null;
    variable v_logger_id  : natural      := 0;

    impure function logger(name : string; level : t_logging_level := INFO) return t_logger is
      variable v_name : string(1 to 256) := (others => NUL);
    begin
      v_name(name'range) := name;
      v_logger_ptr       := new t_logger_struct'(v_logger_id, v_name, level, 0, 0, 0, v_logger_ptr);
      v_logger_id        := v_logger_id + 1;
      return v_logger_ptr.id;
    end function;

    impure function get_logger_by_id(id : t_logger) return t_logger_ptr is
      variable v_current_logger : t_logger_ptr;
    begin
      v_current_logger := v_logger_ptr;
      while v_current_logger /= null loop
        exit when v_current_logger.id = id;
        v_current_logger := v_current_logger.next_logger;
      end loop;
      return v_current_logger;
    end function;

    procedure log(logger : t_logger; message : string; level : t_logging_level) is
      variable v_logger : t_logger_ptr;
      variable v_line   : line;
    begin
      v_logger := get_logger_by_id(logger);
      assert v_logger /= null;
      if v_logger /= null then
        if level >= v_logger.level then
          write(v_line, time'image(now));
          write(v_line, string'(": "));
          write(v_line, str(level));
          write(v_line, string'(": "));
          write(v_line, v_logger.name(1 to strlen(v_logger.name)));
          write(v_line, string'(": "));
          write(v_line, message);
          writeline(output, v_line);
        end if;
      end if;
    end procedure;

    procedure debug(logger : t_logger; message : string) is
    begin
      log(logger, message, DEBUG);
    end procedure;

    procedure info(logger : t_logger; message : string) is
    begin
      log(logger, message, INFO);
    end procedure;

    procedure warning(logger : t_logger; message : string) is
      variable v_logger : t_logger_ptr;
    begin
      v_logger := get_logger_by_id(logger);
      assert v_logger /= null;
      v_logger.num_warnings := v_logger.num_errors + 1;
      log(logger, message, WARNING);
    end procedure;

    procedure error(logger : t_logger; message : string) is
      variable v_logger : t_logger_ptr;
    begin
      v_logger := get_logger_by_id(logger);
      assert v_logger /= null;
      v_logger.num_errors := v_logger.num_errors + 1;
      log(logger, message, ERROR);
    end procedure;

    procedure failure(logger : t_logger; message : string; terminate : boolean) is
      variable v_logger : t_logger_ptr;
    begin
      v_logger := get_logger_by_id(logger);
      assert v_logger /= null;
      log(logger, message, FAILURE);
      v_logger.num_failures := v_logger.num_failures + 1;
      if terminate then
        printstats;
        report "terminating simulation" severity failure;
      end if;
    end procedure;

    procedure set_logging_level(logger : t_logger; level : t_logging_level) is
      variable v_logger : t_logger_ptr;
    begin
      v_logger := get_logger_by_id(logger);
      assert v_logger /= null report "unknown logger" severity failure;
      assert level <= ERROR report "minimum logging level is ERROR" severity failure;
      v_logger.level := level;
    end procedure;

    procedure printstats is
      variable v_current_logger : t_logger_ptr;
      variable num_failures     : natural;
      variable num_errors       : natural;
      variable num_warnings     : natural;
      variable v_line           : line;
    begin
      num_failures     := 0;
      num_errors       := 0;
      num_warnings     := 0;
      v_current_logger := v_logger_ptr;
      while v_current_logger /= null loop
        num_failures     := num_failures + v_current_logger.num_failures;
        num_errors       := num_errors + v_current_logger.num_errors;
        num_warnings     := num_warnings + v_current_logger.num_warnings;
        v_current_logger := v_current_logger.next_logger;
      end loop;
      write(v_line, LF);
      write(v_line, string'("---------------------------------------------------------------" & LF));
      write(v_line, "Simulation statistics: " & LF);
      write(v_line, "  " & integer'image(num_failures) & " failures(s)." & LF);
      write(v_line, "  " & integer'image(num_errors) & " error(s)." & LF);
      write(v_line, "  " & integer'image(num_warnings) & " warnings(s)." & LF);
      write(v_line, string'("---------------------------------------------------------------" & LF));
      writeline(output, v_line);
    end procedure;

    impure function get_logger_by_name(name : string) return t_logger is
      variable v_current_logger : t_logger_ptr;
    begin
      v_current_logger := v_logger_ptr;
      while v_current_logger /= null loop
        if v_current_logger.name = name then
          return v_current_logger.id;
        end if;
        v_current_logger := v_current_logger.next_logger;
      end loop;
      report "logger " & name & " not found." severity failure;
      return INVALID_LOGGER;
    end function;

  end protected body;

  shared variable sv_loggers : t_logger_lst;

  impure function logger(name : string; level : t_logging_level := INFO) return t_logger is
  begin
    return sv_loggers.logger(name, level);
  end function;

  procedure set_logging_level(logger : t_logger; level : t_logging_level) is
  begin
    sv_loggers.set_logging_level(logger, level);
  end procedure;

  procedure debug(logger : t_logger; message : string) is
  begin
    sv_loggers.debug(logger, message);
  end procedure;

  procedure info(logger : t_logger; message : string) is
  begin
    sv_loggers.info(logger, message);
  end procedure;

  procedure warning(logger : t_logger; message : string) is
  begin
    sv_loggers.warning(logger, message);
  end procedure;

  procedure error(logger : t_logger; message : string) is
  begin
    sv_loggers.error(logger, message);
  end procedure;

  procedure failure(logger : t_logger; message : string; terminate : boolean := true) is
  begin
    sv_loggers.failure(logger, message, terminate);
  end procedure;

  procedure printstats is
  begin
    sv_loggers.printstats;
  end procedure;

  function logging_level(str : string) return t_logging_level is
  begin
    return t_logging_level'value(str(1 to strlen(str)));
  end function;

  procedure init_logging_levels(config_file_path : string) is
    file config_file : TEXT open read_mode is config_file_path;
    variable v_line          : line;
    variable v_logger_name   : string(1 to 256);
    variable v_logging_level : string(1 to 256);
    variable i               : natural;
    variable j               : natural;
  begin
    while not endfile(config_file) loop
      readline(config_file, v_line);
      --
      i             := 1;
      j             := 1;
      v_logger_name := (others => NUL);
      while (i <= v_line.all'high) and (v_line.all(i) /= ' ') loop
        v_logger_name(j) := v_line.all(i);
        i                := i + 1;
        j                := j + 1;
      end loop;
      --
      while (i <= v_line.all'high) and (v_line.all(i) = ' ') loop
        i := i + 1;                     -- skip spaces
      end loop;
      --
      j               := 1;
      v_logging_level := (others => NUL);
      while (i <= v_line.all'high) and (v_line.all(i) /= ' ') loop
        v_logging_level(j) := v_line.all(i);
        i                  := i + 1;
        j                  := j + 1;
      end loop;
      --
      set_logging_level(sv_loggers.get_logger_by_name(v_logger_name), logging_level(v_logging_level));
    end loop;
  end procedure;

end package body logging;

