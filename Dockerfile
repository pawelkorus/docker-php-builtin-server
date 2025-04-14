ARG PHP_VERSION="8.1"

FROM php:${PHP_VERSION}-alpine as base

RUN set -eux && apk update --no-cache


FROM base as build

# See https://github.com/joseluisq/alpine-php-fpm/tree/master/8.1-fpm

# Install build dependencies
RUN set -eux \
    && apk add --no-cache --update --virtual .build-deps $PHPIZE_DEPS \
        linux-headers \     
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


FROM base as target

ENV DOCUMENT_ROOT="."

EXPOSE 80

VOLUME [ "/root-dir" ]

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=build /usr/local/lib/php/extensions/* /usr/local/lib/php/extensions
COPY --from=build /usr/local/etc/php/conf.d/* /usr/local/lib/php/conf.d

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD php -S 0.0.0.0:80 -t $DOCUMENT_ROOT
