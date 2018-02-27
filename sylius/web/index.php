<?php

$env = getenv('SYMFONY_ENV');

if ($env == 'dev') {
    include 'app_dev.php';
} elseif ($env == 'staging') {
    include 'app_staging.php';
} else {
    include 'app.php';
}
