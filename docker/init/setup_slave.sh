#!/bin/bash

echo "Waiting for MySQL master to start..."
sleep 30s

echo "Setting up MySQL slave..."

# Wait for MySQL master to be available
until mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql-master -e "select 1"; do
  echo "Waiting for MySQL master to be available..."
  sleep 5
done

# Get master status
MASTER_LOG_FILE=$(mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql-master -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}')
MASTER_LOG_POS=$(mysql -u root -p${MYSQL_ROOT_PASSWORD} -h mysql-master -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}')

# Configure the slave
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='${MYSQL_REPLICATION_USER}', MASTER_PASSWORD='${MYSQL_REPLICATION_PASSWORD}', MASTER_LOG_FILE='${MASTER_LOG_FILE}', MASTER_LOG_POS=${MASTER_LOG_POS};"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "START SLAVE;"

echo "MySQL slave is running."
