<?php

/**
 * The default currency is EUR, since all highlite products have prices in EUR.
 * But our channel needs products to have prices in RUB. Sylius doesn't handle
 * this case properly: when default currency is EUR but the only available
 * currency for channel is RUB - EUR is always displayed. This problem
 * could be solved by setting cookie manually.
 */
$_COOKIE['_currency_default'] = 'RUB';

$env = getenv('SYMFONY_ENV');

if ($env == 'dev') {
    include 'app_dev.php';
} elseif ($env == 'staging') {
    include 'app_staging.php';
} else {
    include 'app.php';
}
