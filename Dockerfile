FROM php:5-apache

RUN set -xe && buildDeps=" \
        libmcrypt-dev \
        libgd-dev \
        libmagickwand-dev \
    " && \
    apt-get update && \
    apt-get install -y libmcrypt4 libgd3 libmagickwand-6.q16-2 --no-install-recommends && \
    apt-get install -y $buildDeps --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install pdo_mysql mysqli mcrypt gd opcache && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    a2enmod rewrite && service apache2 restart && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
