FROM oliosinter/sylius-php-fpm:1.0.0

# Copying artefacts
COPY ci/release/artefacts/vendor.tar /var/www

# Unpacking artefacts
RUN tar -xf /var/www/vendor.tar \
    && rm -f /var/www/*.tar

# Copying the source code
COPY sylius .

# Creating directories and changing rights
RUN mkdir -p web/media \
    && chown -R www-data:www-data .

# Labels
LABEL application=highlite2-sylius
LABEL service=backend