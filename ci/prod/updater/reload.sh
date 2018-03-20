#!/bin/bash

LABEL_BACKEND="highlite2-sylius-backend"
LABEL_STATIC="highlite2-sylius-static"
LABEL_PROXY="highlite2-sylius-proxy"

LATEST_BACKEND=`docker ps -f label=application=${LABEL_BACKEND} -l --format "{{.Names}}"`
LATEST_STATIC=`docker ps -f label=application=${LABEL_STATIC} -l --format "{{.Names}}"`
PROXY=`docker ps -f label=application=${LABEL_PROXY} -l --format "{{.Names}}"`

cat ci/build/proxy/_default.conf \
   | sed "s/HIGHLITE2_SYLIUS_BACKEND/${LATEST_BACKEND}/" \
   | sed "s/HIGHLITE2_SYLIUS_STATIC/${LATEST_STATIC}/" \
   > ci/build/proxy/default.conf

docker cp ci/build/proxy/default.conf ${PROXY}:/etc/nginx/conf.d
docker exec ${PROXY} /etc/init.d/nginx reload

rm -f ci/build/proxy/default.conf