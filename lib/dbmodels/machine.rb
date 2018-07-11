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

# Machine Migrations
class AddMachines < ActiveRecord::Migration
    def self.up
      create_table :machines do |t|
        t.string      :hostname, :null => false
        t.string      :arch
        t.integer     :cpu_count
        t.string      :cpu_vendor
        t.string      :cpu_mhz
        t.string      :cpu_model
        t.string      :kernel
        t.string      :kernel_version
        t.integer     :mem_total
        t.integer     :mem_free
        t.integer     :swap_total
        t.integer     :swap_free
        t.string      :os_vendor
        t.string      :os_version
        t.string      :os_codename
        t.string      :os_description
        t.boolean     :islocked
        t.string      :uptime
        t.integer     :iface_count
        t.text        :iface_list
        t.integer     :tcp_port
        t.timestamp   :updated
        t.timestamp   :started
      end

    end

    def self.down
      drop_table :machines
    end

    # Create sample rows for testing
    def self.sample
      Machine.create(hostname:  'ionsample',
          arch: 'ARMv7',
          cpu_count: 1,
          cpu_vendor: 'Texas Instruments',
          cpu_mhz: '900',
          cpu_model: 'OMAP4',
          kernel: 'Linux',
          kernel_version: '3.0.1-LeafScale',
          mem_total: 2044096,
          mem_free: 1000231,
          swap_total: 1020019,
          swap_free: 1020019,
          os_vendor: 'LeafScale, Inc.',
          os_version: '20130901',
          os_codename: 'IonCore',
          os_description: 'IonFalls CORE v20130901',
          islocked: false,
          uptime: '16:18:21 up 3 days,  6:24,  4 users,  load average: 0.30, 0.43, 0.37',
          iface_count: 0,
          iface_list: '',
          tcp_port: 9000,
          updated: Time.now,
          started: Time.now)
    end

end #/class AddMachines


class Machine < ActiveRecord::Base
  unless self.table_exists? then
    AddMachines.new.up
  end
end #/class Machine






=begin
class Machine < Sequel::Model(:machine)
  Machine.plugin :json_serializer
  #Machine.plugin :xml_serializer

  IonIO.printstart " DB Model: machine"
  set_schema do
    primary_key  :id
    #String       :uuid
    String       :hostname
    String       :arch
    Smallint     :cpu_count
    String       :cpu_vendor
    String       :cpu_mhz
    String       :cpu_model
    String       :kernel
    String       :kernel_version
    BigInt       :mem_total
    BigInt       :mem_free
    BigInt       :swap_total
    BigInt       :swap_free
    String       :os_vendor
    String       :os_version
    String       :os_codename
    String       :os_description
    boolean      :islocked
    String       :uptime
    Smallint     :iface_count
    text         :iface_list
    Int          :tcp_port
    TimeStamp    :updated
    TimeStamp    :started
  end

  create_table unless table_exists?

  def Machine.populate
    create  :islocked     => false,
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
            :started      => Time.now
  end

  def Machine.refresh
    self.update(
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


  if empty?
    self.populate
  end
end
=end
