#!/bin/bash
export HOME=/home/jenkins
service mysql start
service redis-server start
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';FLUSH PRIVILEGES;"

while true; do sleep 1d; done
