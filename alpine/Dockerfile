FROM alpine:latest

USER root

# set some environment variables
ENV APP_NAME laraedit
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN laraedit.com
ENV DEBIAN_FRONTEND noninteractive
ENV PHP_VERSION "8"

#install
RUN apk --update --no-cache add wget \
  curl grep build-base libmcrypt-dev \
  libxml2-dev imagemagick-dev pcre-dev \
  libtool make autoconf g++ dos2unix \
  cyrus-sasl-dev libgsasl-dev supervisor \
  nginx mysql-client vim php 
#   php8-cli \
#   php8-common php8-mysql php8-zip \
#   php8-gd php8-mbstring php8-curl \
#   php8-xml php8-bcmath php8-intl

#nginx

RUN php -v

RUN php -m

RUN mkdir -p /var/www/html

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
EXPOSE 80 443 3306
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
