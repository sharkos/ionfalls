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
= IonProbe/linux (Linux Probe)
IonProbe/linux probes a Linux Operating System.
=end

# LINUX
module IonProbe

  #---------------------------------------------------------------------------
  # Linux Specific Operating System Class
  class IonProbe::OperatingSystem

    # Determine the linux distro and chain to the specific vendor override file
    def initialize
      @distro  = detect_linux_distro
      @kernel  = detect_linux_kernel
    end

    public

    # common: Operating system architecture (from uname)
    def get_os_arch
      arch = `uname -m` .chomp!
      return arch
    end

    # generic: Gets the generic linux name if we are unable to identify distro
    #  this method should be overridden in vendor classes.
    def get_os_name
      osname = `uname -s`.chomp!
    end

    def get_os_vendor
      return @distro[:vendor]
    end

    def get_os_version
      return @distro[:version]
    end

    def get_os_codename
      return @distro[:codename]
    end

    def get_os_description
      return @distro[:description]
    end

    def get_kernel_name
      return @kernel[:name]
    end

    def get_kernel_version
      return @kernel[:version]
    end

    def get_kernel_arch
      return @kernel[:arch]
    end

    def get_uptime
      return `uptime`.chomp
    end

    private

    # Detect the Linux distro
    def detect_linux_distro
      # Method 1: If the distro is LSB compliant, use the LSB information
      if File.exists?("/usr/bin/lsb_release")
        lsb_release = `env lsb_release -a`
        lsb_release = lsb_release.split("\n")
        h = Hash.new
        lsb_release.each do |a|
          item = a.split(":\t")
          h2 = Hash.new
          h2 = {"#{item[0]}" => "#{item[1]}"}
          h = h.merge(h2)
        end
        distro = {:vendor => h["Distributor ID"], :description => h["Description"], :version => h["Release"], :codename=> h["Codename"]}
      else
      # Method 2: Scan for distro release files
      # => Additional distributions may be added to the hash
        releasefile = {
          'rhcompat'	=> '/etc/redhat-release',
          'arch'      => '/etc/arch-release',
          'debcompat' => '/etc/debian_version',
          'suse'      => '/etc/SuSE-release',
          'sharkos'   => '/etc/sharkos-release'
        }
        #TODO - Parse these files and collect the data

      end
      return distro
    end

    # Detect the kernel information
    def detect_linux_kernel
      kernel_name =   `uname -s`.chomp
      kernel_vers = `uname -r`.chomp
      kernel_arch = `uname -m`.chomp
      kernel = {:name => kernel_name, :version => kernel_vers, :arch => kernel_arch}
      return kernel
    end

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
      return @cpuinfo["cpu_count"]
    end

    # Get the cpu model name
    def get_cpu_name
      return @cpuinfo["model name"]
    end

    # Get cpu vendor_id or name
    def get_cpu_vendor
      return @cpuinfo["vendor_id"]
    end

    # Get the cpu speed
    def get_cpu_speed
      return @cpuinfo["cpu MHz"]
    end

    # Get the cpu core count
    def get_cpu_cores
      return @cpuinfo["cpu cores"]
    end

    # Get the cpu cache size
    def get_cpu_cache
      return @cpuinfo["cache size"]
    end

    # Get the cpu flags
    def get_cpu_flags
      return @cpuinfo["flags"]
    end

    # Get total system memory
    def get_mem_total
      return ApacheCommonsLang::StringUtils.strip(@meminfo["MemTotal"],"KkBbMmGgTt ")
    end

    # Get free system memory
    def get_mem_free
      return ApacheCommonsLang::StringUtils.strip(@meminfo["MemFree"],"KkBbMmGgTt ")
    end

    # Get total swap area
    def get_swap_total
      return ApacheCommonsLang::StringUtils.strip(@meminfo["SwapTotal"],"KkBbMmGgTt ")
    end

    # Get free swap area
    def get_swap_free
      return ApacheCommonsLang::StringUtils.strip(@meminfo["SwapFree"],"KkBbMmGgTt ")
    end

    private

    # Linux: read the procfile for cpuinfo
    def detect_cpu_info
      if File.exists?('/proc/cpuinfo')
        cpu_info = []
        # Process the proc file, cleanup the output, remove spaces & special chars, convert to array
        procfile = File.read("/proc/cpuinfo").chomp
        procfile = ApacheCommonsLang::StringUtils.splitByWholeSeparator(procfile, "\n").to_a
        procfile.each do |i|
          normalized = ApacheCommonsLang::StringUtils.normalizeSpace(i)
          cpu_info.push(normalized.split(":"))
        end
        # Parse the new array into a HashMap with no spaces and discard null entries
        cpu_map = { "timestamp" => Time.now }
        cpu_count = 0
        cpu_info.each do |x|
          unless x[0].nil? || x[1].nil?
            hm = {x[0].strip => x[1].strip}
            # Keep count of processors so we know how many sockets
            if hm.key?("processor")
              cpu_count =+ 1
            end
            cpu_map.merge!(hm)
          end
        end
        cpu_map.merge!({"cpu_count" => cpu_count})
        return cpu_map
      else
        return nil
      end
    end #/get_cpu_info

    # Linux: read the procfile for meminfo
    def detect_mem_info
      if File.exists?('/proc/meminfo')
        mem_info = []
        # Process the proc file, cleanup the output, remove spaces & special chars, convert to array
        procfile = File.read("/proc/meminfo").chomp
        procfile = ApacheCommonsLang::StringUtils.splitByWholeSeparator(procfile, "\n").to_a
        procfile.each do |i|
          normalized = ApacheCommonsLang::StringUtils.normalizeSpace(i)
          mem_info.push(normalized.split(":"))
        end
        # Parse the new array into a HashMap with no spaces and discard null entries
        mem_map = { "timestamp" => Time.now }
        mem_info.each do |x|
          unless x[0].nil? || x[1].nil?
            hm = {x[0].strip => x[1].strip}
            mem_map.merge!(hm)
          end
        end
        return mem_map
      else
        return nil
      end
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
      puts "IonProbe/Linux: find_dev_info(#{iface} - macaddress"
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
      ns_lines = []      # Netstat line listing array
      ip_lines = []     # IP Command line listing array
      dev_list = []     # Interface device array list
      iface_list = []   # Interface listing hash
      # Collect the netstat interace information for parsing
      netstat_i = `netstat -i`.chomp
      netstat_i = ApacheCommonsLang::StringUtils.splitByWholeSeparator(netstat_i, "\n").to_a
      netstat_i.each do |nsline|
        unless nsline.downcase.include?("kernel interface table") or nsline.downcase.include?("iface") then
          normalized = ApacheCommonsLang::StringUtils.normalizeSpace(nsline)
          ns_lines.push(normalized.split(" "))
        end
      end
      # Sort the netstate line listing and extract the interface dev names into an array
      ns_lines.each do |iface|
        dev_list.push(iface[0])
      end
      # Collect the information on a specific device and create a hash-map entry.
      dev_list.each do |dev|
        # Skip and Delete TUNNEL interfaces from the device list
        if dev.include?("tun") then
          dev_list.delete(dev)
          break
        end
        # Run the IP show command on the current interface and parse the data
        ip_show = `ip address show #{dev}`.chomp
        ip_show = ApacheCommonsLang::StringUtils.splitByWholeSeparator(ip_show, "\n").to_a
        # Assemble the dev_info hash using the parsed data
        dev_info = { :name => dev,
                     :ipv4address => ApacheCommonsLang::StringUtils.stripToEmpty(ip_show[2]).split(" ")[1].split("/")[0],
                     :ipv4netmask => ApacheCommonsLang::StringUtils.stripToEmpty(ip_show[2]).split(" ")[1].split("/")[1],
                     :ipv6address => ApacheCommonsLang::StringUtils.stripToEmpty(ip_show[3]).split(" ")[1].split("/")[0],
                     :ipv6netmask => ApacheCommonsLang::StringUtils.stripToEmpty(ip_show[3]).split(" ")[1].split("/")[1],
                     :macaddress => ApacheCommonsLang::StringUtils.stripToEmpty(ip_show[1]).split(" ")[1]
                   }
        iface_list.push(dev_info)
      end
      hostname = `hostname -f`.chomp
      # Finally, return the network information hash
      net_info = {:hostname =>hostname, :iface_count => iface_list.count, :iface_list => iface_list}
      return net_info
    end #/get_network_info

  end #/Network


end #/module