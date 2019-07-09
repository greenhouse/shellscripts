#set -e

############################################################
## remove php5 & php7 ##
#ref: http://broncodev.com/2016-06-16-php5-in-ubuntu-16-04-lts/
############################################################
# remove php 5 and 7
apt-get purge `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`

