# Vagrant-LAMP

Custom LAMP configuration with optional provisioning for WP

# Features

1) Uses Debian/Ubuntu Xenial 64-bit
2) Auto installs:
  a) PHP 7.2 with mbstring
  b) Apache 2
  c) Mysql
  d) Latest WP
  e) roots.io/sage (see custom.wp.sample.sh)
  f) postfix
  g) essentials (git, curl, unzip)

3) Local project folder mapping ./www => /var/www/html
4) Opcode caching enabled

# Installation

1) Requirements:
  a) Vagrant
  b) Git
  c) Virtual box


2. Clone and run `vagrant up`

Basic
```
> clone https://github.com/chrisbautista/vagrant-lamp.git my-project-name
> cd my-project-name
> mkdir www
> vagrant up
```


With Wordpress
```
> clone https://github.com/chrisbautista/vagrant-lamp.git my-project-name
> cd my-project-name
> mkdir www
> cat bin/custom.wp.sample.sh  > bin/custom.sh 
> vagrant up
```
NOTE: modify custom.sh to install roots.io/sage theme


# Roadmap
- Custom initial file www/index.html
- Drupal provisioning
- WP with React with Redux provisioning
- Laravel project provisioning

# Contributors
@codespud <chris@codespud.com>
