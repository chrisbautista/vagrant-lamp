# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.


Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  
  # For windows only
  config.vm.synced_folder "./www/", "/var/www/html", :nfs => true 
  config.vm.synced_folder "./bin/", "/opt/bin", :nfs => true 

  # For non-windows
  #config.vm.synced_folder "./www/", "/var/www/html"
  #config.vm.synced_folder "./bin/", "/opt/bin"


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

update = <<SCRIPT

echo "================================================="
echo "= Upgrade Ubuntu                                ="
echo "================================================="

sudo apt-get update && sudo apt-get upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get install postfix -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install curl git unzip -y

SCRIPT

install_apache_php = <<SCRIPT

echo "================================================="
echo "= Install Apache and PHP                        ="
echo "================================================="

sudo apt-get install apache2 -y
sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf
sudo echo "EnableSendfile Off" >> /etc/apache2/apache2.conf

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update && sudo apt-get install php7.2 -y 
sudo a2enmod php7.2
sudo a2enmod rewrite

sudo pecl install apcu
sudo echo "extension=apcu.so" | tee -a /etc/php/7.2/mods-available/cache.ini

sudo service apache2 restart

SCRIPT

install_mysql = <<SCRIPT

echo "================================================="
echo "= Install mysql-server and php plugin           ="
echo "================================================="

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
sudo apt-get install php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml -y
sudo sed -i 's/skip-external-locking/#skip-external-locking/' /etc/mysql/my.cnf
sudo sed -i 's/bind-address 0.0.0.0/#bind-address 0.0.0.0/' /etc/mysql/my.cnf

echo "================================================="
echo "= Stop MySQL. Start up again  "
echo "================================================="
sudo service mysql restart

until mysqladmin -u root ping; do
  sleep 2
done

echo "================================================="
echo "= Create vagrant user with no pass for "
echo "= ease of use during ssh"
echo "================================================="

mysql -u root -e "CREATE USER 'user'@'%' IDENTIFIED BY 'password'; \
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' \
WITH GRANT OPTION; \
FLUSH PRIVILEGES; "

echo "================================================="
echo "= Start it up again, good as new. But better.   ="
echo "================================================="

service apache2 restart
service mysql restart

SCRIPT

cleanup = <<SCRIPT

echo ""
echo "================================================="
echo "= Provisioning is complete. Now the fun starts! ="
echo "================================================="
echo ""


SCRIPT


  shell = ''
  shell += update
  shell += install_apache_php
  shell += install_mysql
  shell += cleanup
  

config.vm.provision "shell" do |d|
  d.inline = shell
  d.binary = true
end 

# uncomment to run custom script
config.vm.provision "shell" do |s|
  s.path = "bin/custom.sh"
  s.binary = true
end

end
