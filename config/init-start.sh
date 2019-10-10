#!/bin/bash
export HOME=/home/gitlab

service supervisord start
service nginx start
service php7.2-fpm start
service jobber start

while true; do sleep 1d; done
