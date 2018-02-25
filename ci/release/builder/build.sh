#!/bin/bash

composer install --no-dev --prefer-dist --no-autoloader --no-scripts

yarn install
yarn run gulp

tar -cf ../vendor.tar vendor/
tar -cf ../assets.tar web/assets/
tar -cf ../bundles.tar web/bundles/

exec $@