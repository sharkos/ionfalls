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
= IonMachine
Library probing machine information in IonFalls
=end

module IonMachine
  require 'lib/ionprobe'
  @ionos = IonProbe::OperatingSystem.new
  @ionhw = IonProbe::Hardware.new
  @ioniface = IonProbe::Network.new

  # Find out the Processor Type
  def IonMachine.detect_cpu_model
    @ionhw.get_cpu_name
  end

  # Find out the Processor Type
  def IonMachine.detect_cpu_vendor
    @ionhw.get_cpu_vendor
  end

  # Count available CPUs
  def IonMachine.detect_cpu_count
    @ionhw.get_cpu_count
  end

  # Detect CPU Speed
  def IonMachine.detect_cpu_mhz
    @ionhw.get_cpu_speed
  end

  # Detect Memory Size Total
  def IonMachine.detect_mem_total
    @ionhw.get_mem_total
  end

  # Detect Memory Available
  def IonMachine.detect_mem_free
    @ionhw.get_mem_free
  end

  # Detect Swap Size Total
  def IonMachine.detect_swap_total
    @ionhw.get_swap_total
  end

  # Detect Swap Size Total
  def IonMachine.detect_swap_free
    @ionhw.get_swap_free
  end

  # Get Uptime
  def IonMachine.uptime
    @ionos.get_uptime
  end

  # Get Platform Architecture
  def IonMachine.detect_arch
    @ionos.get_kernel_arch
  end

  # Get Vendor's Name
  def IonMachine.detect_os_vendor
    @ionos.get_os_vendor
  end

  # Get Vendor's Version
  def IonMachine.detect_os_version
    @ionos.get_os_version
  end

  # Get Vendor's Description
  def IonMachine.detect_os_description
    @ionos.get_os_description
  end

  # Get OS Code Name or Release Name
  def IonMachine.detect_os_codename
    @ionos.get_os_codename
  end

  # Detect running kernel name
  def IonMachine.detect_kernel_name
    @ionos.get_kernel_name
  end

  # Detect running kernel name
  def IonMachine.detect_kernel_version
    @ionos.get_kernel_version
  end

  # Get FQDN
  def IonMachine.detect_hostname
    #java.net.InetAddress.getLocalHost.getHostName
    @ioniface.get_hostname
  end

  # Get total number if Network Interfaces
  def IonMachine.detect_iface_count
    @ioniface.get_iface_count
  end

  # Get summary of network adapter named 'iface', returns Ruby Hash
  def IonMachine.detect_iface_list
    @ioniface.get_iface_list
  end

  # Use Summary to pull out Macaddress
  def IonMachine.detect_iface_macaddress(iface)
    puts "Detecting Macadress of #{iface}"
    @ioniface.get_iface_macaddress(iface)
  end

end
