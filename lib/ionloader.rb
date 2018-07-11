=begin
-------------------------------------------------------------------------------
 _             _______     _ _
| |           (_______)   | | |
| | ___  ____  _____ _____| | |  ___
| |/ _ \|  _ \|  ___|____ | | | /___)
| | |_| | | | | |   / ___ | | ||___ |
|_|\___/|_| |_|_|   \_____|\_)_|___/

(C)opyright 2011-2013, LeafScale, Inc. and P. Chris Tusa
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
= IonLoader
Routines to initialize IonFalls components
=end

module IonLoader

  # Load the constants definition
  def IonLoader.loadlib_ionconstants
    begin
      require 'lib/ionconstants'
    rescue LoadError
      puts "FATAL: cannot load library 'ionconstants'."
      exit 1
    end
  end

  # Load Library: IonIO
  def IonLoader.loadlib_ionio
    begin
      require 'lib/ionio'      
    rescue LoadError
      puts "FATAL: cannot load library 'ionio'."
      exit 1
    end
    IonIO.mainbanner
  end

  # Load Library: IonProbe
  def IonLoader.loadlib_ionprobe
    begin
      require 'lib/ionprobe'
    rescue LoadError
      puts "FATAL: cannot load library 'ionprobe'."
      exit 1
    end
  end

  # Load Library: Machine
  def IonLoader.loadlib_ionmachine
    begin
      require 'lib/ionmachine'
    rescue LoadError
      puts "FATAL: cannot load library 'ionmachine'."
      exit 1
    end
  end

  # Load Library: Security
  def IonLoader.loadlib_ionsecurity
    begin
      require 'lib/ionsecurity'
    rescue LoadError
      puts "FATAL: cannot load library 'ionsecurity'."
      exit 1
    end
  end

  # Load Library: IonConfig
  def IonLoader.loadlib_ionconfig
    begin
      require 'lib/ionconfig'
    rescue LoadError => e
      puts "FATAL: cannot load library 'ionconfig'. #{e}"
      exit 1
    end
  end

  # Loads configuration into a global $cfg variable
  def IonLoader.load_ionconfig
    begin
      IonIO.printstart "Loading IonFalls configuration"
      $cfg = IonConfig.load
      IonIO.printreturn(0)
    rescue Exception => e
      IonIO.printreturn(1)
      puts e
      exit 1
    end
  end

  # Load Library: IonDatabase
  def IonLoader.loadlib_iondatabase
    begin
      require 'lib/iondatabase'
    rescue LoadError
      puts "FATAL: cannot load library 'iondatabase'."
      exit 1
    end
  end

  # Connect to the user specified DB engine & load the ActiceRecord models - CLIENT
  def IonLoader.load_databaseconn_client
    begin
      IonIO.printstart "Initializing client database connection"
      #$db = IonDatabase.connect($cfg['database']) # Stateful
      $db = IonDatabase.connect_stateless()                 # Stateless
      IonIO.printreturn(0)
    rescue Exception => e
      IonIO.printreturn(1)
      puts e
      exit 1
    end
  end

  # Connect to the user specified DB engine & load the ActiveRecord models - Server
  def IonLoader.load_databaseconn_server
    begin
      IonIO.printstart "Initializing server database connection"
      #$db = IonDatabase.connect($cfg['database']) # Stateful
      $db = IonDatabase.connect_server($cfg['database'])                 # Stateless
      IonIO.printreturn(0)
    rescue Exception => e
      IonIO.printreturn(1)
      puts e
      exit 1
    end
  end

  # Load Library: IonDatabase_models
  def IonLoader.loadlib_iondatabasemodels
    IonIO.printstart "Initializing Database Models"
    IonIO.printreturn(2)
    begin
      require 'lib/iondatabase_models'
    rescue LoadError
      puts "FATAL: cannot load library 'iondatabase_models'."
      exit 1
    rescue ActiveRecord::ActiveRecordError => e
      puts "Unable to connect to database: #{e}"
      exit 1
    end
    IonIO.printstart "Database Models Initialized OK"
    IonIO.printreturn(0)
  end

  # Load Library: IonTemplate
  def IonLoader.loadlib_iontemplate
    begin
      IonIO.printstart "Loading FreeMarker template engine"
      require 'lib/iontemplate'
      IonIO.printreturn(0)
    rescue LoadError
      puts "FATAL: cannot load library 'iontemplate'."
      IonIO.printreturn(1)
      exit 1
    end
  end

  # Load Library: IonController
  def IonLoader.loadlib_ioncontroller
    begin
      IonIO.printstart "Loading Master Controller"
      require 'lib/ioncontroller'
      IonIO.printreturn(0)
    rescue LoadError
      puts "FATAL: cannot load library 'ioncontroller'."
      IonIO.printreturn(1)
      exit 1
    end
  end
  
  def IonLoader.startlogger_server
    require 'logger'
    $LOG = Logger.new('log/ionserver.log', 10, 1024000)
  end

  # Load the entire stack in the correct order. Use this method for anything that requires full init
  def IonLoader.init_client
    self.loadlib_ionconstants
    self.loadlib_ionio
    self.loadlib_ionconfig
    self.load_ionconfig
    self.loadlib_ionprobe
    self.loadlib_ionmachine
    self.loadlib_iondatabase
    self.load_databaseconn_client
    self.loadlib_iondatabasemodels
    self.loadlib_iontemplate
    self.loadlib_ioncontroller
  end

  # Load the entire stack in the correct order. Use this method for anything that requires full init
  def IonLoader.init_server
    self.startlogger_server
    $LOG.info("IonLoader.init_server: STARTING")
    self.loadlib_ionconstants
    self.loadlib_ionio
    self.loadlib_ionconfig
    self.load_ionconfig
    self.loadlib_ionmachine
    self.loadlib_iondatabase
    self.load_databaseconn_server
    self.loadlib_iondatabasemodels
    self.loadlib_iontemplate
    self.loadlib_ioncontroller
    $LOG.info("IonLoader.init_server: OK")
  end

  
  # Parse command line
  def IonLoader.getoptions(args)
    require 'optparse'
    options = {}

    opts = OptionParser.new do |opts|
      opts.banner = "IonFalls - usage:"
      opts.separator ""

      # COMMENTED OUT FOR STATELESS
      opts.on("-g", "--gencfg", "Generate config files") do |g|
        options[:gencfg] = g
      end

      opts.on("-f", "--config", "Use alternate config file") do |f|
        options[:config] = f
      end
      
      #opts.on("--dbsapwd[=MANDATORY]", "Set DB SA Password (config file only)") do |dbsapwd|
      #  options[:dbsapwd] = dbsapwd
      #end

      opts.on("-c", "--client", "Run as Client") do |c|
        options[:client] = c
      end

      opts.on("-s", "--server", "Run as Server") do |s|
        options[:server] = s
      end
      
      opts.on("-v", "--version", "Print version and exit.") do |v|
        options[:version] = v
      end
      
      opts.on_tail("-h", "--help", "Show this help message.") do |h|
        puts opts;
        options[:help] = h
        exit # Halt program execution here.
      end
    end # end opts do

    begin
      opts.parse!
    rescue OptionParser::InvalidOption => invalidcmd
      puts "Invalid command options specified: #{invalidcmd}"
      puts opts
      return 1
    rescue OptionParser::ParseError => error
      puts error
    end # end begin

    # DEFAULT BEHAVIOR
    if options.empty? == true
      options[:client] = true
    end
    options
  end


  # TODO: move this routine to IonClient library.
  def IonLoader.send_client_profile
    IonIO.printstart "Sending machine profile to IonServer"
      # Query courtesy Jeremy Evans (Sequel)
      if @sconn.update_client_machine_entry(Machine.select(*(Machine.columns - [Machine.primary_key])).first(:id=>1)) == true
        IonIO.printreturn(0)
      else
        IonIO.printreturn(1)
      end
  end

  # TODO: move this routine to IonClient library.
  def IonLoader.start_client_daemon
    IonIO.printstart "Starting IonClient Daemon"
      DRb.start_service("druby://0.0.0.0:#{CLIENT_TCP_PORT}", ClientDaemon.new)
    IonIO.printreturn(0)
      DRb.thread.join
  end

  # TODO: move this routine to IonClient library.
  def IonLoader.run_client
    require 'drb'
    include DRbUndumped
      @sconn = DRbObject.new_with_uri("druby://#{$ionserver}:#{SERVER_TCP_PORT}")
      done =false
      until done == true
        begin
          IonIO.printstart "Attempting connection to #{$ionserver}"
          if @sconn.ping == true
            IonIO.printreturn(0)
            done = true
          end
        rescue DRb::DRbConnError
            IonIO.printreturn(2)
            sleep(10)
          done = false
        end
      end
    IonLoader.send_profile
    IonLoader.start_client_daemon
  end

  # TODO: move this routine to IonClient library.
  # This class holds the procedures that the remote side can execute
  # (DRB Server on the IonClient)
  class ClientDaemon
    # Receive a ping and return true
    def ping
      puts "Received Ping @#{Time.now}"
      return true
    end

    def get_status
      Machine.refresh
      IonLoader.send_profile
    end

    def start_vm

    end

  end


  # this def is in the main module
  # Run the IonServer Daemon (multi-threaded components)
  def IonLoader.run_server
    require 'drb'
      done = false
      $LOG.info("IonServerLoader.runserver: START")
      drbthread = Thread.new{
      #until done == true
        IonIO.printstart "Starting IonServer Daemon"
        $LOG.info("Creating Thread: 'drbthread' - listen on druby://#{$cfg['server']['listen_ip']}:#{$cfg['server']['listen_port']}")
        DRb.start_service("druby://#{$cfg['server']['listen_ip']}:#{$cfg['server']['listen_port']}", ServerDaemon.new)
        IonIO.printreturn(0)
      #end
      #DRb.thread.join
      }

     heartbeat = Thread.new{
       IonIO.printstart "Starting IonServer Heartbeat"
       $LOG.info("Creating Thread: 'heartbeat'")
       IonIO.printreturn(0)
       until done == true
          machines = Machine.all
          machines.each do |m|
            begin
              $LOG.info("HeartBeat: refreshing client #{m.uuid}")
              cconn = DRbObject.new_with_uri("druby://#{m.tcp_ip}:#{m.tcp_port}")
              cconn.ping
              cconn.get_status
              $LOG.info("HeartBeat: refresh completed #{m.uuid}")
            rescue DRb::DRbConnError => e
              $LOG.warn("HeartBeat: host down: #{e}")
            end
          end
          sleep($cfg['server']['client_refresh_rate'])
       end
     }
    drbthread.join
    heartbeat.join

    trap "SIGINT", proc {done=true}
    until done == true
      $LOG.info("IonServerLoader.runserver: SIGINT Trapped - exiting.")
    end
  end


  # This is the main class for the DRB Server on the IonServer
  class ServerDaemon
    # Receive a ping and return true
    def ping
      return true
    end

    # Update the client's machine entry from a remote Sequel query
    def update_client_machine_entry(dbobject)
      $LOG.info("Client: #{dbobject[:uuid]} : calling server")
      if Machine.find(:uuid => dbobject[:uuid]) == nil
        #insert
        $LOG.info("Client: #{dbobject[:uuid]} : DB Machine record [INSERT]")
        Machine.create(dbobject)
        #TODO ADD SEQUEL RESCUE BLOCK
      else
        #update
        $LOG.info("Client: #{dbobject[:uuid]} : DB Machine record [UPDATE]")
        Machine.find(:uuid => dbobject[:uuid]).update(dbobject)
        #TODO ADD SEQUEL RESCUE BLOCK
      end

      return true
    end
  end

end #/module