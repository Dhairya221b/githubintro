FROM node:14 AS node

WORKDIR /app



COPY . /app/
COPY package*.json ./

# COPY .env.exapmle .env

RUN npm install

FROM php:8.0 

RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip npm \
    && docker-php-ext-install zip pdo_mysql

COPY . /app/
WORKDIR /app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install


COPY --from=node /app .
RUN php artisan key:generate

CMD ["sh", "-c",  "php artisan migrate && npm run dev && php artisan serve --host=0.0.0.0 --port=8000"]