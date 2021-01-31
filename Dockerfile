ARG PHP_IMAGE=7.4-alpine
FROM php:${PHP_IMAGE}

ENV docroot="."

EXPOSE 8000

VOLUME [ "/root-dir" ]

# see https://github.com/php/php-src/blob/PHP-7.4/UPGRADING#L766-L775
# with PHP-7.4+ "docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/"
# has changed to "docker-php-ext-configure gd --with-freetype --with-jpeg"

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk --no-cache add --virtual .ext-deps freetype-dev libjpeg-turbo-dev libpng-dev icu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql intl \
    && pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .phpize-deps \
    && rm -rf /tmp/pear

COPY xdebug.ini $PHP_INI_DIR/conf.d/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD php -S 0.0.0.0:8000 -t $docroot
