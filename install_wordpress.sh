#! /bin/bash


# INSTALLE AUTOMATIQUEMENT  WORDPRESS ET MARIADB SUR DES AMI LINUX 2


sudo yum update -y
sudo yum install -y httpd


# Active d'abord php7.xx depuis amazon-linux-extra et l'installe

amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}

# installe l'extension Imagick
sudo yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
systemctl restart php-fpm.service

systemctl start  httpd
# systemctl start mysqld

# Change le propriétaire et les autorisations du répertoire /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Télécharge le package wordpress et l'extrait
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

#rentre dans le repertoire wordpress
cd /var/www/html
cp wp-config-sample.php wp-config.php


# Utilise iciles variables d'environement pour la base de données RDS 

sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sed -i "s/username_here/$DB_USER/g" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
sed -i "s/localhost/$DB_HOST/g" wp-config.php

cat <<EOF >> wp-config.php
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF



# Modifie l'autorisation de /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#  active les fichiers .htaccess dans la configuration Apache à l'aide de la commande sed
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

systemctl restart httpd
systemctl enable  httpd.service

