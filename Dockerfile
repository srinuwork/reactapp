FROM php:8.4-cli

# Install system dependencies for PostgreSQL/Supabase
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy code
COPY . .

# Install dependencies (Ignore version checks to prevent crashes)
RUN composer install --no-interaction --optimize-autoloader --no-scripts --ignore-platform-reqs

# Verify version during build
RUN php -v

EXPOSE 8000

# Run dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]