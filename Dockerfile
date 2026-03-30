# ==========================================
# STAGE 1: Build (Laravel + Vite together)
# ==========================================
FROM php:8.3-cli AS builder

WORKDIR /app

# Install system dependencies
# (Debian uses 'apt' instead of 'apk')
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
    curl \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    zip \
    gd \
    intl \
    bcmath

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install Laravel dependencies
# Use -d memory_limit=-1 to prevent Exit Code 2 (Memory crashes)
RUN php -d memory_limit=-1 /usr/bin/composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Install Node dependencies and Build Assets
RUN npm install && npm run build

# ==========================================
# STAGE 2: Runtime (Laravel App)
# ==========================================
FROM php:8.3-fpm

WORKDIR /var/www

# Install runtime system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libicu-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

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

# Copy full app from builder
COPY --from=builder /app /var/www

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
