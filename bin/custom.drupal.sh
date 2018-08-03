#!/usr/bin/env bash
set -e
######################################################################################################
# INSTALL Drupal 8
#   (can be used as vagrant provision script)
# 
# REQUIREMENTS
# - PHP 7.2 with mbstring
#   mysqld 
#   Apache with rewrite module enabled or Nginx 
# 
# Usage:
#  - ./custom.drupal.sh
# 
# Maintaned by: Code Spud <chris@codespud.com>
# Website: http://www.codespud.com
# License: GPL
######################################################################################################

# NOTE: PRE INSTALL LAMP

### UPDATE TO YOUR REQUIREMENTS
######################################################################################################
DOMAIN=http://localdev.test
DBUSER=user
DBPASSWORD=password
DBNAME=wordpress
ADMINUSER=adminuser
ADMINPASSWORD=password
ADMINEMAIL=test@test.com
LOCALDIR=/var/www/html
BASHUSER=vagrant


### DO NOT EDIT AFTER THIS LINE ####
########################################################################################################

# Install composer

echo ''
echo "= INSTALLING COMPOSER"
echo ''

cd /home/$BASHUSER

sudo curl -sS https://getcomposer.org/installer -o /home/$BASHUSER/composer-setup.php
sudo php /home/$BASHUSER/composer-setup.php --install-dir=/usr/local/bin --filename=composer -n
composer -V


# Install drush
echo ''
echo "= INSTALLING DRUSH"
echo ''

sudo wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar
sudo chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

# Install drupal

echo ''
echo "= INSTALLING DRUPAL"
echo ''

cd $LOCALDIR
composer create-project drupal-composer/drupal-project:8.x-dev /var/www/html --stability dev --no-interaction

