ARG PHP_IMAGE=7.2-alpine
FROM php:${PHP_IMAGE}

EXPOSE 8000

VOLUME [ "/root-dir" ]

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .phpize-deps \
    && rm -rf /tmp/pear

COPY xdebug.ini $PHP_INI_DIR/conf.d/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php", "-S", "0.0.0.0:8000"]
