FROM oliosinter/sylius-php-fpm:7.1-fpm

# Copying artefacts
COPY ci/release/artefacts/vendor.tar /var/www

# Unpacking artefacts
RUN tar -xf /var/www/vendor.tar \
    && rm -f /var/www/*.tar

# Copying the source code
COPY sylius .

COPY ci/release/artefacts/rev-manifest.json /var/www/html/app

# Creating directories and changing rights
RUN mkdir -p web/media \
    && chown -R www-data:www-data web/media \
    && mkdir -p var/cache \
    && mkdir -p var/logs \
    && chown -R www-data:www-data var

# Labels
LABEL application=highlite2-sylius
LABEL service=backend