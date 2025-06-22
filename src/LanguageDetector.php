<?php

namespace Portfolio;

final class LanguageDetector
{
    private const SUPPORTED = ['en', 'fr', 'ru'];

    public function detect(): string
    {
        // 1. GET параметр (приоритет #1)
        $get = filter_input(INPUT_GET, 'lang') ?: null;
        if ($get && in_array($get, self::SUPPORTED, true)) {
            $_SESSION['lang'] = $get;
            return $get;
        }
        
        // 2. POST параметр (приоритет #2)
        $post = filter_input(INPUT_POST, 'lang') ?: null;
        if ($post && in_array($post, self::SUPPORTED, true)) {
            $_SESSION['lang'] = $post;
            return $post;
        }
        
        // 3. Session переменная (приоритет #3)
        if (($sess = $_SESSION['lang'] ?? null) && in_array($sess, self::SUPPORTED, true)) {
            return $sess;
        }
        
        // 4. Accept-Language заголовок (приоритет #4)
        if (!empty($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
            foreach (explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE']) as $chunk) {
                $code = substr(trim($chunk), 0, 2);
                if (in_array($code, self::SUPPORTED, true)) {
                    $_SESSION['lang'] = $code;
                    return $code;
                }
            }
        }
        
        // 5. Fallback к первому языку из списка поддерживаемых (приоритет #5)
        $_SESSION['lang'] = self::SUPPORTED[0];
        return self::SUPPORTED[0];
    }
}
