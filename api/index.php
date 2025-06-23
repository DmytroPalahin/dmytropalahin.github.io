<?php
// Vercel serverless function entry point
declare(strict_types=1);

// Start session for language preference storage
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Set headers for proper content type
header('Content-Type: text/html; charset=UTF-8');

// Cache control - different for dev and production
$isDevelopment = (getenv('VERCEL_ENV') === 'development') ||
                 (getenv('NODE_ENV') === 'development') ||
                 (!empty($_SERVER['HTTP_HOST']) && str_contains($_SERVER['HTTP_HOST'], 'localhost'));

if ($isDevelopment) {
    header('Cache-Control: no-cache, no-store, must-revalidate');
} else {
    // Cache for 5 minutes in production
    header('Cache-Control: public, max-age=300, s-maxage=300');
}

// Load Composer autoloader if available, fallback to manual loading
if (file_exists(__DIR__ . '/../vendor/autoload.php')) {
    require_once __DIR__ . '/../vendor/autoload.php';
} else {
    // Manual loading for development/deployment without Composer
    require_once __DIR__ . '/../src/Autoloader.php';
    require_once __DIR__ . '/../src/Controller.php';
    require_once __DIR__ . '/../src/LanguageDetector.php';
    require_once __DIR__ . '/../src/ContentProvider.php';
}

try {
    // Create controller instance - use full namespace path
    $controller = new \Portfolio\Controller();
    
    // Handle the request
    $controller->handleRequest();
} catch (\Throwable $e) {
    // Error handling for production
    http_response_code(500);
    
    // Check if we're in development environment
    $isDevelopment = (getenv('VERCEL_ENV') === 'development') ||
                     (getenv('NODE_ENV') === 'development') ||
                     (!empty($_SERVER['HTTP_HOST']) && str_contains($_SERVER['HTTP_HOST'], 'localhost'));
    
    // Always log errors for debugging
    error_log("Portfolio Error: " . $e->getMessage() . " in " . $e->getFile() . " on line " . $e->getLine());
    
    if ($isDevelopment) {
        // Development error display
        echo "<!DOCTYPE html>\n";
        echo "<html><head><title>Development Error</title></head><body>\n";
        echo "<h1>Development Error</h1>\n";
        echo "<h2>Error Message:</h2>\n";
        echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>\n";
        echo "<h2>File:</h2>\n";
        echo "<pre>" . htmlspecialchars($e->getFile()) . " on line " . $e->getLine() . "</pre>\n";
        echo "<h2>Stack Trace:</h2>\n";
        echo "<pre>" . htmlspecialchars($e->getTraceAsString()) . "</pre>\n";
        echo "</body></html>";
    } else {
        // Production error display
        echo "<!DOCTYPE html>\n";
        echo "<html lang=\"en\">\n";
        echo "<head>\n";
        echo "<meta charset=\"UTF-8\">\n";
        echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n";
        echo "<title>Error - Portfolio</title>\n";
        echo "<style>\n";
        echo "body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 40px; background: #111; color: #fff; text-align: center; }\n";
        echo "h1 { color: #ff6b6b; margin-bottom: 20px; }\n";
        echo "p { color: #aaa; line-height: 1.6; }\n";
        echo "a { color: #4ecdc4; text-decoration: none; }\n";
        echo "a:hover { text-decoration: underline; }\n";
        echo "</style>\n";
        echo "</head>\n";
        echo "<body>\n";
        echo "<h1>Something went wrong</h1>\n";
        echo "<p>We're experiencing technical difficulties. Please try again later.</p>\n";
        echo "<p><a href=\"/\">← Back to homepage</a></p>\n";
        echo "</body>\n";
        echo "</html>";
    }
}
