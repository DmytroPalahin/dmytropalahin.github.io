<?php

declare(strict_types=1);

require_once __DIR__ . '/../src/Autoloader.php';

use Portfolio\Controller;

session_start();
echo (new Controller())->render();
