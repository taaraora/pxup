# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require 'yaml'

if File.file?('global_vars.yml') then
  vagrant_variable_filename='global_vars.yml'
else
  vagrant_variable_filename='global_vars.yml.sample'
end

config_file=File.expand_path(File.join(File.dirname(__FILE__), vagrant_variable_filename))

settings=YAML.load_file(config_file)

CACHE = settings['cache']
PREFIX = settings['prefix']
NODES = settings['nodes']
DISKS = settings['disks']
DISK_SIZE = settings['disk_size']
MEMORY = settings['memory']
CPUS = settings['cpus']
NET_PREFIX = settings['private_network_prefix']
PLAYBOOK = settings['playbook']

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box = "taaraora/centos7"
	config.vm.synced_folder '.', '/vagrant', disabled: true

    # Override
    config.vm.provider :libvirt do |v,override|
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end

    # Make the glusterfs cluster, each with DISKS number of drives
    driveLetters = ('b'..'z').to_a
    (0..NODES-1).each do |i|
        config.vm.define "#{PREFIX}-node#{i}" do |node|
            node.vm.hostname = "#{PREFIX}-node#{i}"
            node.vm.network :private_network, ip: "#{NET_PREFIX}#{i}"

            (0..DISKS-1).each do |discOrdinal|
                node.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{driveLetters[discOrdinal]}", :path => "#{PREFIX}-disk-#{i}-#{discOrdinal}.disk", :size => DISK_SIZE
                    lv.memory = MEMORY
                    lv.cpus = CPUS
                end
            end

            if CACHE
                node.vm.provider :libvirt do  |lv|
                    latestDriveOrdinal = DISKS
                    lv.storage :file, :device => "vd#{driveLetters[latestDriveOrdinal]}", :path => "#{PREFIX}-#{i}-disk-cache-#{latestDriveOrdinal}.disk", :size => DISK_SIZE
                end
            end

            if i == (NODES-1)
                # View the documentation for the provider you're using for more
                # information on available options.
                node.vm.provision :ansible do |ansible|
                    ansible.limit = "all"
                    ansible.playbook = PLAYBOOK
                    ansible.groups = {
                        "nodes" => (0..NODES-1).map {|j| "#{PREFIX}-node#{j}"},
                    }
                end
            end
        end
    end
end
