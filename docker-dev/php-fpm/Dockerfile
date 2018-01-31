FROM oliosinter/sylius-php-fpm:1.0.0

# Coping project files
COPY sylius .

# In develop purposes the codebase folder and all its contents must be owned by www-data.
# The following hack will save folder permissions during volume mapping. Also we will run
# composer from www-data user and need to be sure, that www-data user has rights to write
# into composer cache directory (that will also be a volume).
RUN mkdir -p web/media \
    && chown -R www-data:www-data . \
    && mkdir -p /cache/composer \
    && chown -R www-data:www-data /cache/composer