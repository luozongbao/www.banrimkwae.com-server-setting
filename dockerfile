from php:8.3-fpm

run apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libmemcached-dev \
    zlib1g-dev
run docker-php-ext-configure gd --with-freetype --with-jpeg
run docker-php-ext-install -j$(nproc) \
    gd \
    pdo_mysql \
    mysqli \
    zip \
    xml \
    mbstring \
    curl \
    opcache

# Copy custom PHP configuration
COPY php.ini /usr/local/etc/php/php.ini

# Create log directory for PHP errors
RUN mkdir -p /var/log && touch /var/log/php_errors.log && chown www-data:www-data /var/log/php_errors.log

