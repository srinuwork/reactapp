# ==========================================
# STAGE 1: Frontend Build (React + Vite)
# ==========================================
FROM node:20-alpine AS frontend-builder

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install

# Copy application code and build assets
COPY . .
RUN npm run build

# ==========================================
# STAGE 2: Backend & Runtime (Laravel)
# ==========================================
FROM php:8.3-fpm-alpine

# Set working directory
WORKDIR /var/www

# Install system dependencies
# - libpq-dev is required for PostgreSQL/Supabase
# - icu-dev for intl extension
# - libzip-dev for zip extension
RUN apk add --no-cache \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    icu-dev \
    oniguruma-dev \
    curl \
    unzip \
    git

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    zip \
    gd \
    intl \
    bcmath \
    opcache

# Use the production PHP config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Get latest Composer from formal image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy only the necessary Laravel application files
COPY . .

# Copy the built React assets from STAGE 1
# This assumes Vite builds into public/build (default for Laravel Vite)
COPY --from=frontend-builder /app/public/build ./public/build

# Install Laravel dependencies (Production mode)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Security: Set permissions for Laravel storage and cache folders
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Optimization: Pre-cache Laravel config and routes
# Note: These require a valid APP_KEY in the environment
# RUN php artisan config:cache && php artisan route:cache

EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
