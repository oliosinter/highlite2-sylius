#!/bin/bash

composer install --no-dev --prefer-dist

yarn install
yarn run gulp

tar -czf ../vendor.tar.gz vendor/
tar -czf ../assets.tar.gz web/assets/
tar -czf ../bundles.tar.gz web/bundles/

exec $@