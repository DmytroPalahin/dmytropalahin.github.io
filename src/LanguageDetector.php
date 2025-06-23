<?php

namespace Portfolio;

final class LanguageDetector
{
    private const SUPPORTED = ['en', 'fr', 'ua', 'ru'];
    private const COOKIE_NAME = 'portfolio_lang';
    private const COOKIE_LIFETIME = 60 * 60 * 24 * 365; // 1 год

    public function detect(): string
    {
        // 1. GET параметр (приоритет #1)
        $get = filter_input(INPUT_GET, 'lang') ?: null;
        if ($get && in_array($get, self::SUPPORTED, true)) {
            // Сохраняем в session И в cookie
            $_SESSION['lang'] = $get;
            $this->setCookie($get);
            return $get;
        }
        
        // 2. POST параметр (приоритет #2)
        $post = filter_input(INPUT_POST, 'lang') ?: null;
        if ($post && in_array($post, self::SUPPORTED, true)) {
            // Сохраняем в session И в cookie
            $_SESSION['lang'] = $post;
            $this->setCookie($post);
            return $post;
        }
        
        // 3. Session переменная (приоритет #3)
        if (($sess = $_SESSION['lang'] ?? null) && in_array($sess, self::SUPPORTED, true)) {
            return $sess;
        }
        
        // 4. Cookie (приоритет #4) - НОВОЕ!
        $cookie = filter_input(INPUT_COOKIE, self::COOKIE_NAME) ?: null;
        if ($cookie && in_array($cookie, self::SUPPORTED, true)) {
            // Восстанавливаем в session из cookie
            $_SESSION['lang'] = $cookie;
            return $cookie;
        }
        
        // 5. Accept-Language заголовок (приоритет #5)
        if (!empty($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
            foreach (explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE']) as $chunk) {
                $code = substr(trim($chunk), 0, 2);
                if (in_array($code, self::SUPPORTED, true)) {
                    $_SESSION['lang'] = $code;
                    $this->setCookie($code);
                    return $code;
                }
            }
        }
        
        // 6. Fallback к английскому языку по умолчанию (приоритет #6)
        $_SESSION['lang'] = 'en';
        $this->setCookie('en');
        return 'en';
    }
    
    /**
     * Устанавливает cookie с выбранным языком
     */
    private function setCookie(string $lang): void
    {
        // Проверяем, что заголовки ещё не отправлены
        if (headers_sent()) {
            return;
        }
        
        // Проверяем, что язык поддерживается
        if (!in_array($lang, self::SUPPORTED, true)) {
            return;
        }
        
        // Устанавливаем cookie на 1 год
        setcookie(
            self::COOKIE_NAME,
            $lang,
            [
                'expires' => time() + self::COOKIE_LIFETIME,
                'path' => '/',
                'domain' => '',
                'secure' => isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on',
                'httponly' => true,
                'samesite' => 'Lax'
            ]
        );
    }
}
