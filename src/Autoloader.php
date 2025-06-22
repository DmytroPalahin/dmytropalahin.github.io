<?php

/**
 * PSR-4-совместимый автозагрузчик для корневого namespace `Portfolio\`.
 * Пример:  Portfolio\Controller      → src/Controller.php
 *          Portfolio\Utils\Helper    → src/Utils/Helper.php
 */
spl_autoload_register(function (string $class): void {
    $prefix  = 'Portfolio\\';          // наш root-namespace
    $baseDir = __DIR__ . '/';          // абсолютный путь к каталогу src/

    // Если класс не из нашего namespace — пропускаем
    if (strncmp($prefix, $class, strlen($prefix)) !== 0) {
        return;
    }

    // Обрезаем префикс, меняем \ на /, добавляем .php
    $relative = substr($class, strlen($prefix));
    $file     = $baseDir . str_replace('\\', '/', $relative) . '.php';

    if (is_file($file)) {
        require $file;
    }
});
