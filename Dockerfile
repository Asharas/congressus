FROM nginx:latest

RUN set -ex \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -yq supervisor php7.3-fpm php7.3-mysql php7.3-gd php7.3-mbstring

RUN mkdir /run/php \
    && sed -i -e 's_\(listen =\) /run/php/php7.3-fpm.sock_\1 127.0.0.1:9000_g' /etc/php/7.3/fpm/pool.d/www.conf \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=nginx:nginx ./docker/nginx-fpm.conf /etc/nginx/conf.d/default.conf

COPY --chown=www-data:www-data ./application /var/www/html

COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
