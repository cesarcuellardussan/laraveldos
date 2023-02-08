# imagen de dockerhub que descargara
# FROM php:7.3-fpm-alpine
FROM php:7.4-fpm-alpine

# algunas configuraciones para que funcione el contenedor
RUN docker-php-ext-install pdo pdo_mysql

# instala composer en el contenedor
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# da permisos para editar los archivos en esta ruta del container
RUN chown -R www-data:www-data /var/www
RUN chmod 755 /var/www

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=spiralscout/roadrunner:2.4.2 /usr/bin/rr /usr/bin/

RUN composer install
RUN php artisan key:generate