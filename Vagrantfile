# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # config.vm.define "ubuntu" do |ubuntu|
  #   ubuntu.vm.box = "phusion/ubuntu-14.04-amd64"
  #   ubuntu.vm.provision :shell, path: "tests/data/provisioning/vagrant-ubuntu.sh"
  #   ubuntu.vm.network :private_network, type: :static, ip: "192.168.50.240"
  # end

  config.vm.define "centos" do |centos|
    # Vagrant download box is brutally slow, you should download the .box file separately via curl/wget.
    centos.vm.box = "metcalfc/centos70-docker"
    centos.vm.box_url = "./virtualbox.box"

    centos.vm.provision :shell, path: "installers/centos7.sh"
    centos.vm.network :private_network, type: :static, ip: "192.168.50.241"
  end

  config.ssh.insert_key = 'true'

  config.ssh.forward_agent = true

  config.vm.synced_folder ENV['GOPATH'], "/go"
  config.vm.synced_folder ENV['HOME'] + '/projects/oss/didip/mcrouter-util', "/mcrouter-util"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
end
