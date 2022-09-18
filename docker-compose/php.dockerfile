FROM php:8-fpm-alpine

ENV PHPUSER=laravel
ENV PHPGROUP=laravel

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed  -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed  -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html
	
# RUN docker-php-ext-install zlib gd mbstring curl xml bcmath pdo pdo_mysql

ENTRYPOINT [ "php-fpm", "-y", "/usr/local/etc/php-fpm.d/www.conf", "-R" ]
