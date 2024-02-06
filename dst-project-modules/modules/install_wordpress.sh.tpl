#!/bin/bash

# Update system packages
yum update -y

# Install Apache
yum install -y httpd


# Enable PHP 7.4 from amazon-linux-extras and install it
amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}

# Install Imagick extension
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
echo "extension=imagick" > /etc/php.d/20-imagick.ini
systemctl restart php-fpm.service

# Start Apache
systemctl start httpd

# Change ownership and permissions of /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Configure WordPress

DB_NAME="${db_name}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_HOST="${db_host}"

cd /var/www/html
cp wp-config-sample.php wp-config.php

# Update WordPress configuration with RDS database details
sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
sed -i "s/username_here/$DB_USER/g" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
sed -i "s/localhost/$DB_HOST/g" wp-config.php

# Additional WordPress configurations
cat <<EOF >> wp-config.php
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Update permissions of /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 755 /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;

# Enable .htaccess files in Apache configuration
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

# Enable Apache to start on boot
systemctl enable httpd.service

systemctl restart httpd.service