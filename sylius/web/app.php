<?php

/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

use Symfony\Component\HttpFoundation\Request;

// Not the best way to solve this issue, but...
if ($_SERVER['HTTP_HOST'] != 'highlite-spb.ru') {
    header('Location: http://highlite-spb.ru' . $_SERVER['REQUEST_URI'], 301);
}

/*
 * Sylius front controller.
 * Live (production) environment.
 */

/** @var \Composer\Autoload\ClassLoader $loader */
$loader = require __DIR__.'/../vendor/autoload.php';

$kernel = new AppKernel('prod', false);
$kernel->loadClassCache();

$request = Request::createFromGlobals();

$response = $kernel->handle($request);
$response->send();

$kernel->terminate($request, $response);
