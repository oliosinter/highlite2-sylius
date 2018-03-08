FROM nginx:1.13

WORKDIR /var/www/html

# Copying bundles
COPY ci/release/artefacts/bundles.tar /var/www
RUN tar -xf /var/www/bundles.tar \
    && rm -f /var/www/bundles.tar

# Copying assets
COPY ci/release/artefacts/assets.tar /var/www
RUN tar -xf /var/www/assets.tar \
    && rm -f /var/www/assets.tar

# Copying other static files
COPY sylius/web/robots.txt web/
COPY sylius/web/favicon.ico web/
COPY sylius/web/img web/img

# Copying nginx config
COPY ci/release/static/default.conf /etc/nginx/conf.d

# Creating directories and changing rights
RUN mkdir -p web/media \
    && chown -R www-data:www-data .

EXPOSE 80

LABEL application=highlite2-sylius
LABEL service=static