# ==========================================
# STAGE 1: Build (Laravel + Vite together)
# ==========================================
FROM php:8.3-cli-alpine AS builder

WORKDIR /app

# Install system dependencies (PHP + Node + DB libs)
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    unzip \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    libpq-dev \
    libpng-dev

# Install ALL PHP extensions needed by Laravel during build
RUN docker-php-ext-install \
    zip \
    intl \
    mbstring \
    bcmath \
    gd \
    pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies (Disabled scripts to prevent DB connection errors during build)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Install Node dependencies and Build Assets
RUN npm install && npm run build

# ==========================================
# STAGE 2: Runtime (Laravel App)
# ==========================================
FROM php:8.3-fpm-alpine

WORKDIR /var/www

# Install runtime system dependencies
RUN apk add --no-cache \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    icu-dev \
    oniguruma-dev \
    curl \
    unzip

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    zip \
    gd \
    intl \
    bcmath \
    opcache

# Use production PHP config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Get a clean Composer (helpful for runtime scripts)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy full app from builder
COPY --from=builder /app /var/www

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

# Start PHP-FPM (Standard for Production)
CMD ["php-fpm"]