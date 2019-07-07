
#!/bin/sh
#for i in 1 2 3 4 5
#do
#    echo "Looping ... number $i"
#done

echo "START find ..."
##############################################
## traverse through all dirs in current dir ##
#   - searching each file ending in ".php" for '<search-str>'
find $PWD -type f -name "*.php" | xargs grep -liE '<search-str>'

## use a specific dir (var '$dir') ##
#   - search each file named 'functions.php' for '<search-str>'
dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
find $dir -type f -name "functions.php" | xargs grep -liE '<search-str>'
##############################################
echo "END find ..."



echo "START sed ..."
##############################################
## find/change all text in .../recent.php ##
#   - from '=& new' to '= new'
sed -i "s/=& new/= new/g" /opt/bitnami/apps/wordpress/htdocs/wp-content/themes/green_997_right/archive/index_most\ recent.php

## set '.../recent.php' to var '$f' ##
f=/opt/bitnami/apps/wordpress/htdocs/wp-content/themes/green_997_right/archive/index_most\ recent.php
sed -i "s/=& new/= new/g" $f
##############################################
echo "END sed ..."



##############################################
## traverse through all files in dir '.../wp-content' ##
#   - store all files in var '$FILES'
#   - loop through all files and find/change text in each file
#       - from '=& new' to '= new'
dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
FILES=`find $dir | grep '\.php$'`
for f in $FILES
do
    #echo "Processing $f"
    sed -i "s/=& new/= new/g" $f
done
##############################################





find $PWD | grep 'art_normalize_widget_style_tokens'

FILES=`ls -R $dir | grep .php$`
for f in $FILES
do
    find $PWD | grep
    sed -i "s/=& new/= new/g" $f
done





#FILES="file1
#/path/to/file2
#/etc/resolv.conf"
#dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
#FILES="ls -R $dir | grep .php$"
dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
FILES=ls -R $dir | grep .php$
for f in $FILES
do
    echo "Processing $f"
done

ls -R /opt/bitnami/apps/wordpress/htdocs/wp-content | grep .php$

dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
ls -R $dir | grep .php$

for i in `ls`; do echo $i; done;

for i in `ls`
do
    echo $i
done

dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
for i in `ls -R $dir | grep .php$`
do
    echo $i
done

dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
FILES=`ls -R $dir | grep .php$`
for i in $FILES
do
    echo $i
done

