=begin
-------------------------------------------------------------------------------
 _             _______     _ _
| |           (_______)   | | |
| | ___  ____  _____ _____| | |  ___
| |/ _ \|  _ \|  ___|____ | | | /___)
| | |_| | | | | |   / ___ | | ||___ |
|_|\___/|_| |_|_|   \_____|\_)_|___/

(C)opyright 2012, LeafScale Systems, Inc. and P. Chris Tusa
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
= IonConstants (Global Constants)
IonConstants defines all of the program's constants and Java Class imports.
=end


# Version Information
IONFALLS_VERSION="0.2"
IONCLIENT_VERSION=20120805
VERSION_IS_STABLE=false

MIN_JRUBY_VERSION="1.7.3"

CLIENT_TCP_PORT=9118
SERVER_TCP_PORT=9119


# Template Directory for FreeMarker templates
TPL_DIR="tpls/"

# Fallback theme if user-defined does not exist
TPL_DEFAULT="ionfalls"

# ANSI COLORS DEFINITIONS (not Term::ANSIColor)
ANSI_RESET     = "\e[0m"
ANSI_BOLD      = "\e[1m"
ANSI_DARK      = "\e[2m"
ANSI_ITALIC    = "\e[3m"
ANSI_UNDERLINE = "\e[4m"
ANSI_BLINK     = "\e[5m"
ANSI_RAPID     = "\e[6m"
ANSI_NEGATIVE  = "\e[7m"
ANSI_CONCEALED = "\e[8m"
ANSI_STRIKE    = "\e[9m"

# -> BASE COLORS
ANSI_BLACK     = "\e[0;30m"
ANSI_RED       = "\e[0;31m"
ANSI_GREEN     = "\e[0;32m"
ANSI_YELLOW    = "\e[0;33m"
ANSI_BLUE      = "\e[0;34m"
ANSI_MAGENTA   = "\e[0;35m"
ANSI_CYAN      = "\e[0;36m"
ANSI_GRAY      = "\e[0;37m"
ANSI_GREY      = "\e[0;37m"

# -> BACKGROUND COLORS
ANSI_ON_BLACK  = "\e[40m"
ANSI_ON_RED    = "\e[41m"
ANSI_ON_GREEN  = "\e[42m"
ANSI_ON_YELLOW = "\e[43m"
ANSI_ON_BLUE   = "\e[44m"
ANSI_ON_MAGENTA= "\e[45m"
ANSI_ON_CYAN   = "\e[46m"
ANSI_ON_WHITE  = "\e[47m"

# -> BRIGHTENED BASE COLORS
ANSI_DARK_GRAY      = "\e[1;30m"
ANSI_BRIGHT_RED     = "\e[1;31m"
ANSI_BRIGHT_GREEN   = "\e[1;32m"
ANSI_BRIGHT_YELLOW  = "\e[1;33m"
ANSI_BRIGHT_BLUE    = "\e[1;34m"
ANSI_BRIGHT_MAGENTA = "\e[1;35m"
ANSI_BRIGHT_CYAN    = "\e[1;36m"
ANSI_WHITE          = "\e[1;37m"
ANSI_BRIGHT_WHITE   = ANSI_WHITE

# Defines the full list of ANSI codes as a Hash for use elsewhere
ANSICOLORS = {
   "reset" => ANSI_RESET, #+ ANSI_ON_BLACK,
   "norm" => ANSI_RESET,
   "bold" => ANSI_BOLD,
   "dark" => ANSI_DARK,
   "italic" => ANSI_ITALIC,
   "underline" => ANSI_UNDERLINE,
   "blink" => ANSI_BLINK,
   "rapid" => ANSI_RAPID,
   "negative" => ANSI_NEGATIVE,
   "concealed" => ANSI_CONCEALED,
   "strike" => ANSI_STRIKE,
   "black" => ANSI_BLACK,
   "red" => ANSI_RED,
   "green" => ANSI_GREEN,
   "yellow" => ANSI_YELLOW,
   "blue" => ANSI_BLUE,
   "magenta" => ANSI_MAGENTA,
   "cyan" => ANSI_CYAN,
   "gray" => ANSI_WHITE,
   "grey" => ANSI_WHITE,
   "on_black" => ANSI_ON_BLACK,
   "on_red" => ANSI_ON_RED,
   "on_green" => ANSI_ON_GREEN,
   "on_yellow" => ANSI_ON_YELLOW,
   "on_blue" => ANSI_ON_BLUE,
   "on_magenta" => ANSI_ON_MAGENTA,
   "on_cyan" => ANSI_ON_CYAN,
   "on_white" => ANSI_ON_WHITE,
   "lightred" => ANSI_BRIGHT_RED,
   "lightgreen" => ANSI_BRIGHT_GREEN,
   "lightyellow" => ANSI_BRIGHT_YELLOW,
   "lightblue" => ANSI_BRIGHT_BLUE,
   "lightmagenta" => ANSI_BRIGHT_MAGENTA,
   "lightcyan" => ANSI_BRIGHT_CYAN,
   "lightgray" => ANSI_GRAY,
   "lightgrey" => ANSI_GREY,
   "white" => ANSI_WHITE,
   "brightred" => ANSI_BRIGHT_RED,
   "brightgreen" => ANSI_BRIGHT_GREEN,
   "brightyellow" => ANSI_BRIGHT_YELLOW,
   "brightblue" => ANSI_BRIGHT_BLUE,
   "brightmagenta" => ANSI_BRIGHT_MAGENTA,
   "brightcyan" => ANSI_BRIGHT_CYAN,
   "brightwhite" => ANSI_WHITE,
   "brightgray" => ANSI_GRAY,
   "brightgrey" => ANSI_GREY,
   "darkblack" => ANSI_BLACK,
   "darkred" => ANSI_RED,
   "darkgreen" => ANSI_GREEN,
   "darkyellow" => ANSI_YELLOW,
   "darkblue" => ANSI_BLUE,
   "darkmagenta" => ANSI_MAGENTA,
   "darkcyan" => ANSI_CYAN,
   "darkgray" => ANSI_DARK_GRAY,
   "darkgrey" => ANSI_DARK_GRAY,
   "brown" => ANSI_YELLOW,
}

require 'lib/rubyclass_extensions'