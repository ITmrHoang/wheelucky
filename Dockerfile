FROM alpine:3.15
LABEL Maintainer="Hoang <itmrhoang@gmail.com>"
LABEL Description="Lightweight container with Nginx 1.20 & PHP 8.0 & laravel & sqlite based on Alpine Linux."

ARG user=himodevvn
ARG uid=1000
# Setup document root
WORKDIR /var/www/html

RUN apk update && apk upgrade

# Install packages and remove default server definition
RUN apk add --no-cache \
  sqlite \
  curl \
  nginx \
  git \
  vim \
  php7 \
  php7-ctype \
  php7-curl \
  php7-json \
  php7-dom \
  php7-fpm \
  php7-gd \
  php7-intl \
  php7-mbstring \
  php7-mysqli \
  php7-opcache \
  php7-openssl \
  php7-phar \
  php7-session \
  php7-xml \
  php7-xls \
  php7-xmlreader \
  php7-zlib \
  php7-sqlite3 \
  supervisor

# Create symlink so programs depending on `php` still function
#RUN ln -s /usr/bin/php7 /usr/bin/php


#install composer 
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
COPY --chown=nobody source/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 8080 8000

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
