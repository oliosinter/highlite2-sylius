FROM oliosinter/sylius-php-fpm:7.1-fpm

# Installing nodejs and yarn to build frontend assets
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends yarn

# Adding scripts
COPY ci/release/builder/build.sh /usr/local/bin/build.sh

# Coping the source code
COPY sylius .

# Creating
RUN chmod +x /usr/local/bin/build.sh \
    && mkdir -p /var/www/.composer \
    && mkdir -p /var/www/html/node_modules \
    && mkdir -p /var/www/html/vendor \
    && chown -R www-data:www-data /var/www

# Changing composer cache directory
ENV COMPOSER_CACHE_DIR=/var/www/.composer

# We will run all scripts from www-data user
USER www-data

LABEL application=highlite2-sylius
LABEL service=builder

ENTRYPOINT ["build.sh"]