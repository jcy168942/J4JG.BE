#!/bin/bash

echo "Setting up MySQL master..."

# Wait for MySQL to fully start
until mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "select 1"; do
  echo "Waiting for MySQL master to start..."
  sleep 5
done

# Allow external connections
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Create replication user with mysql_native_password
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_REPLICATION_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_REPLICATION_PASSWORD}';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER}'@'%';"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Show master status for replication setup
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SHOW MASTER STATUS\G"

echo "MySQL master is running."
