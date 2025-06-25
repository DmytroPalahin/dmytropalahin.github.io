<?php

namespace Portfolio;

final class Controller
{
    private const LANGS = ['en', 'fr', 'uk', 'ru'];

    private RdfProvider $rdfProvider;

    public function __construct()
    {
        $this->rdfProvider = new RdfProvider();
    }

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

        // Добавляем JSON-LD для SEO и семантической разметки
        $jsonLdScript = $dom->createElement('script');
        $jsonLdScript->setAttribute('type', 'application/ld+json');
        $jsonLdScript->textContent = $this->rdfProvider->getEnhancedJsonLd();
        $head->appendChild($jsonLdScript);

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

    /**
     * Получить семантические данные для использования в шаблонах
     */
    public function getSemanticData(): array
    {
        return [
            'skills' => $this->rdfProvider->getSkillsByCategory(),
            'projects' => $this->rdfProvider->getProjects(),
            'education' => $this->rdfProvider->getEducation(),
            'workExperience' => $this->rdfProvider->getWorkExperience()
        ];
    }

    /**
     * API endpoint для получения структурированных данных
     */
    public function apiData(string $format = 'json'): string
    {
        $semanticData = $this->getSemanticData();
        
        switch ($format) {
            case 'jsonld':
                return $this->rdfProvider->getEnhancedJsonLd();
            case 'json':
            default:
                return json_encode($semanticData, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        }
    }
}
