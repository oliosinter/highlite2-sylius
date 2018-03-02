FROM oliosinter/sylius-php-fpm:1.0.0

# Memcached Setup
# Required libraries
RUN apt-get update && \
    apt-get install libmemcached-dev libmsgpack-dev libmsgpackc2 -y
# Cloninig and building
RUN cd /tmp && \
    git clone --depth 1 https://github.com/php-memcached-dev/php-memcached.git && \
    cd php-memcached && \
    phpize && \
    ./configure && \
    make && \
    mv modules/ /usr/local/memcached/

RUN echo 'extension=/usr/local/memcached/memcached.so' | \
    tee /usr/local/etc/php/conf.d/memcached.ini

# Coping project files
COPY sylius .

# In develop purposes the codebase folder and all its contents must be owned by www-data.
# The following hack will save folder permissions during volume mapping. Also we will run
# composer from www-data user and need to be sure, that www-data user has rights to write
# into composer cache directory (that will also be a volume).
RUN mkdir -p web/media && \
    chown -R www-data:www-data . && \
    mkdir -p /cache/composer && \
    chown -R www-data:www-data /cache/composer