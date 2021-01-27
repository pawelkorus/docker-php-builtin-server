ARG PHP_IMAGE=7.2-alpine
FROM php:${PHP_IMAGE}

ENV docroot="."

EXPOSE 8000

VOLUME [ "/root-dir" ]

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk --no-cache add --virtual .ext-deps libjpeg-turbo-dev libpng-dev \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .phpize-deps \
    && rm -rf /tmp/pear

COPY xdebug.ini $PHP_INI_DIR/conf.d/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD php -S 0.0.0.0:8000 -t $docroot
