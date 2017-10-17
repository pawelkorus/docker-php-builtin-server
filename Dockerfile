FROM php:7.1-alpine

EXPOSE 8000

VOLUME [ "/root-dir" ]

ENTRYPOINT ["entrypoint.sh"]
CMD ["-S", "0.0.0.0:8000"]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apk add --no-cache su-exec

