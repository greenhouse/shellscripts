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
#    $ nginx -s reload

## navigate/test ...
#    http://server_domain_or_IP/info.php



############################################################
## include wordpress support
#    ref: https://wordpress.org/support/article/how-to-install-wordpress/
#   download & install wordpress; update nginx.conf
#
## note: get Wordpress release version link from:
#    https://wordpress.org/download/releases/
############################################################

## download/install wordpress native
mkdir /srv/www
cd /srv/www
wget https://wordpress.org/wordpress-4.8.9.tar.gz
tar -xzvf wordpress-4.8.9.tar.gz
cd wordpress
mv wp-config-sample.php wp-config.php

## create mysql Wordpress database user & database
#    $ mysql -uroot -p
#    mysql> create database wordpress;
#    mysql> CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';
#    mysql> GRANT ALL PRIVILEGES ON *.* TO 'wp_user'@'localhost';
#    mysql> FLUSH PRIVILEGES;

## restart MySQL daemon after config changes
#    $ sudo systemctl restart mysql.service

## update wp-config.php (using the above database)
#    // ** MySQL settings - You can get this info from your web host ** //
#    /** The name of the database for WordPress */
#    define('DB_NAME', 'wordpress');
#
#    /** MySQL database username */
#    define('DB_USER', 'wp_user');
#
#    /** MySQL database password */
#    define('DB_PASSWORD', 'password');
#
#    /** MySQL hostname */
#    define('DB_HOST', 'localhost');

## update nginx.conf with the following... (disable /etc/nginx/sites-enabled/default)
#    ########################################
#    ## Wordpress standard / initial install
#    #ref: https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/
#    ########################################
#
#    # Upstream to abstract backend connection(s) for php
#    #upstream php {
#    #server unix:/tmp/php-cgi.socket;
#    #server 127.0.0.1:9000;
#    #}
#
#    server {
#        ## Your website name goes here.
#        #server_name domain.tld;
#        ## Your only path reference.
#        root /srv/www/wordpress;
#        ## This should be in your http block and if it is, it's not needed here.
#        index index.php;
#
#        location = /favicon.ico {
#            log_not_found off;
#            access_log off;
#        }
#
#        location = /robots.txt {
#            allow all;
#            log_not_found off;
#            access_log off;
#        }
#
#        location / {
#            # This is cool because no php is touched for static content.
#            # include the "?$args" part so non-default permalinks doesn't break when using query string
#            try_files $uri $uri/ /index.php?$args;
#        }
#
#        location ~ \.php$ {
#            #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
#            #include fastcgi.conf;
#            include snippets/fastcgi-php.conf;
#            fastcgi_intercept_errors on;
#            #fastcgi_pass php;
#            fastcgi_pass unix:/run/php/php5.6-fpm.sock;
#        }
#
#        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
#            expires max;
#            log_not_found off;
#        }
#    }
#    ########################################
#    ########################################

############################################################
############################################################

