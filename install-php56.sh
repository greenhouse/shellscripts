#set -e

# verify install
#$ php -v

############################################################
## install & switch to php5 ##
#ref: https://tecadmin.net/install-php5-on-ubuntu/
############################################################
# install php5.6
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php5.6 #note: installs apache
service apache2 stop

# switch CLI to php5.6 (if multiple php versions installed)
sudo update-alternatives --set php /usr/bin/php5.6
sudo update-alternatives --set phpize /usr/bin/phpize5.6
sudo update-alternatives --set php-config /usr/bin/php-config5.6

# switch apache to php5.6 (if multiple php versions installed)
apt-get install libapache2-mod-php5.6
sudo a2dismod php7.3
sudo a2enmod php5.6
sudo service apache2 restart
############################################################


############################################################
## switch to php5 ##
#ref: https://tecadmin.net/switch-between-multiple-php-version-on-ubuntu/
############################################################
# switch to php5.6 (if multiple php versions installed)
sudo update-alternatives --set php /usr/bin/php5.6
sudo update-alternatives --set phar /usr/bin/phar5.6
sudo update-alternatives --set phar.phar /usr/bin/phar.phar5.6
sudo update-alternatives --set phpize /usr/bin/phpize5.6
sudo update-alternatives --set php-config /usr/bin/php-config5.6
############################################################


############################################################
## install php5 apache lib ##
#ref: http://broncodev.com/2016-06-16-php5-in-ubuntu-16-04-lts/
############################################################
# enable php 5 for apache
apt-get install libapache2-mod-php5.6
a2enmod php5.6
############################################################


############################################################
## alternate install php 5.5 & 5.6 and all extensions ##
#ref: http://broncodev.com/2016-06-16-php5-in-ubuntu-16-04-lts/
############################################################
#$ apt-get install build-essential libaio1 php5.6-dev php-pear php5.6-soap php5.6-sybase php5.6-gd php5.6-xdebug php5.6-xml



############################################################
############################################################

