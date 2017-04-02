FROM php:7-apache
EXPOSE 80
# Install deps
RUN apt-get update && apt-get install -y \
        libcurl4-gnutls-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libssh2-1 \
        libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*
# Install core extensions
RUN docker-php-ext-install -j$(nproc) \
        curl \
        mbstring \
        mcrypt \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
# Install PECL extensions
RUN pecl install \
        apcu \
        ssh2-1.0 \
    && docker-php-ext-enable \
        apcu.so \
        ssh2
# Enable Apache modules
RUN a2enmod rewrite