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
= IonProbe (HW & SW Probe)
IonProbe inspects the underlying software to detect the OS & Hardware.
This is the parent class implementation which will chain to a child OS.
=end


module IonProbe

  #---------------------------------------------------------------------------
  # Base Operating System Class. This Class defines the core function names
  # and information that all chain links must implement.
  class IonProbe::OperatingSystem
    attr_accessor :os_name, :os_description, :os_version, :os_vendor, :os_codename, :os_uptime,
                  :kernel_name, :kernel_version

=begin
    def get_os_name
      return nil
    end

    def get_os_vendor
      return nil
    end

    def get_os_version
      return nil
    end

    def get_os_codename
      return nil
    end

    def get_os_description
      return nil
    end

    def get_kernel_name
      return nil
    end

    def get_kernel_version
      return nil
    end

    def get_kernel_arch
      return nil
    end

    def get_uptime
      return nil
    end
=end

    def create_uuid
      return nil
    end

    # Detect the core operating system then load the appropriate chain module
    def probe
      return IonProbe::OperatingSystem.new.collect
    end #/probe

    # This method should not have an override in the chain
    private
    def collect
      data = { :os_name         => self.get_os_name,
               :os_description  => self.get_os_description,
               :os_vendor       => self.get_os_vendor,
               :os_version      => self.get_os_version,
               :os_codename     => self.get_os_codename,
               :os_kernel_name  => self.get_kernel_name,
               :os_kernel_version => self.get_kernel_version,
               :os_kernel_arch  => self.get_kernel_arch,
               :os_uptime       => self.get_uptime
      }
    end

    host_os = RbConfig::CONFIG['host_os'].downcase
    case host_os
      when /linux/
        require 'lib/ionprobe/linux'
      when /netbsd/
        require 'lib/ionprobe/netbsd'
      when /mswin/
        require 'lib/ionprobe/windows'
      when /darwin/
        require 'lib/ionprobe/darwin'
      else
        raise "HALT: Unrecognized host operating system."
        exit 1
    end

  end #/IonProbe::OperatingSystem
  #---------------------------------------------------------------------------

  #---------------------------------------------------------------------------
  # Detects the hardware presented by the Operating System
  class IonProbe::Hardware
    attr_accessor  :cpu_name, :cpu_speed, :cpu_count, :cpu_vendor, :cpu_cores,
                   :cpu_cache, :cpu_flags,
                   :mem_total, :mem_free, :swap_total, :swap_free

=begin
    # Get number of sockets detected
    def get_cpu_count
      return nil
    end

    # Get the cpu model name
    def get_cpu_name
      return nil
    end

    # Get cpu vendor_id or name
    def get_cpu_vendor
      return nil
    end

    # Get the cpu speed
    def get_cpu_speed
      return nil
    end

    # Get the cpu core count
    def get_cpu_cores
      return nil
    end

    # Get the cpu cache size
    def get_cpu_cache
      return nil
    end

    # Get the cpu flags
    def get_cpu_flags
      return nil
    end

    # Get total system memory
    def get_mem_total
      return nil
    end

    # Get free system memory
    def get_mem_free
      return nil
    end

    # get total swap area
    def get_swap_total
      return nil
    end

    # get free swap area
    def get_swap_free
      return nil
    end
=end

    # Probe returns a hash
    def probe
      return IonProbe::Hardware.new.collect
    end #/probe

    private
    # This method should not have an override in the chain
    def collect
      data = { :cpu_count       => self.get_cpu_count,
               :cpu_vendor      => self.get_cpu_vendor,
               :cpu_name        => self.get_cpu_name,
               :cpu_speed       => self.get_cpu_speed,
               :cpu_cores       => self.get_cpu_cores,
               :cpu_cache       => self.get_cpu_cache,
               :cpu_flags       => self.get_cpu_flags,
               :mem_total       => self.get_mem_total,
               :mem_free        => self.get_mem_free,
               :swap_total      => self.get_swap_total,
               :swap_free       => self.get_swap_free
      }

    end

    host_os = RbConfig::CONFIG['host_os'].downcase
    case host_os
      when /linux/
        require 'lib/ionprobe/linux'
      when /netbsd/
        require 'lib/ionprobe/netbsd'
      when /mswin/
        require 'lib/ionprobe/windows'
      when /darwin/
        require 'lib/ionprobe/darwin'
      else
        raise "HALT: Unrecognized host operating system."
        exit 1
    end


  end #/IonProbe::Hardware
  #---------------------------------------------------------------------------

  #---------------------------------------------------------------------------
  # Detects the networking of the machine
  class IonProbe::Network
    attr_accessor  :hostname, :iface_count, :iface_list,
                   :gateway_list, :gateway_default

=begin
    # Get fqdn hostname
    def get_hostname
      return nil
    end

    # Get a list of network interfaces
    def get_iface_list
      return nil
    end

    # Get a count of network interfaces
    def get_iface_count
      return nil
    end

    # Get a specific iface ip 4 address
    def get_iface_ip4address(iface)
      return nil
    end
    # Get a specific iface 4 netmask
    def get_iface_ip4netmask(iface)
      return nil
    end

    # Get a specific iface ip 6 address
    def get_iface_ip6address(iface)
      return nil
    end
    # Get a specific iface 6 netmask
    def get_iface_ip6netmask(iface)
      return nil
    end

    # Get a specific 'iface's mac address
    def get_iface_macaddress(iface)
      return nil
    end
=end

    # Returns a hash from collect
    def probe
      return IonProbe::Network.new.collect
    end #/probe

    private
    # This method should not have an override in the chain
    def collect
      data = { :hostname        => self.get_hostname,
               :iface_count     => self.get_iface_count,
               :iface_list      => self.get_iface_list
      }
    end

    host_os = RbConfig::CONFIG['host_os'].downcase
    case host_os
      when /linux/
        require 'lib/ionprobe/linux'
      when /netbsd/
        require 'lib/ionprobe/netbsd'
      when /mswin/
        require 'lib/ionprobe/windows'
      when /darwin/
        require 'lib/ionprobe/darwin'
      else
        raise "HALT: Unrecognized host operating system."
        exit 1
    end

  end #/Network


  end #/module
