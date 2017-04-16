FROM php:5-apache

RUN set -xe && a2enmod rewrite && service apache2 restart

RUN set -xe && \
    commonDeps=" \
        libmcrypt-dev \
    " && \
    apt-get update && \
    apt-get install -y libmcrypt4 --no-install-recommends && \
    apt-get install -y $commonDeps --no-install-recommends && \
    docker-php-ext-install pdo_mysql mysqli mcrypt opcache && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $commonDeps

RUN set -xe && imagickDeps=" \
        libgd-dev \
        libmagickwand-dev \
    " && \
    apt-get update && \
    apt-get install -y libgd3 libmagickwand-6.q16-2 --no-install-recommends && \
    apt-get install -y $imagickDeps --no-install-recommends && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $imagickDeps

RUN set -xe && \
    mongoDeps=" \
            libcurl4-openssl-dev \
            pkg-config \
            libssl-dev \
        " && \
    apt-get update && \
    apt-get install -y $mongoDeps --no-install-recommends && \
    pecl install mongodb && \
    docker-php-ext-enable mongodb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $mongoDeps
