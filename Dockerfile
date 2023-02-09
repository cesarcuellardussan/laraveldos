# # imagen de dockerhub que descargara
# # FROM php:7.3-fpm-alpine
# FROM php:7.4-fpm-alpine

# # algunas configuraciones para que funcione el contenedor
# RUN docker-php-ext-install pdo pdo_mysql

# # instala composer en el contenedor
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# # da permisos para editar los archivos en esta ruta del container
# RUN chown -R www-data:www-data /var/www/html
# # RUN chown -R www-data: /var/www/html
# RUN chmod 755 /var/www/html

# # Cambiar la propiedad del directorio /app al usuario www-data
# # RUN chown -R www-data:www-data /var/www/html

# # Establecer el usuario como www-data
# USER www-data


# # docker-compose exec php chown -R www-data: /var/www/html
# # docker-compose exec php chown -R www-data: /var/www/html

# # RUN mkdir -p /home/$user/.composer && \
# #     chown -R $user:$user /home/$user

# # COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# # COPY --from=spiralscout/roadrunner:2.4.2 /usr/bin/rr /usr/bin/

# # RUN composer install
# # RUN php artisan key:generate

FROM php:7.2-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    mysql-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    nano \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]


