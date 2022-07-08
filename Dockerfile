FROM php:8.0.13-apache

# extension
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libmagickwand-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libzip-dev \
        libonig-dev \
        libssl-dev \
        jpegoptim \
        optipng \
        gifsicle \
        sendmail \
        git-core \
        build-essential \
        openssl \
        python2.7 \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable mysqli \
    && pecl install imagick \
        imagick \
        apcu \
        redis \
        # xdebug \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable redis \
    # && docker-php-ext-enable xdebug \
    && ln -s /usr/bin/python2.7 /usr/bin/python \
    && a2enmod headers \
    && a2enmod mime \
    && a2enmod expires \
    && a2enmod deflate

# composer
RUN curl -S https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update

# node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && . $NVM_DIR/nvm.sh \
    && nvm install v14.16.0 \
    && nvm use v14.16.0 \
    && nvm alias default v14.16.0 \
    && npm install -g npm@7.24.0

# php.ini
COPY config/php.ini /usr/local/etc/php/

# apache
RUN a2enmod rewrite
RUN a2enmod ssl

COPY entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]