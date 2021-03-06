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
module IonDatabase
  require 'rubygems'
  require 'active_record'

  # Create Database Connection for client (using file).
  def IonDatabase.connect_client(db)
    dbpwd = IonSecurity::ConfigPassword.new.decrypt(db['pass'])

    begin
      require 'java'
    rescue LoadError
      raise "FATAL: Unable to load JAVA hooks. IonFalls requires JRuby >= #{MIN_JRUBY_VERSION}"
    end
    # -> Try to connect to H2 Database from ActiveRecord
    begin
      ActiveRecord::Base.establish_connection(adapter: 'h2', database: 'file:db/ionclient', user: "#{db['user']}", password: dbpwd)
    rescue ActiveRecord::AdapterNotFound => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue ActiveRecord::ActiveRecordError => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue Java::NativeException => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    end
  end #/def connect_client


  # Create Database Connection for stateless clients (using memdb)
  def IonDatabase.connect_stateless
    begin
      require 'java'
    rescue LoadError
      raise "FATAL: Unable to load JAVA hooks. IonFalls requires JRuby >= #{MIN_JRUBY_VERSION}"
    end
    # -> Try to connect to H2 Database from ActiveRecord
    begin
      ActiveRecord::Base.establish_connection(adapter: 'h2', database: 'mem:ionclient', user: "sa", password: "ionfalls")
    rescue ActiveRecord::AdapterNotFound => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue ActiveRecord::ActiveRecordError => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue Java::NativeException => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    end
  end #/def sconnect

  # Create Database Connection based on type of either H2 Embedded or External Remote.
  def IonDatabase.connect_server(db)
    dbpwd = IonSecurity::ConfigPassword.new.decrypt(db['pass'])
    begin
      require 'java'
    rescue LoadError
      raise "FATAL: Unable to load JAVA hooks. IonFalls requires JRuby >= #{MIN_JRUBY_VERSION}"
    end
    begin
      case db['adapter']
        when 'postgresql'
          ActiveRecord::Base.establish_connection(
              adapter: 'jdbcpostgresql',
              host: "#{db['host']}",
              port: "#{db['port']}",
              database: "#{db['name']}",
              user: "#{db['user']}",
              password: dbpwd
          )

        when 'h2'
          ActiveRecord::Base.establish_connection(
              adapter: 'h2',
              host: "#{db['host']}",
              port: "#{db['port']}",
              database: "#{db['name']}",
              user: "#{db['user']}",
              password: dbpwd
          )
        else
          raise "ERROR: Database adapter specified '#{db['adapter']}' is invalid or unsupported."
      end
    rescue ActiveRecord::AdapterNotFound => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue ActiveRecord::ActiveRecordError => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    rescue Java::NativeException => e
      raise "ERROR: Unable to connect to embedded database. (#{e})"
    end
  end #/def connect_server


  # => Initialize the database (reserved)
  def IonDatabase.initdb
  end #/dev init
  
end # /module
