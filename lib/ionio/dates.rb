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
= IonIO::Dates
Date manipulation routines for IonIO
=end

=begin
 TODO: * Date format is adjustable by config
 TODO: * Introduce Validation of Dates into this library
=end


module IonIO
  module Dates
require 'date'

# Input a year
def Dates::inputyear
  tr = IonTerm::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 4
  vals = (48..57)
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"YYYY")
  print "\b" * 4
  until cursize == maxsize
    char = tr.readVirtualKey
    if vals.include?(char)
      input.push(char.chr)
      print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
      cursize +=1
    else
      print "\b"+ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+" \b"
    end #/if
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputyear

# Input a month
def Dates::inputmonth
  tr = IonTerm::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 2
  vals1 = (48..49) # Month first digit is either 0 or 1
  vals2 = (48..57) # Month second digit is 0 thru 9
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM")
  print "\b" * 2
  # TODO - Ensure val2 does not exceed 2 if val1 = 1
  until cursize == maxsize
    char = tr.readVirtualKey
    case cursize
      when 0
        if vals1.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
      when 1
        if vals2.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
    end
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputmonth

# Input a day
def Dates::inputday
  tr = IonTerm::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  maxsize = 2
  vals1 = (48..51) # Month first digit is either 0 or 1
  vals2 = (48..57) # Month second digit is 0 thru 9
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM")
  print "\b" * 2
  # TODO - Ensure val2 does not exceed 2 if val1 = 1
  until cursize == maxsize
    char = tr.readVirtualKey
    case cursize
      when 0
        if vals1.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
      when 1
        if vals2.include?(char)
          input.push(char.chr)
          cursize +=1
          print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+char.chr
        end #/if
    end
  end #/until
  print ANSI_RESET
  value = ""
  input.each do |c|
    value.concat(c)
  end
  return value
end #/def inputday


# Inputs a date
def Dates::inputdate
  #TODO: BUGFIX REQUIRED - Fix issue with backspacing during date input causing invalid entry.
  trap("INT") do
    # ignore "CTRL-C"
  end
  tr = IonTerm::ConsoleReader.new
  char = nil
  enterkey = false
  input = []
  cursize = 0
  print ANSI_RESET+(ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"MM/DD/YYYY")
  print "\b" * 10
  month = self.inputmonth
  print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"/"
  day   = self.inputday
  print ANSI_BRIGHT_WHITE+ANSI_ON_BLUE+"/"
  year  = self.inputyear
  print ANSI_RESET
  print "\n"
  value = Date.parse("#{year}-#{month}-#{day}")
  return value
end #/def inputdate

  end #/module
end #/module