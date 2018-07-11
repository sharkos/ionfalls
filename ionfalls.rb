#!/usr/bin/env jruby
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
= IonFalls
IonFalls Main Runtime
=end

# Disable Warning Messages from JRuby
$VERBOSE = nil

# Set the hostname of the IonServer manually - This is for testing ONLY.
# We will use a kernel parameter passed by the bootloader (/proc/cmdline)
# to obtain this in production. But for now, we test!
$ionserver = 'server.ionfalls.com'
#$ionserver = '127.0.0.1'

require 'lib/ionloader.rb'
cmdswitch = IonLoader.getoptions(ARGV)


if cmdswitch[:gencfg] == true
    #securityconf = 'conf/security.conf.yaml'
    #unless File.exist?(securityconf)
    #  require 'lib/ionsecurity'
    #  IonSecurity::Config.makedefault(securityconf)
    #  puts "Sample config created: #{securityconf}"
    #else
    #  puts "Security file exist, not generating."
    #end

    configfile = 'conf/ionfalls.conf.yaml'
    unless File.exist?(configfile)
      require 'lib/ionconfig'
      IonConfig.makedefault(configfile)
      puts "Sample config created: #{configfile}"
    else
      puts "Configuration file exist, not generating."
    end
  exit 0 # Exit after this call.
end

# Make sure the program is called in only one mode.
if cmdswitch[:server] == true and cmdswitch[:client] == true then
  puts "Invalid Switch Combination: Cannot run in both client and server modes."
  exit
end

# Run Client
if cmdswitch[:client] then
  IonLoader.init_client


  m = MainController.new
  m.populate_machine
    puts "Querying in-memory database: Machine"
    require 'pp'
    pp Machine.first
  IonLoader.run_client
end

# Run Server
if cmdswitch[:server] then
  IonLoader.init_server
  IonLoader.run_server
end

