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

=begin rdoc
= MainController
The Main Menu master controller.
=end

# Main Controller Class
class MainController < IonController

  # Machine::populate - Creates a record in the database for the current host.
  def populate_machine
    Machine.create(:islocked     => false,
                #:uuid         => $UUID,
                :hostname     => IonMachine.detect_hostname,
                :arch         => IonMachine.detect_arch,
                :cpu_count    => IonMachine.detect_cpu_count,
                :cpu_vendor   => IonMachine.detect_cpu_vendor,
                :cpu_mhz      => IonMachine.detect_cpu_mhz,
                :cpu_model    => IonMachine.detect_cpu_model,
                :kernel       => IonMachine.detect_kernel_name,
                :kernel_version=> IonMachine.detect_kernel_version,
                :mem_total     => IonMachine.detect_mem_total,
                :mem_free      => IonMachine.detect_mem_free,
                :swap_total    => IonMachine.detect_swap_total,
                :swap_free     => IonMachine.detect_swap_free,
                :os_vendor     => IonMachine.detect_os_vendor,
                :os_version    => IonMachine.detect_os_version,
                :os_codename   => IonMachine.detect_os_codename,
                :os_description=> IonMachine.detect_os_description,
                :uptime       => IonMachine.uptime,
                :iface_list   => IonMachine.detect_iface_list.to_s,
                :iface_count  => IonMachine.detect_iface_count,
                :tcp_port     => CLIENT_TCP_PORT,
                :updated      => Time.now,
                :started      => Time.now)
  end

  def refresh_machine
    Machine.update(
        :hostname     => IonMachine.detect_hostname,
        :arch         => IonMachine.detect_arch,
        :cpu_count    => IonMachine.detect_cpu_count,
        :cpu_vendor    => IonMachine.detect_cpu_vendor,
        :cpu_mhz       => IonMachine.detect_cpu_mhz,
        :cpu_model     => IonMachine.detect_cpu_model,
        :kernel       => IonMachine.detect_kernel_name,
        :kernel_version    => IonMachine.detect_kernel_version,
        :mem_total     => IonMachine.detect_mem_total,
        :mem_free      => IonMachine.detect_mem_free,
        :swap_total    => IonMachine.detect_swap_total,
        :swap_free     => IonMachine.detect_swap_free,
        :os_vendor     => IonMachine.detect_os_vendor,
        :os_version    => IonMachine.detect_os_version,
        :os_codename   => IonMachine.detect_os_codename,
        :os_description=> IonMachine.detect_os_description,
        :iface_list   => IonMachine.detect_iface_list.to_s,
        :iface_count  => IonMachine.detect_iface_count,
        :uptime       => IonMachine.uptime,
        :tcp_port     => CLIENT_TCP_PORT,
        :updated      => Time.now
    )
  end

end