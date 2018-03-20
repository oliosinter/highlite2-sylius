#!/bin/bash

LATEST_BACKEND=`docker ps -f label=application=highlite2-sylius -f label=service=backend -l --format "{{.Names}}"`
LATEST_STATIC=`docker ps -f label=application=highlite2-sylius -f label=service=static -l --format "{{.Names}}"`
PROXY=`docker ps -f label=application=highlite2-sylius -f label=service=proxy -l --format "{{.Names}}"`

docker exec -u www-data ${LATEST_BACKEND} php bin/console cache:warmup

cat ci/prod/proxy/_default.conf \
   | sed "s/{HIGHLITE2_SYLIUS_BACKEND}/${LATEST_BACKEND}/" \
   | sed "s/{HIGHLITE2_SYLIUS_STATIC}/${LATEST_STATIC}/" \
   > ci/prod/proxy/default.conf

docker cp ci/prod/proxy/default.conf ${PROXY}:/etc/nginx/conf.d
docker exec ${PROXY} /etc/init.d/nginx reload

docker rm -f $(docker ps -f label=application=highlite2-sylius -f label=service=backend --format "{{.Names}}" | grep -v ${LATEST_BACKEND})
docker rm -f $(docker ps -f label=application=highlite2-sylius -f label=service=static --format "{{.Names}}" | grep -v ${LATEST_STATIC})

rm -f ci/prod/proxy/default.conf