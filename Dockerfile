FROM ubuntu:18.04

MAINTAINER "Tien Vo" <tienvv.it@gmail.com>

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN apt-get -q update \
    && apt-get install -y net-tools

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/gitlab

RUN useradd -m gitlab && chsh -s /bin/bash gitlab

# Volume for cache
VOLUME /app

# run install unzip curl 
RUN apt-get install -y unzip curl supervisor nginx

# run install php
RUN apt-get install -y php7.2-fpm php7.2-curl php7.2-gd php7.2-geoip \
    php7.2-imap php7.2-json php7.2-ldap php7.2-redis \
    php7.2-mbstring php7.2-xml php7.2-pdo php7.2-pdo-mysql php7.2-zip

# Configure PHP-FPM
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php/7.2/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php/7.2/fpm/php.ini

# run install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl https://github.com/dshearer/jobber/releases/download/v1.4.0/jobber_1.4.0-1_amd64.deb -O -L \
    && dpkg -i jobber_1.4.0-1_amd64.deb \
    && update-rc.d jobber defaults

ADD config/nginx.conf /etc/nginx/nginx.conf
ADD config/laravel.conf /etc/nginx/sites-enabled/laravel.conf
RUN rm -f /etc/nginx/sites-enabled/default

RUN apt-get clean

EXPOSE 80

ADD config/init-start.sh /init-start.sh
RUN chmod +x /init-start.sh
# Default command
ENTRYPOINT ["/init-start.sh"]

