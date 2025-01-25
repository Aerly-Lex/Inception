#!/bin/bash

#https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress

cd /var/www/html

rm -rf *

sleep 15

wp core download --allow-root

echo "DB_NAME: $DB_NAME, DB_USER: $DB_USER, DB_PASSWORD: $DB_PASSWORD, WP_URL: $WP_URL"

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Creating WP-Config manually
cp wp-config-sample.php wp-config.php
sed -i  "s/database_name_here/$DB_NAME/"   wp-config.php
sed -i  "s/username_here/$DB_USER/"  	wp-config.php
sed -i  "s/password_here/$DB_PASSWORD/"    wp-config.php
sed -i  "s/localhost/mariadb/"    wp-config.php

# Wait till MariaDB is ready
sleep 20

# Wordpress Installation

wp core install	--allow-root --url="$WP_URL" \
				--title="$WP_TITLE" \
				--admin_user="$WP_ADMIN_NAME" \
				--admin_password="$WP_ADMIN_PASSWORD" \
				--admin_email="$WP_ADMIN_EMAIL" \
				--skip-email

wp user create	$WP_USER_NAME $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root

echo "test3"

wp theme install astra --allow-root

echo "test4"
# Start PHP-FPM
php-fpm7.4 -F