#set -e

#ref: http://broncodev.com/2016-06-16-php5-in-ubuntu-16-04-lts/
# remove php 5 and 7
#apt-get purge `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`

# add repos php 5.5 & 5.6
add-apt-repository ppa:ondrej/php
apt-get update

# install php 5.5 & 5.6 and all extensions
apt-get install build-essential libaio1 php5.6-dev php-pear php5.6-soap php5.6-sybase php5.6-gd php5.6-xdebug php5.6-xml


# verify install
#$ php -v

# enable php 5 for apache
#$ apt-get install libapache2-mod-php5.6
#$ a2enmod php5.6
