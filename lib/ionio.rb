=begin
-------------------------------------------------------------------------------
 _             _______     _ _
| |           (_______)   | | |
| | ___  ____  _____ _____| | |  ___
| |/ _ \|  _ \|  ___|____ | | | /___)
| | |_| | | | | |   / ___ | | ||___ |
|_|\___/|_| |_|_|   \_____|\_)_|___/

(C)opyright 2011, LeafScale Systems, Inc. and P. Chris Tusa
All Rights Reserved

*! Unauthorized copying of this file, via any medium is strictly prohibited !*

You may NOT copy, modify, distribute, reverse-engineer, decompile, take photos
or screen-shots, print, print to any file format, or in any way reproduce this
software or its source code without the express and written permission of the
Author(s) and LeafScale Systems, Inc.  You may NOT read, view, or discuss the
code, contents, algorithms, documentation, debugs and traces, configuration, or
any other output generated without a signed and certified mutual Non-Disclosure
Agreement between the Author(s)/LeafScale Systems, Inc. and specified parties.

These statements may be enforced under penalty of law. Failure to comply with
these restrictions will result in criminal prosecution to the full extent of
Local, State, Federal, and International laws where applicable.
-------------------------------------------------------------------------------
=end
=begin rdoc
= IonIO (I/O)
IonIO provides the common input/output routines for dealing with STDOUT and STDIN. This includes the ANSI color output methods, pauses, screenclear, etc.
=end

require 'rubygems'
require 'lib/ionconstants'
require 'lib/iontemplate'
require 'lib/ionio/input'
require 'lib/ionio/output'
require 'lib/ionio/dates'
#require 'lib/ionio/tgedit' # Telegard Screen Editor


module IonIO

  # Print Output in a ANSI color block using Term::ANSIColor
  # (DEPRECATED)
  def IonIO::ansiprint(text, fgcolor=ANSI_WHITE, bgcolor=ANSI_ON_BLACK)
      print fgcolor+bgcolor+text+ANSI_RESET
  end #/ansiprint

  # AUDIT CODE: REPLACE WITH NEW TG COLORS
  # Display the program's MAIN banner
  def IonIO.mainbanner
    ansiprint("IonFalls", ANSI_BRIGHT_CYAN)
    ansiprint(" v", ANSI_CYAN)
    ansiprint(IONFALLS_VERSION, ANSI_BRIGHT_CYAN)
    ansiprint(" :: ", ANSI_BLUE)
    ansiprint("Copyright (c) 2011-2012, Chris Tusa\n", ANSI_BRIGHT_CYAN)
    ansiprint("All rights reserved.\n", ANSI_CYAN)
    ansiprint("Distributed by LeafScale Systems - see the LICENSE file.\n\n", ANSI_DARK_GRAY)
  end #/def mainbanner



  # The desired effect is to clear the screen
  def IonIO::ansiclear
    IonTerm::ConsoleReader.new.clearScreen
  end #/def ansiclear

  # Print an ANSI graphic file (legacy - see IonTemplate)
  def IonIO.printansifile(filename, paging=true, numlines=25)
    # =>TODO: Add Paging feature to limit number of lines with more prompt
    
    if File.exist?(filename)
      File.open(filename, "r").each { |line| puts line }
    else
      return 1
    end
  end #/def printansifile

  # Print to stdout that an item is starting
  def IonIO.printstart(txt)
    ansiprint(txt, ANSI_WHITE)
    ansiprint("."*(60-txt.length), ANSI_GRAY)
  end #/def printstart

  # Print to stdout the result
  def IonIO.printreturn(retval)
    ansiprint("[", ANSI_BLUE)
    if retval == 0
      ansiprint("DONE", ANSI_BRIGHT_CYAN)
    elsif retval == 1
      ansiprint("FAIL", ANSI_BRIGHT_RED)
    elsif retval == 2
      ansiprint("WAIT", ANSI_CYAN)
    else
      ansiprint("????", ANSI_BRIGHT_MAGENTA)
    end
    ansiprint("]\n", ANSI_BLUE)
  end #/def printreturn

  # Paging Function to incorporate scrolling into program  
  # adapted from code written by : Nathan Weizenbaum
  # http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
  # * WARN * Allowing execution of an external program is not good security
  # practices. Audit this for a better method.
  def IonIO.run_pager
    return unless STDOUT.tty?
    read, write = IO.pipe
    unless Kernel.fork # Child process
      STDOUT.reopen(write)
      STDERR.reopen(write) if STDERR.tty?
      read.close
      write.close
      return
    end
    # Parent process, become pager
    STDIN.reopen(read)
    read.close
    write.close
    ENV['LESS'] = '-FSRX' # Don't page if the input is short enough
    ENV['LESSSECURE'] = '1' # Turn on secure less (see man page)
    Kernel.select [STDIN] # Wait until we have input before we start the pager
    pager = ENV['PAGER'] || 'less'
    exec pager rescue exec "/bin/sh", "-c", pager
  end #/def run_pager



  # Terminal detection to determine support, dimensions, etc.
  def IonIO::terminaldetect
        term = IonTerm::Terminal.terminal.new
    terminfo = {
      :supported  => term.is_supported,
      :ansi       => term.is_ansisupported,
      :height     => term.getTerminalHeight,
      :width      => term.getTerminalWidth,
      :echo       => term.is_echo_enabled
    }
    return terminfo
  end

  # Asks user a question. Wraps display of a template and inputform.
  def IonIO::question(template, inputsize)
    t = IonTemplate::Template.new(template)
    t.render()
    if inputsize > 1
      answer = IonIO::Input.inputform(inputsize)
    elsif inputsize == 1
      answer = IonIO::Input.inputkey
    end    
    return answer
  end

  # Asks user a question. Wraps display of a template and inputform.
  def IonIO::password(template, inputsize)
    t = IonTemplate::Template.new(template)
    t.render()
    pw = IonIO::Input.passwordform(inputsize)
    return pw
  end  
  
  # Displays menu from template and prompts user for inputkey.
  def IonIO::menu(template)
    t = IonTemplate::Template.new(template)
    t.render()
    selection = IonIO::Input.inputkey
    return selection
  end


end #/module