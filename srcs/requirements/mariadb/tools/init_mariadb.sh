#!/bin/sh

# Starting MariaDB
mysqld_safe & sleep 5

until mysqladmin ping &>/dev/null; do
	echo "wait for Mariadb"
	sleep 2
done

echo "Setting root password..."
mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PW}');"

# Check if database already exists
DB_EXISTS=$(mysql -u root -e "SHOW DATABASES LIKE '$DB_NAME';" | grep "$DB_NAME")


if [ "$DB_EXISTS" ]; then
	echo "Database '$DB_NAME' already exists, skipping creation."
else
	# Create Database and User
	echo "Creating database and user..."
	echo "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` ;" > db1.sql
	echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD' ;" >> db1.sql
	echo "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%' ;" >> db1.sql
	echo "FLUSH PRIVILEGES;" >> db1.sql
	mysql < db1.sql
	rm -f db1.sql
fi

echo "MariaDB setup complete."
wait