# ==========================================
# STAGE 1: Build (Laravel + Vite together)
# ==========================================
FROM php:8.3-cli-alpine AS builder

WORKDIR /app

# Install system dependencies (PHP + Node)
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    unzip \
    libzip-dev \
    icu-dev \
    oniguruma-dev
    
# Install PHP extensions
RUN docker-php-ext-install \
    zip \
    intl \
    mbstring

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Install Node dependencies
RUN npm install

# Build Vite (NOW PHP exists, so wayfinder works ✅)
RUN npm run build


# ==========================================
# STAGE 2: Runtime (Laravel App)
# ==========================================
FROM php:8.3-fpm-alpine

WORKDIR /var/www

# Install system dependencies
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

# Use production PHP config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy full app from builder
COPY --from=builder /app /var/www

# Set permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port
EXPOSE 9000

# IMPORTANT: Serve Laravel (not php-fpm)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=9000"]