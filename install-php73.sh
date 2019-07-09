#set -e

# verify install
#$ php -v

############################################################
## install & switch to php7 ##
#ref: https://tecadmin.net/install-php5-on-ubuntu/
############################################################
# install php7.3
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.3 #note: installs apache
service apache2 stop

# switch CLI to php7.3 (if multiple php versions installed)
sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3

# switch apache to php7.3 (if multiple php versions installed)
apt-get install libapache2-mod-php7.3
sudo a2dismod php5.6
sudo a2enmod php7.3
sudo service apache2 restart
############################################################


############################################################
## switch to php7 ##
#ref: https://tecadmin.net/switch-between-multiple-php-version-on-ubuntu/
############################################################
# switch to php7.3 (if multiple php versions installed)
sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set phar /usr/bin/phar7.3
sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
############################################################


############################################################
## install php7 apache lib ##
#ref: http://broncodev.com/2016-06-16-php5-in-ubuntu-16-04-lts/
############################################################
# enable php 5 for apache
apt-get install libapache2-mod-php7.3
a2enmod php7.3
############################################################



