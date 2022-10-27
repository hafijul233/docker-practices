FROM ubuntu:22.04

USER root

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

MAINTAINER Hafijul Islam <hafijul233@gmail.com>

# set some environment variables
ENV APP_NAME laraedit
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN laraedit.com
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_VERSION "8.1"

# upgrade the container
RUN apt update && \
    apt upgrade -y

# install some prerequisites
RUN apt install -y \
    software-properties-common \
    curl \
    build-essential \
    dos2unix \
    gcc \
    vim \
    wget

# add some repositories
RUN apt-add-repository ppa:nginx/stable -y && \
    apt-add-repository ppa:ondrej/php -y

# set the locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale  && \
    locale-gen en_US.UTF-8  && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    
# setup bash
COPY .bash_aliases /root

# install nginx
RUN apt install -y --force-yes nginx
COPY homestead /etc/nginx/sites-available/

RUN rm -rf /etc/nginx/sites-available/default && \
    rm -rf /etc/nginx/sites-enabled/default && \
    ln -fs "/etc/nginx/sites-available/homestead" "/etc/nginx/sites-enabled/homestead" && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/ && \
    sed -i -e"s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf
VOLUME ["/var/www/html/app"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]

# install php
RUN apt install -y --force-yes php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-dev php${PHP_VERSION}-pgsql php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-gd \
    php-apcu php${PHP_VERSION}-curl php${PHP_VERSION}-mcrypt php${PHP_VERSION}-imap php${PHP_VERSION}-mysql php${PHP_VERSION}-readline php-xdebug php-common \
    php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml php${PHP_VERSION}-zip
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/${PHP_VERSION}/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/${PHP_VERSION}/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/${PHP_VERSION}/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/${PHP_VERSION}/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    find /etc/php/${PHP_VERSION}/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;
COPY fastcgi_params /etc/nginx/
RUN phpenmod mcrypt && \
    mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install mysql 
#RUN echo mysql-server mysql-server/root_password password $DB_PASS | debconf-set-selections;\
#    echo mysql-server mysql-server/root_password_again password $DB_PASS | debconf-set-selections;\
#    apt install -y mysql-server && \
#    echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf && \
#    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
#RUN /usr/sbin/mysqld & \
#    sleep 5s && \
#    echo "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret'; GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES; CREATE DATABASE homestead;" | mysql
#VOLUME ["/var/lib/mysql"]

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

#install laravel installer
RUN composer global require "laravel/installer"

# install supervisor
RUN apt install -y supervisor && \
    mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# clean up our mess
RUN apt remove --purge -y software-properties-common && \
    apt autoremove -y && \
    apt clean && \
    apt autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

# expose ports
EXPOSE 80 443 3306

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]
