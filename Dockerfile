FROM nginx:1.19.4

RUN set -ex && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq php7.3-fpm php7.3-mysql php7.3-gd php7.3-mbstring supervisor


RUN mkdir /run/php && \
    sed -i 's_\(listen =\) /run/php/php7.3-fpm.sock_\1 127.0.0.1:9000_g' /etc/php/7.3/fpm/pool.d/www.conf

COPY --chown=nginx:nginx ./docker/nginx-congressus.conf /etc/nginx/conf.d/congressus.conf

COPY --chown=www-data:www-data ./application /var/www/html

COPY ./docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
