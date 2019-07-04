
#!/bin/sh
#for i in 1 2 3 4 5
#do
#    echo "Looping ... number $i"
#done

f=/opt/bitnami/apps/wordpress/htdocs/wp-content/themes/green_997_right/archive/index_most\ recent.php
sed -i "s/=& new/= new/g" $f


find $PWD | grep 'art_normalize_widget_style_tokens'
##########################################
sed -i "s/=& new/= new/g" /opt/bitnami/apps/wordpress/htdocs/wp-content/themes/green_997_right/archive/index_most\ recent.php
dir=/opt/bitnami/apps/wordpress/htdocs/wp-content
FILES=`find $dir | grep '\.php$'`
for f in $FILES
do
    #echo "Processing $f"
    sed -i "s/=& new/= new/g" $f
done
echo "START find ..."
#find $dir -type f -name "functions.php" | xargs grep -liE 'art_normalize_widget_style_tokens'
find $dir -type f -name "*.php" | xargs grep -liE 'art_normalize_widget_style_tokens'
echo "END find ..."
##########################################

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

