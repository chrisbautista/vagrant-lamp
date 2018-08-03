#!/usr/bin/env bash
set -e
######################################################################################################
# INSTALL WP with optional Sage starter theme
#   (can be used as vagrant provision script)
# 
# REQUIREMENTS
# - PHP 7.2 with mbstring
#   mysqld 
#   Apache with rewrite module enabled or Nginx 
# 
# Usage:
#  - ./custom.wp.sh
# 
# Maintaned by: Code Spud <chris@codespud.com>
# Website: http://www.codespud.com
# License: GPL
######################################################################################################

echo "================================================="
echo "= install wordpress 1                            ="
echo "================================================="


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

if [ ! -z "wp-cli.phar" ]; then
    sudo wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    sudo chmod +x wp-cli.phar
fi
test -z "/usr/local/bin/wp" && sudo rm /usr/local/bin/wp -y
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp --info

cd /home/$BASHUSER
wget https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
test -z "/home/$BASHUSER/wp-completion.bash" && sudo rm /home/$BASHUSER/wp-completion.bash -y
source /home/$BASHUSER/wp-completion.bash
source ~/.bashrc

`mysql -u root -e "drop database IF EXISTS $DBNAME; create database $DBNAME; \
grant all on $DBNAME.* to '$DBUSER' identified by '$DBPASSWORD'; \
FLUSH PRIVILEGES;" `

## WP CLI

cd $LOCALDIR
echo '====================='
echo "CWD `pwd` "
echo '====================='


sudo -u $BASHUSER -i -- wp core download --path=$LOCALDIR || echo "Already exists"
sudo -u $BASHUSER -i -- wp core config --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASSWORD --dbhost=localhost --dbprefix=wp_ --path=$LOCALDIR || echo "wp config error"
sudo -u $BASHUSER -i -- wp core install --url="$DOMAIN" --title="Blog Title" --admin_user="$ADMINUSER" --admin_password="$ADMINPASSWORD" --admin_email="$ADMINEMAIL"   --path=$LOCALDIR || echo "error installing wp"

sudo usermod -aG www-data $BASHUSER
sudo chown -Rf $BASHUSER:www-data $LOCALDIR
sudo chmod -Rf g+w $LOCALDIR

# activate pretty permalinks
sudo -u $BASHUSER -i -- wp rewrite structure '/%postname%'
sudo -u $BASHUSER -i -- wp rewrite flush


echo ""
echo "DONE INSTALLING WORDPRESS"
echo ""

###############################################################
## OPTIONAL
## INSTALL roots.io/sage
##
## INSTALL_SAGE=yes or no
###############################################################

INSTALL_SAGE=yes # no
THEME_NAME=westmar

if [ $INSTALL_SAGE = "yes" ]; then
echo '====================='
echo " INSTALLING REQUISITES"
echo '====================='

echo ''
echo "= INSTALLING COMPOSER"
echo ''

cd /home/$BASHUSER

sudo curl -sS https://getcomposer.org/installer -o /home/$BASHUSER/composer-setup.php
sudo php /home/$BASHUSER/composer-setup.php --install-dir=/usr/local/bin --filename=composer -n
sudo composer -V

echo ''
echo "= INSTALLING NODEJS"
echo ''

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

echo ''
echo "= INSTALLING YARN"
echo ''

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

echo '====================='
echo " INSTALLING SAGE"
echo '====================='

cd $LOCALDIR/wp-content/themes

# delete all themes
# sudo rm -Rf $LOCALDIR/wp-content/themes/*

composer create-project roots/sage $THEME_NAME
cd $LOCALDIR/wp-content/themes/$THEME_NAME

echo '======================================================'
echo '#                                                     #'
echo "#     1) run 'yarn' on host machine (not vagrant)     #"
echo "#     2) login to wp-admin and activate sage theme    #"
echo '#                                                     #'
echo '======================================================'

fi