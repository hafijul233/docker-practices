FROM php:8.1-fpm-alpine3.16

ENV PHPGROUP=hafijul233
ENV PHPUSER=hafijul233

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

RUN docker-php-ext-install pdo pdo_mysql opcache

ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini

CMD [ "php-fpm", "-y", "/usr/local/etc/php-fpm.d/www.conf", "-R" ]