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
= IonProbe/windows (Windows Probe)
IonProbe/windowsprobes a Microsoft Windows Operating System.
=end

# WINDOWS
module IonProbe

  #---------------------------------------------------------------------------
  # Linux Specific Operating System Class
  class IonProbe::OperatingSystem

    # Determine the linux distro and chain to the specific vendor override file
    def initialize
      @distro = detect_windows_sysinfo      
    end

    public

    # common: Operating system architecture (from uname)
    def get_os_arch      
      return @distro[:arch]
    end

    # generic: Gets the generic linux name if we are unable to identify distro
    #  this method should be overridden in vendor classes.
    def get_os_name
      return @distro[:name]
    end

    def get_os_vendor
      return @distro[:vendor]
    end

    def get_os_version
      return @distro[:version]
    end

    def get_os_codename
      return @distro[:version]
    end

    def get_os_description
      return @distro[:description]
    end

    def get_kernel_name
      return "Windows"
    end

    def get_kernel_version
      return @distro[:version]
    end

    def get_kernel_arch
      return @distro[:arch]
    end

    def get_uptime
      return @distro[:uptime]
    end

    private
    
    # Detect Windows System Information
    def detect_windows_sysinfo
      require 'ruby-wmi'
      os = WMI::Win32_OperatingSystem.find(:all).first
      wmios = {:name        => "Windows",
               :vendor      => os["Manufacturer"],
               :description => os["Caption"],
               :version     => os["Version"],                
               :arch        => os["OSArchitecture"],
               :serial      => os["SerialNumber"],
               :installdate => os["InstallDate"],
               :uptime      => os["LastBootUpTime"]
              }
    end #/detect_windows_sysinfo

  end #/OperatingSystem
  #---------------------------------------------------------------------------

  #---------------------------------------------------------------------------
  # Linux Specific Hardware Probes Class
  class IonProbe::Hardware

    # Determine the linux distro and chain to the specific vendor override file
    def initialize
      @cpuinfo = detect_cpu_info
      @meminfo = detect_mem_info
    end

    public

    def get_cpu_count
      return @cpuinfo[:cpu_count]
    end

    # Get the cpu model name
    def get_cpu_name
      return @cpuinfo[:cpu_name]
    end

    # Get cpu vendor_id or name
    def get_cpu_vendor
      return @cpuinfo[:cpu_vendor]
    end

    # Get the cpu speed
    def get_cpu_speed
      return @cpuinfo[:cpu_speed]
    end

    # Get the cpu core count
    def get_cpu_cores
      return @cpuinfo[:cpu_cores]
    end

    # Get the cpu cache size
    def get_cpu_cache
      return @cpuinfo[:cache_size]
    end

    # Get the cpu flags
    def get_cpu_flags
      return @cpuinfo[:flags]
    end

    # Get total system memory
    def get_mem_total
      return @meminfo[:mem_total]
    end

    # Get free system memory
    def get_mem_free
      return @meminfo[:mem_free]
    end

    # Get total swap area
    def get_swap_total
      return @meminfo[:swap_total]
    end

    # Get free swap area
    def get_swap_free
      return @meminfo[:swap_free]
    end

    private

    # Windows: retrieve the CPU information from WMI
    def detect_cpu_info    
        wmics =  WMI::Win32_ComputerSystem.find(:all).first
        wmicpu = WMI::Win32_Processor.find(:all).first
        cpu_map = { :timestamp  => Time.now,
                    :cpu_count  => wmics["NumberOfProcessors"],
                    :cpu_vendor => wmicpu["Manufacturer"],
                    :cpu_name   => wmicpu["Name"],
                    :cpu_speed  => wmicpu["MaxClockSpeed"],
                    :cpu_cores  => wmicpu["NumberOfCores"],
                    :cpu_flags  => "ionfalls-NULL",
                    :cache_size => wmicpu["L2CacheSize"]+wmicpu["L3CacheSize"]
                  }
        return cpu_map
    end #/get_cpu_info

    # Linux: read the procfile for meminfo
    def detect_mem_info
        wmics =  WMI::Win32_ComputerSystem.find(:all).first
        wmios = WMI::Win32_OperatingSystem.find(:all).first        
        mem_map = { :timestamp  => Time.now,
                    :mem_total  => wmics["TotalPhysicalMemory"],
                    :mem_free   => wmios["FreePhysicalMemory"],
                    :swap_total => wmios["TotalVirtualMemorySize"],
                    :swap_free  => wmios["FreeVirtualMemory"]
                  }
        return mem_map
    end #/get_cpu_info

  end #/Hardware
  #---------------------------------------------------------------------------

  #---------------------------------------------------------------------------
  # Detects the networking of the machine
  class IonProbe::Network

    def initialize
      @netinfo = get_network_info
    end

    public

    # Get fqdn hostname
    def get_hostname
      return @netinfo[:hostname]
    end

    # Get a list of network interfaces
    def get_iface_list
      return @netinfo[:iface_list]
    end

    # Get a count of known interfaces
    def get_iface_count
      return @netinfo[:iface_count]
    end

    # Get a specific 'iface's ip3 information
    def get_iface_ip4address(iface)
      return find_dev_info(iface)[:ipv4address]
    end

    def get_iface_ip4netmask(iface)
      return find_dev_info(iface)[:ipv4netmask]
    end

    # Get a specific 'iface's ip6 information
    def get_iface_ip6address(iface)
      return find_dev_info(iface)[:ipv6address]
    end

    def get_iface_ip6netmask(iface)
      return find_dev_info(iface)[:ipv6netmask]
    end

    # Get a specific 'iface's mac address
    def get_iface_macaddress(iface)      
      return find_dev_info(iface)[:macaddress]
    end

    private

    # Find the device information by scanning the array of hashes and locating the record
    def find_dev_info(iface)
      iface_list = @netinfo[:iface_list]
      iface_list.each do |dev|
        if dev[:name] = iface then
          return dev
        end
      end
      return nil
    end #/find_dev_info

    # Linux: retrieve network information
    def get_network_info               
        iface_list = []
        wminet = WMI::Win32_NetworkAdapterConfiguration.find(:all, :conditions => { :ipenabled => true })
        #query = "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = 'TRUE'";
        #wminet = WMI.ExecQuery(query)
        wminet.each do |dev|
        # Assemble the dev_info hash using the parsed data - note: IRB hint - wminet.first.attributes
        dev_info = { :name => dev.description,
                     :ipv4address => dev.ipaddress[0].to_s,
                     :ipv4netmask => dev.ipsubnet[0].to_s,
                     :ipv6address => dev.ipaddress[1].to_s,
                     :ipv6netmask => dev.ipsubnet[1].to_s,
                     :macaddress => dev.mac_address
                   }        
        iface_list.push(dev_info)
      end
        hostname = "#{wminet.first.dnshostname}.#{wminet.first.dnsdomain}"

      # Finally, return the network information hash
      net_info = {:hostname =>hostname, :iface_count => iface_list.count, :iface_list => iface_list}
      return net_info
    end #/get_network_info

  end #/Network


end #/module