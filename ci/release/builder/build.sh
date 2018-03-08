#!/bin/bash

composer install --no-dev --prefer-dist

yarn install
yarn run gulp
yarn run rev

tar --mtime='1970-01-01' -cf ../vendor.tar vendor/
tar --mtime='1970-01-01' -cf ../assets.tar web/assets/
tar --mtime='1970-01-01' -cf ../bundles.tar web/bundles/

exec $@