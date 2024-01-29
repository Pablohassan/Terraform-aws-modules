#!/bin/bash
set -e

# Log file path
LOG_FILE="/var/log/wordpress-setup.log"

exec > >(tee -a ${LOG_FILE} 2>&1)

echo "Starting WordPress setup script"

# System Update and Apache Installation
sudo yum update -y
sudo yum install -y httpd

# PHP Installation
amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}

# ImageMagick Installation
if ! command -v convert >/dev/null; then
    sudo yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
    pecl install imagick
    chmod 755 /usr/lib64/php/modules/imagick.so
    echo "extension=imagick" >/etc/php.d/20-imagick.ini
    if systemctl is-active --quiet php-fpm.service; then
        systemctl restart php-fpm.service
    fi
fi

# Start Apache service if not already running
if ! systemctl is-active --quiet httpd; then
    systemctl start httpd
fi

# Set up WordPress if not already done
WP_DIR="/var/www/html"
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    # Change the owner and permissions of /var/www
    usermod -a -G apache ec2-user
    chown -R ec2-user:apache /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;

    # Download and set up WordPress
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* $WP_DIR/

    # Configure WordPress
    cd $WP_DIR
    cp wp-config-sample.php wp-config.php

    # Use environment variables for RDS database configuration
    sed -i "s/database_name_here/$DB_NAME/g" wp-config.php
    sed -i "s/username_here/$DB_USER/g" wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/g" wp-config.php
    sed -i "s/localhost/$DB_HOST/g" wp-config.php

    cat <<EOF >>wp-config.php
define('FS_METHOD', 'direct');
define('WP_MEMORY_LIMIT', '256M');
EOF

    # Modify permissions of /var/www/html/
    chown -R ec2-user:apache $WP_DIR
    chmod -R 774 $WP_DIR

    # Enable .htaccess files in Apache configuration
    sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

    # Restart Apache to apply changes
    systemctl restart httpd
fi

# Enable Apache to start on boot
systemctl enable httpd.service

echo "WordPress setup script completed successfully"