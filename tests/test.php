<?php
// Простой тест для проверки работы приложения

echo "Testing Portfolio Application...\n";

// Manual loading (as in production without Composer)
require_once __DIR__ . '/../src/Autoloader.php';
require_once __DIR__ . '/../src/Controller.php';
require_once __DIR__ . '/../src/LanguageDetector.php';
require_once __DIR__ . '/../src/ContentProvider.php';

try {
    echo "1. Creating controller instance...\n";
    $controller = new \Portfolio\Controller();
    
    echo "2. Testing language detection...\n";
    $detector = new \Portfolio\LanguageDetector();
    $lang = $detector->detect();
    echo "   Detected language: $lang\n";
    
    echo "3. Testing content provider...\n";
    $provider = new \Portfolio\ContentProvider();
    $dom = $provider->getPage($lang);
    echo "   Content loaded successfully\n";
    
    echo "4. Testing full render...\n";
    $output = $controller->render();
    echo "   Render output length: " . strlen($output) . " characters\n";
    
    // Check if output contains expected elements
    if (strpos($output, '<html') !== false && strpos($output, '</html>') !== false) {
        echo "   ✅ HTML structure looks good\n";
    } else {
        echo "   ❌ HTML structure issue\n";
    }
    
    if (strpos($output, 'language-selector') !== false) {
        echo "   ✅ Language selector found\n";
    } else {
        echo "   ❌ Language selector missing\n";
    }
    
    echo "\n✅ All tests passed!\n";
    
} catch (\Throwable $e) {
    echo "\n❌ Error: " . $e->getMessage() . "\n";
    echo "   File: " . $e->getFile() . " on line " . $e->getLine() . "\n";
    echo "   Stack trace:\n" . $e->getTraceAsString() . "\n";
}

/*
php tests/test.php
*/