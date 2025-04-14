ARG PHP_IMAGE=8.1-alpine
FROM php:${PHP_IMAGE}

ENV DOCUMENT_ROOT="."

EXPOSE 8000

VOLUME [ "/root-dir" ]

# See https://github.com/joseluisq/alpine-php-fpm/tree/master/8.1-fpm

# Install build dependencies
RUN set -eux \
    && apk add --no-cache --update linux-headers --virtual .build-deps $PHPIZE_DEPS \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        icu-dev \
        libxpm-dev \
    && true

# Install PHP extensions
RUN set -eux \
    \
    # Install gd
    && ln -s /usr/lib/$(apk --print-arch)-linux-gnu/libXpm.* /usr/lib/ \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
    && docker-php-ext-install -j$(nproc) gd \
    \
    # Install intl
    && docker-php-ext-install -j$(nproc) intl \
    \
    # Install mysqli
    && docker-php-ext-install -j$(nproc) mysqli \
    \
    # Install pdo
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    \
    # Install xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    \
    # Clean up build dependencies
    && docker-php-source delete \
    && apk del .build-deps \
    && rm -rf /tmp/* \
    && true

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD php -S 0.0.0.0:8000 -t $DOCUMENT_ROOT
