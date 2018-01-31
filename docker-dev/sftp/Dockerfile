FROM atmoz/sftp:debian

# In develop purposes the codebase folder and all its contents must be owned by www-data.
# The following hack will save folder permissions during volume mapping.
RUN mkdir -p /home/dev/src \
    && chown -R www-data:www-data /home/dev/src

WORKDIR /home/dev/src