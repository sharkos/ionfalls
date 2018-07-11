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
= IonSecurity
Library for common security routines used in IonFalls
=end

module IonSecurity

require 'yaml'
require 'rubygems'
require 'bcrypt'
require 'lib/rubyclass_extensions'
require 'uuidtools'
require 'lib/ionmachine'

SecurityConfigFile = './conf/security.conf.yaml'

# Create UUID as a global variable
$UUID= UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, "client.ionfalls.com")

# COMMENTED OUT FOR STATELESS CLIENT
  # Define the structure of the Configuration File for Security.
  class Config

    def Config.makedefault(filename)
      # Using the Java Utils random (but does not create consistent UUID for stateless systems)
      #"uuid" => JavaUtil::UUID.randomUUID.to_s,

      # Using the uuidtools rubygem
      uuid= UUIDTools::UUID.md5_create(UUIDTools::UUID_DNS_NAMESPACE, "clients.ionfalls.com")

      puts "Creating unique security profile..."
      cfghash = {
              "uuid" => uuid,
              "secret" => IonSecurity::UserPassword.new.cryptpassword(rand.to_s).to_s }
      f = File.open(filename, "w")
      f.puts YAML::dump(cfghash)
      f.close
    end #/def makedefault

  end #/class Config



  # Handlers for user passwords stored in the database
  class UserPassword

    # Encrypt Password with BCrypt
    def cryptpassword(cleartxt)
       return BCrypt::Password.create(cleartxt)
    end

    # Validate a user password stored vs input
    def validate(input,stored)
       
    end

  end #/class UserPassword


  # Handlers for configuration passwords stored in plaintext yaml files/
  class ConfigPassword

    def initialize
      @security = File.open("./conf/security.conf.yaml")  { |yf| YAML::load( yf ) }
      @te = JasyptText::BasicTextEncryptor.new
      @te.setPassword(@security['secret'])
    end

    # Encrypt using the unique secret as the salt
    def encrypt(cleartxt)      
      return @te.encrypt(cleartxt)
    end

    # Decrypt using the unique secret as the salt
    def decrypt(crypted)
      return @te.decrypt(crypted)
    end

  end #/class ConfgPassword


end #/module Security


