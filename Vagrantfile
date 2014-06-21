# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load local config:
require "yaml"
config_file = File.dirname(__FILE__) + "/config.yml";
if not File.file?(config_file)
  raise 'You must create a config.yml file before using Vagrant.'
end
pubstack_config = YAML::load_file(config_file)

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "pubstack"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Provider-specific configuration for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", pubstack_config["virtualbox"]["memory"]]
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  #if not pubstack_config["vagrant"]["synced_folder"].nil?
  #  config.vm.synced_folder pubstack_config["vagrant"]["synced_folder"], "/var/www/html"
  #end

  # Assume a single machine stack if not configured.
  #if pubstack_config["virtualbox"]["port-forwarding"].nil?
  #  pubstack_config["ansible"]["stack-size"] = "single"
  #end

  # Provision a single machine.
  if pubstack_config["ansible"]["stack-size"] == "single"

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine.
    # If you want to forward ports just follow the example in default.config.yml
    if not pubstack_config["virtualbox"]["port-forwarding"].nil?
      pubstack_config["virtualbox"]["port-forwarding"].each do |type, data|
        config.vm.network "forwarded_port", guest: data['guest'], host: data['host']
      end
    end

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    config.vm.network "private_network", ip: "192.168.33.10"

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true

    # Enable provisioning with Ansible.
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/single-machine-pubstack.yml"
      ansible.extra_vars = pubstack_config["ansible"]
    end

  # Determine which kinds of machines and how many will be provisioned.
  else

    virtual_machines = {}

    if pubstack_config["ansible"]["stack-size"] == "small"

      virtual_machines["db"] = 1;
      virtual_machines["web"] = 1;

    elseif pubstack_config["ansible"]["stack-size"] == "medium"

      virtual_machines["db"] = 1;
      virtual_machines["web"] = 2;
      virtual_machines["varnish"] = 1;

    elseif pubstack_config["ansible"]["stack-size"] == "large"

      virtual_machines["db"] = 2;
      virtual_machines["slave_db"] = 1;
      virtual_machines["web"] = 2;
      virtual_machines["varnish"] = 2;
      virtual_machines["load"] = 1;

    # @todo elseif pubstack_config["ansible"]["stack-size"] == "mega"

    # @todo elseif pubstack_config["ansible"]["stack-size"] == "custom"

    end

  end

  if virtual_machines["db"] == 1
    config.vm.define "db1" do |db1|
      db1.vm.hostname = 'db1'
      db1.vm.network "private_network", ip: "192.168.33.10"
      db1.vm.provision "ansible" do |ansible|
        ansible.extra_vars = { ansible_ssh_user: 'vagrant', server_ip_address: '192.168.33.10' }
        ansible.playbook = "provisioning/single-db.playbook.yml"
        ansible.limit = 'db1'
        # ansible.verbose = 'vvv'
      end
    end
  end

  if virtual_machines["web"] == 1
    config.vm.define "web1" do |web1|
      web1.vm.hostname = 'web1'
      web1.vm.network "private_network", ip: "192.168.33.20"
      #if not pubstack_config["virtualbox"]["port-forwarding"]["http"].nil?
      #  web1.vm.network "forwarded_port", guest: 80, host: pubstack_config["virtualbox"]["port-forwarding"]["http"]["host"]
      #else
        web1.vm.network "forwarded_port", guest: 80, host: 8800
      #end
      web1.vm.provision "ansible" do |ansible|
        ansible.extra_vars = { ansible_ssh_user: 'vagrant', server_ip_address: '192.168.33.20' }
        ansible.playbook = "provisioning/web.playbook.yml"
        ansible.limit = 'web1'
        # ansible.verbose = 'vvv'
      end
    end
  end

  if virtual_machines["varnish"] = 1
    config.vm.define "varnish1" do |varnish1|
      varnish1.vm.hostname = 'varnish1'
      varnish1.vm.network "private_network", ip: "192.168.33.30"
      #if not pubstack_config["virtualbox"]["port-forwarding"]["varnish"].nil?
      #  web1.vm.network "forwarded_port", guest: 6081, host: pubstack_config["virtualbox"]["port-forwarding"]["http"]["varnish"]
      #else
        web1.vm.network "forwarded_port", guest: 6081, host: 8900
      #end
      varnish1.vm.provision "ansible" do |ansible|
        ansible.extra_vars = { ansible_ssh_user: 'vagrant', server_ip_address: '192.168.33.30' }
        ansible.playbook = "provisioning/varnish.playbook.yml"
        ansible.limit = 'varnish1'
        ansible.verbose = 'vvv'
      end
    end
  end

end

















