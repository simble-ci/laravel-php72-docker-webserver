FROM ubuntu:18.04

MAINTAINER "Tien Vo" <tienvv.it@gmail.com>

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN apt -q update \
    && apt install -y net-tools

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/jenkins

# Set user jenkins to the image
RUN groupadd -g 117 jenkins \
    && useradd -g 117 -u 112 -d /home/jenkins -s /bin/sh jenkins \
    && echo "jenkins:jenkins" | chpasswd

# Volume for cache
VOLUME /home/jenkins

# run install git, curl 
RUN apt install -y unzip git curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

# run install mysql-server
RUN apt install -y mysql-server redis-server

# run install php
RUN apt install -y php7.2-fpm php7.2-curl php7.2-gd php7.2-geoip \
    php7.2-imap php7.2-json php7.2-ldap php7.2-mcrypt php7.2-redis \
    php7.2-mbstring php7.2-xml php7.2-pdo php7.2-pdo-mysql php7.2-zip

# Configure PHP-FPM
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php/7.2/fpm/php.ini

# run install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create cache home
RUN mkdir -p "/home/jenkins" \
    && chown jenkins:jenkins "/home/jenkins" \
    && chmod 0777 "/home/jenkins"

ADD config/init-start.sh /init-start.sh
RUN chmod +x /init-start.sh
# Default command
ENTRYPOINT ["/init-start.sh"]
