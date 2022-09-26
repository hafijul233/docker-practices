FROM nginx:stable-alpine

ENV NGINXUSER=hafijul233
ENV NGINXGROUP=hafijul233

RUN mkdir -p /var/www/html

ADD server/default.conf /etc/nginx/conf.d/default.conf
ADD server/production.test.pem /etc/nginx/certs/production.test.pem
ADD server/production.test-key.pem /etc/nginx/certs/production.test-key.pem

RUN sed -i "s/user www-data/user ${NGINXUSER}/g" etc/nginx/nginx.conf

RUN adduser -g ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}
