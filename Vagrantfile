# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load local config:
require 'yaml'
config_file = File.dirname(__FILE__) + '/config.yml'
if not File.file?(config_file)
  raise Vagrant::Errors::VagrantError.new, 'You must create a config.yml file before using Vagrant.'
end
pubstack_config = YAML::load_file(config_file)

# If the synced folder option is specified, fix the documentroot option
# for every site.
if pubstack_config.include? 'synced_folder'
  # It doesn't make sense to specify both synced_folder and synced_folders,
  # and the path to the documentroot in the VM will break, so just bail
  # if both are specified for whatever reason.
  if pubstack_config.include? 'synced_folders'
    raise Vagrant::Errors::VagrantError.new, 'You may only use the synced_folder option if synced_folders is not specified. Please fix your config.yml and try again.'
  end

  pubstack_config['sites'].each {|site|
    site['vhost']['documentroot'] = '/var/www/html/' + site['vhost']['documentroot']
  }
  pubstack_config['shared_folders'] = [ { "map" => pubstack_config['synced_folder'], "to" => '/var/www/html'} ]
end

# Ensure that the new config dictionary exists.
if not pubstack_config.include? 'config'
  raise Vagrant::Errors::VagrantError.new, 'You must include the `config` key in your configuration. See config.example.yml for an examle.'
end

# Ensure Vagrant::Hostsupdater plugin is installed.
unless pubstack_config['hostupdater'] == false
  unless Vagrant.has_plugin?('vagrant-hostsupdater')
    raise Vagrant::Errors::VagrantError.new, 'The vagrant-hostsupdater plugin is not installed. Please run `vagrant plugin install vagrant-hostsupdater`.'
  end
end

# Set synced_folder_type to 'smb' only if Windows:
synced_folder_type = 'nfs'
require 'rbconfig'
if (RbConfig::CONFIG['host_os'] =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/)
  synced_folder_type = 'smb'
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'pubstack'

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Set up the config inside a block to allow for multiple-machines in
  # the future. This way the default box won't be lost when we update.
  config.vm.define 'dev' do |dev|
    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    dev.vm.network 'private_network', ip: '172.25.128.10'

    # Write host entries automagically with Vagrant::Hostsupdater.
    unless pubstack_config['hostupdater'] == false
      config.hostsupdater.aliases = ['pubstack.dev', 'xhprof.pubstack.dev']
      if pubstack_config['config']['splunk']
        config.hostsupdater.aliases.push('splunk.pubstack.dev')
      end
      if pubstack_config['config']['mailcatcher']
        config.hostsupdater.aliases.push('mail.pubstack.dev')
      end
      config.hostsupdater.aliases += pubstack_config['sites'].map {|site| site['vhost']['servername']}
    end

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    pubstack_config['shared_folders'].each do |folder|
      dev.vm.synced_folder folder['map'], folder['to'],
        type: synced_folder_type,
        mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=1']
    end

    # Provider-specific configuration for VirtualBox:
    dev.vm.provider 'virtualbox' do |vb|
      vb.customize ["modifyvm", :id, "--cpus", pubstack_config['cpus']]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--memory", pubstack_config['memory']]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Enable provisioning with Ansible.
    user_playbook = File.dirname(__FILE__) + '/provisioning/user.playbook.yml'
    dev.vm.provision 'ansible' do |ansible|
      ansible.playbook = File.file?(user_playbook) ? user_playbook : 'provisioning/pubstack.yml'
      ansible.extra_vars = {:sites => pubstack_config['sites'], :config => pubstack_config['config']}
    end
  end
end
