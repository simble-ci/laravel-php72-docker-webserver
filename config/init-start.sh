#!/bin/bash
export HOME=/home/jenkins
service mysql start
service redis-server start

mysql -uroot -e "CREATE USER 'ga'@'localhost' IDENTIFIED BY 'acresta';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'ga'@'localhost' WITH GRANT OPTION;"

while true; do sleep 1d; done
