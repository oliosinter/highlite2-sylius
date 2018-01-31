FROM kkarczmarczyk/node-yarn:7.6-slim

# Adding scripts
COPY frontend/build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh

# In develop purposes the codebase folder and all its contents must be owned by www-data.
# The following hack will save folder permissions during volume mapping. We will run build
# script from www-data user and yarn will attempt to create additional files in a www-data
# homedir (/var/www). Thats why we are granting permissions to /var/www instead of just
# giving permissions for /var/www/html
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www

WORKDIR /var/www/html