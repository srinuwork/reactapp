FROM php:8.4-cli

# 1. Install system dependencies + Node.js & npm (Required for Vite)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpq-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_pgsql zip

# 2. Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# 3. Copy your code
COPY . .

# 4. Install PHP Dependencies (Ignore version checks)
RUN composer install --no-interaction --optimize-autoloader --no-scripts --ignore-platform-reqs

# 5. Install Node Dependencies & Build your Vite assets
RUN npm install && npm run build

# 6. Set correct permissions for storage and cache
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 8000

# 7. Run dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
