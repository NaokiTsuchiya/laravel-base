FROM alpine:3.11

RUN apk --no-cache update \
 && apk --no-cache add \
      curl \
      nginx \
      php7 \
      php7-bcmath \
      php7-ctype \
      php7-dom \
      php7-fpm \
      php7-json \
      php7-mbstring \
      php7-opcache \
      php7-openssl \
      php7-pdo \
      php7-pdo_mysql \
      php7-pecl-xdebug \
      php7-phar \
      php7-redis \
      php7-session \
      php7-tokenizer \
      php7-xml \
      php7-xmlwriter \
      php7-zip \
      runit \
      su-exec \
      tzdata \
 && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
 && apk --no-cache del tzdata \
 && mkdir -p /var/runit \
 && rm -f /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx \
 && sed -i \
      -e 's|^;\?date.timezone =.*|date.timezone = "Asia/Tokyo"|' \
      -e 's|^;\?error_log = php_.*|error_log = "php://stderr"|' \
      -e 's|^;\?error_reporting =.*|error_reporting = E_ALL|' \
      -e 's|^;\?html_errors =.*|html_errors = Off|' \
      -e 's|^;\?mail\.add_x_header =.*|mail\.add_x_header = Off|' \
      -e 's|^expose_php .*$|expose_php = Off|' \
      -e 's|^log_errors_max_len =.*|log_errors_max_len = 0|' \
      -e 's|^memory_limit .*$|memory_limit = 256M|' \
      /etc/php7/php.ini \
 && sed -i \
      -e 's|^;\?error_log =.*$|error_log = /dev/stderr|' \
      -e 's|^;\?log_limit =.*$|log_limit = 10240|' \
      /etc/php7/php-fpm.conf \
 && sed -i \
      -e 's|^;\?access.log =.*$|access.log = /dev/stdout|' \
      -e 's|^;\?catch_workers_output =.*$|catch_workers_output = yes|' \
      -e 's|^;\?clear_env =.*$|clear_env = no|' \
      -e 's|^;\?decorate_workers_output =.*$|decorate_workers_output = no|' \
      -e 's|^;\?listen.group =.*$|listen.group = www-data|' \
      -e 's|^;\?listen.owner =.*$|listen.owner = nginx|' \
      -e 's|^;\?ping.path =.*$|ping.path = /php-fpm_ping|' \
      -e 's|^;\?ping.response =.*$|ping.response = pong|' \
      -e 's|^;\?pm.max_requests =.*$|pm.max_requests = 1000|' \
      -e 's|^;\?pm.status_path =.*$|pm.status_path = /php-fpm_status|' \
      -e 's|^group =.*$|group = nginx|' \
      -e 's|^listen =.*$|listen = /run/php-fpm/www.sock|' \
      -e 's|^pm =.*$|pm = static|' \
      -e 's|^pm.max_children =.*$|pm.max_children = 10|' \
      -e 's|^user =.*$|user = nginx|' \
      /etc/php7/php-fpm.d/www.conf \
 && mkdir -p /run/php-fpm \
 && mkdir -p /app \
 && chown nginx:nginx /app

COPY /var/runit/ /var/runit/
COPY /bin/runit-entry /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/runit-entry"]

WORKDIR /app
