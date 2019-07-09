#set -e

# verify install
#$ php -v

############################################################
## install nginx, mysql, php5.6
#ref: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04
############################################################
## install nginx
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get install nginx

## install mysql
sudo apt install mysql-server

## install php5.6 w/ mysql support
sudo apt-get install php5.6-fpm php5.6-mysql

## create default .php test page
sudo emacs /var/www/html/info.php

## add/save to /var/www/html/info.php ...
#    <?php
#    phpinfo();


## add to nginx.confg (default example in /etc/nginx/sites-enabled/default
#    server {
#        index index.php
#        location ~ \.php$ {
#            include snippets/fastcgi-php.conf;
#            fastcgi_pass unix:/run/php/php5.6-fpm.sock;
#        }
#
#        location ~ /\.ht {
#            deny all;
#        }
#    }

## reset nginx
#$ nginx -s reload

## navigate/test ...
#    http://server_domain_or_IP/info.php


############################################################
############################################################

