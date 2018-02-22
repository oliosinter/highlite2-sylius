FROM oliosinter/sylius-php-fpm:1.0.0

# Installing nodejs and yarn to build frontend assets
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends yarn

# Adding scripts
COPY ci/build/scripts/release.sh /usr/local/bin/release.sh

# Coping the source code
COPY sylius .

# Creating
RUN chmod +x /usr/local/bin/release.sh \
    && mkdir -p /var/www/.composer \
    && mkdir -p /var/www/html/node_modules \
    && chown -R www-data:www-data /var/www

ENV COMPOSER_CACHE_DIR=/var/www/.composer

USER www-data