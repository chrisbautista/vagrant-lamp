#!/usr/bin/env bash
set -e

echo "================================================="
echo "= install wordpress 1                            ="
echo "================================================="

DOMAIN=http://localdev.test
DBUSER=user
DBPASSWORD=password
DBNAME=wordpress
ADMINUSER=adminuser
ADMINPASSWORD=password
ADMINEMAIL=test@test.com
LOCALDIR=/var/www/html
BASHUSER=vagrant


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

sudo chown -Rf $BASHUSER:www-data $LOCALDIR
sudo usermod -aG www-data $BASHUSER
sudo chmod -Rf g+w $LOCALDIR

echo ""
echo "DONE INSTALLING WORDPRESS"
echo ""

##
## OPTIONAL
## INSTALL roots.io/sage
##
## INSTALL_SAGE=yes or no

INSTALL_SAGE=no
THEME_NAME=westmar

if [ $INSTALL_SAGE = "yes" ]; then
echo '====================='
echo " INSTALLING SAGE"
echo '====================='
echo 

cd $LOCALDIR/wp-content/themes
sudo rm -Rf $LOCALDIR/wp-content/themes/*


fi