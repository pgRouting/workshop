# -*- mode: ruby -*-
# vi: set ft=ruby :

pgbox    = ENV['BOX'] || "precise64"

# Make sure that we all use the same version of Vagrant
Vagrant.require_version ">= 1.5.0"

Vagrant.configure("2") do |config|

  # Vagrant box configuration
  config.vm.box = "hashicorp/%s" % [pgbox]

  # Bootstrap script
  config.vm.provision :shell, :path => "tools/vagrant/bootstrap.sh"

  # Forward SSH agent to host
  config.ssh.forward_agent = true

  # Create synced folder for GnuPG keys
  config.vm.synced_folder "~/.gnupg", "/home/vagrant/.gnupg"
  config.vm.synced_folder "../", "/home/vagrant/repos"

end
