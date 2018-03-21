#!/bin/bash

# Latest backend container name
LATEST_BACKEND=`docker ps -f label=application=highlite2-sylius -f label=service=backend -l --format "{{.Names}}"`
# Latest frontend container name
LATEST_STATIC=`docker ps -f label=application=highlite2-sylius -f label=service=static -l --format "{{.Names}}"`
# Proxy container name
PROXY=`docker ps -f label=application=highlite2-sylius -f label=service=proxy -l --format "{{.Names}}"`

# Warming up cache
docker exec -u www-data ${LATEST_BACKEND} php bin/console cache:warmup

# Creating nginx config with new service endpoints
cat ci/prod/proxy/_default.conf \
   | sed "s/{HIGHLITE2_SYLIUS_BACKEND}/${LATEST_BACKEND}/" \
   | sed "s/{HIGHLITE2_SYLIUS_STATIC}/${LATEST_STATIC}/" \
   > ci/prod/proxy/default.conf

# Reloading nginx config
docker cp ci/prod/proxy/default.conf ${PROXY}:/etc/nginx/conf.d
docker exec ${PROXY} /etc/init.d/nginx reload

# Removing old containers
docker rm -f $(docker ps -f label=application=highlite2-sylius -f label=service=backend --format "{{.Names}}" | grep -v ${LATEST_BACKEND})
docker rm -f $(docker ps -f label=application=highlite2-sylius -f label=service=static --format "{{.Names}}" | grep -v ${LATEST_STATIC})

# Removing generated nginx config
rm -f ci/prod/proxy/default.conf