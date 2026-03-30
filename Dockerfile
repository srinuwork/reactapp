FROM php:8.3-cli

# Install system dependencies
# Added libpq-dev for PostgreSQL/Supabase
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

# Run dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]