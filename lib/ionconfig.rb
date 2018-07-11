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
= IonConfig (Configuration)
IonConfig handles configuration file management Configuration is stored in YAML syntax formatting.
=end


module IonConfig
  require 'yaml'
  require 'rubygems'
  require 'bcrypt'
  #require 'lib/ionsecurity'
  require 'lib/ionio'

  Configfile = "./conf/ionfalls.conf.yaml"

  # Ask for input of the Hostname variable
  def IonConfig.askHostName
    hostname = java.net.InetAddress.getLocalHost.getHostName
    IonTemplate::display('gencfg_hostname.ftl', {"hostname"=>hostname})
      if IonIO::Input.inputyn() == false then
        hostname = IonIO.question('gencfg_get_hostname.ftl',50)
      end
    return hostname
  end

  # Ask for input of the Server Listen Addresses & Port
  def IonConfig.askServerListenAddr      
    listen_ipv4 = '0.0.0.0'
    listen_ipv6 = '::/128'
    listen_port = '9119'

    IonTemplate::display('gencfg_listenaddr.ftl', {"listen_ipv4"=>listen_ipv4, "listen_ipv6"=>listen_ipv6, "listen_port"=>listen_port})
      if IonIO::Input.inputyn() == false then
        listen_ipv4 = IonIO.question('gencfg_get_listen_ipv4.ftl',16)
        listen_ipv6 = IonIO.question('gencfg_get_listen_ipv6.ftl',64)
        listen_port = IonIO.question('gencfg_get_listen_port.ftl',5)
      end
    return {"ipv4"=>listen_ipv4, "ipv6"=>listen_ipv6, "port"=>listen_port}
  end

  # Ask for input of the Database for Server Mode
  def IonConfig.askServerDatabase
    dbengine = IonIO::Input.menuprompt('gencfg_get_db_adapter.ftl', ['H','P','O','M','D','I','N'])
      # TODO: Add Database specific tuning option, specifically, show a sample connection string.
      case dbengine        
        when 'H' # H2 TCP server
          puts "2"
          adapter = "h2"
        when 'P' # PostgreSQL
          puts "ostgresql"
          adapter = "postgresql"
        # ADAPTERS BELOW THIS LINE ARE UNSUPPORTED - BUT RESERVED FOR FUTURE TESTING
        # ------------------ #        
        when 'O' # Oracle
          puts "racle"
          adapter = "oracle"
        when 'M' # Mysql
          puts "ySQL"
          adapter = "mysql"
        when 'D' # IBM DB2
          puts "B2"
          adapter = "db2"
        when 'I' # Ingres
          puts "nformix"
          adapter = "informix"
        when 'N' # Ingres
          puts " - Ingres"
          adapter = "ingres"
          # ------------------ #
      end
        
      host = IonIO.question('gencfg_get_db_host.ftl',50)
      port = IonIO.question('gencfg_get_db_port.ftl',6)
      if port.empty? then # SET THE DEFAULT PORT IN THE CFG FILE
        case adapter        
          when "postgresql"
            port = 5432
          when "h2"
            port = 9092
          when "mysql"
            port = 3306
        end        
      end
      name = IonIO.question('gencfg_get_db_name.ftl',32)
      user = IonIO.question('gencfg_get_db_user.ftl',50)
      dbpw = IonIO.password('gencfg_get_db_pass.ftl',25)    
    return {"adapter"=>adapter, "host"=>host, "port"=>port, "name"=>name, "user"=>user, "pass"=> IonSecurity::ConfigPassword.new.encrypt(dbpw)}
  end  
  
  # Builds a default YAML configuration and outputs the filename specified.
  def IonConfig.makedefault(filename)
    IonIO::ansiclear
    IonTemplate::display('gencfg_overview.ftl')
    # Create initial hash. Subsequent questions will merge values in
    cfg_global = { "theme" => "ionfalls" }
              
    # Question: Configure a Client or Server node
    cfgmode = IonIO::Input.menuprompt('gencfg_mode.ftl', ['C','S'])
    if cfgmode == 'S' then # Server
      puts "erver"
      hostname = self.askHostName
      listen = self.askServerListenAddr
      cfg_server = { "hostname" => hostname,
                     "listen_ipv4" => listen["ipv4"],
                     "listen_ipv6" => listen["ipv6"],
                     "listen_port" => listen["port"],
                     "client_refresh_rate" => 300}

      database = self.askServerDatabase
      cfg_database = {"adapter" => database["adapter"],
                      "host" => database["host"],
                      "port" => database["port"],
                      "name" => database["name"],
                      "user" => database["user"],
                      "pass" => database["pass"]}

      cfg_hash = {"global" => cfg_global, "server" => cfg_server, "database" => cfg_database}

    elsif cfgmode == 'C' then # Client
      puts "lient"
      hostname = self.askHostName
      dbsapwd = IonIO.password('gencfg_clientdb_pass.ftl',40)
      
      cfg_client = { "hostname" => hostname, "db_user"=> "sa","db_pass" => dbsapwd, "enabled"=>true}
      cfg_hash = {"global" => cfg_global, "client" => cfg_client}
      puts "Client SA password set to '#{dbsapwd}'."
    else
      puts "Invalid - an error has occured in IonConfig @cfgmode."      
    end

    f = File.open(filename, "w")
    f.puts YAML::dump(cfg_hash)
    f.close
    
  end

  # Load in the YAML configuration file and returns
  def IonConfig.load
    cfg = File.open(Configfile)  { |yf| YAML::load( yf ) }
    # => Ensure loaded data is a hash. ie: YAML load was OK
    if cfg.class != Hash
       raise "ERROR: IonConfig - invalid format or parsing error."
    # => If all is well, perform deeper validation
    else
      # => PARSE & CHECK: Database Section
      if cfg['database'].nil?
        raise "ERROR: IonConfig - database section not defined."
      else
        raise "ERROR: IonConfig - database user field missing." if cfg['database']['user'].nil?
        raise "ERROR: IonConfig - database pass field missing." if cfg['database']['pass'].nil?

      end #-> /Parse DB

    end #-> /if !Hash

    # => If all is well, return the configuration
    return cfg
  end #/def

end # => /module