#!/bin/bash
export HOME=/home/jenkins
service mysql start
service redis-server start
mysql -u root -e "use mysql;update user set authentication_string=password('1111') where user='root'"

while true; do sleep 1d; done
