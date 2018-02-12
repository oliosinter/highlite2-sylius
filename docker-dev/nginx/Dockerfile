FROM nginx:1.13

# In develop purposes the codebase folder and all its contents must be owned by www-data.
# The following hack will save folder permissions during volume mapping.
RUN mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Coping nginx configuration
#COPY nginx/default.conf /etc/nginx/conf.d/default.conf