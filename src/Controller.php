<?php

namespace Portfolio;

final class Controller
{
    private const LANGS = ['en', 'fr', 'uk', 'ru'];

    public function handleRequest(): void
    {
        echo $this->render();
    }

    public function render(): string
    {
        $detector = new LanguageDetector();
        $lang     = $detector->detect();

        $dom  = (new ContentProvider())->getPage($lang);
        $head = $dom->getElementsByTagName('head')->item(0);

        foreach (self::LANGS as $l) {
            $link = $dom->createElement('link');
            $link->setAttribute('rel', 'alternate');
            $link->setAttribute('hreflang', $l);
            $link->setAttribute('href', $this->sameUrl($l));
            $head->appendChild($link);
        }
        return $dom->saveHTML();
    }

    private function sameUrl(string $lang): string
    {
        // Сохраняем текущую страницу и якорь
        $baseUrl = strtok($_SERVER['REQUEST_URI'] ?? '/', '?');
        $query = $_GET;
        $query['lang'] = $lang;
        
        // Добавляем хэш, если он есть (для JavaScript это будет обработано отдельно)
        return $baseUrl . '?' . http_build_query($query);
    }
}
