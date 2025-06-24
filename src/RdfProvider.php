<?php

namespace Portfolio;

/**
 * RDF Provider - интеграция семантических данных с портфолио
 * Соединяет schema.ttl + meta.ttl с вашим XML/XSLT потоком
 */
final class RdfProvider
{
    private const RDF_SCHEMA_PATH = __DIR__ . '/../rdf/schema.ttl';
    private const RDF_DATA_PATH = __DIR__ . '/../data/meta.ttl';
    
    private array $rdfData = [];
    private array $skills = [];
    private array $projects = [];
    private array $education = [];
    private array $workExperience = [];
    
    public function __construct()
    {
        $this->loadRdfData();
        $this->parseSemanticData();
    }
    
    /**
     * Загружает RDF данные (упрощенный парсер)
     */
    private function loadRdfData(): void
    {
        if (!file_exists(self::RDF_DATA_PATH)) {
            return;
        }
        
        $content = file_get_contents(self::RDF_DATA_PATH);
        $this->parseBasicTriples($content);
    }
    
    /**
     * Простой парсер Turtle для основных триплетов
     */
    private function parseBasicTriples(string $content): void
    {
        // Удаляем комментарии
        $content = preg_replace('/^\s*#.*$/m', '', $content);
        
        // Парсим основные триплеты (упрощенно)
        preg_match_all('/:(\w+)\s+a\s+ex:(\w+)\s*;/m', $content, $matches, PREG_SET_ORDER);
        
        foreach ($matches as $match) {
            $subject = $match[1];
            $type = $match[2];
            
            $this->rdfData[$subject] = ['type' => $type];
            
            // Парсим свойства для этого субъекта
            $this->parseProperties($content, $subject);
        }
    }
    
    /**
     * Парсит свойства для конкретного субъекта
     */
    private function parseProperties(string $content, string $subject): void
    {
        $pattern = "/:{$subject}\s+.*?(?=^:|$)/ms";
        if (preg_match($pattern, $content, $matches)) {
            $block = $matches[0];
            
            // Парсим rdfs:label
            if (preg_match('/rdfs:label\s+"([^"]+)"@(\w+)/', $block, $labelMatch)) {
                $this->rdfData[$subject]['labels'][$labelMatch[2]] = $labelMatch[1];
            }
            
            // Парсим schema:name
            if (preg_match_all('/schema:name\s+"([^"]+)"@(\w+)/', $block, $nameMatches, PREG_SET_ORDER)) {
                foreach ($nameMatches as $nameMatch) {
                    $this->rdfData[$subject]['names'][$nameMatch[2]] = $nameMatch[1];
                }
            }
            
            // Парсим ex:hasSkillLevel
            if (preg_match('/ex:hasSkillLevel\s+"([^"]+)"/', $block, $skillMatch)) {
                $this->rdfData[$subject]['skillLevel'] = $skillMatch[1];
            }
        }
    }
    
    /**
     * Организует данные по категориям
     */
    private function parseSemanticData(): void
    {
        foreach ($this->rdfData as $id => $data) {
            switch ($data['type'] ?? '') {
                case 'ProgrammingLanguage':
                case 'TechnicalSkill':
                case 'Framework':
                case 'DevOpsTool':
                case 'LanguageSkill':
                    $this->skills[$id] = $data;
                    break;
                    
                case 'ProfessionalProject':
                case 'AcademicProject':
                case 'PersonalProject':
                    $this->projects[$id] = $data;
                    break;
                    
                case 'Degree':
                case 'Course':
                    $this->education[$id] = $data;
                    break;
                    
                case 'Internship':
                case 'FullTimePosition':
                    $this->workExperience[$id] = $data;
                    break;
            }
        }
    }
    
    /**
     * Получить навыки по категориям
     */
    public function getSkillsByCategory(): array
    {
        $categories = [
            'Programming Languages' => [],
            'Frameworks & Tools' => [],
            'Languages' => []
        ];
        
        foreach ($this->skills as $id => $skill) {
            $type = $skill['type'] ?? '';
            $name = $this->getLocalizedName($skill, 'en');
            $level = $skill['skillLevel'] ?? 'Intermediate';
            
            if ($type === 'ProgrammingLanguage') {
                $categories['Programming Languages'][] = [
                    'name' => $name,
                    'level' => $level,
                    'id' => $id
                ];
            } elseif (in_array($type, ['TechnicalSkill', 'Framework', 'DevOpsTool'])) {
                $categories['Frameworks & Tools'][] = [
                    'name' => $name,
                    'level' => $level,
                    'id' => $id
                ];
            } elseif ($type === 'LanguageSkill') {
                $categories['Languages'][] = [
                    'name' => $name,
                    'level' => $level,
                    'id' => $id
                ];
            }
        }
        
        return $categories;
    }
    
    /**
     * Получить проекты
     */
    public function getProjects(): array
    {
        $projects = [];
        
        foreach ($this->projects as $id => $project) {
            $projects[] = [
                'id' => $id,
                'name' => $this->getLocalizedName($project, 'en'),
                'type' => $project['type'] ?? 'Project',
                'description' => $project['description'] ?? ''
            ];
        }
        
        return $projects;
    }
    
    /**
     * Получить образование
     */
    public function getEducation(): array
    {
        $education = [];
        
        foreach ($this->education as $id => $edu) {
            $education[] = [
                'id' => $id,
                'title' => $this->getLocalizedName($edu, 'en'),
                'type' => $edu['type'] ?? 'Education',
                'institution' => $edu['institution'] ?? ''
            ];
        }
        
        return $education;
    }
    
    /**
     * Получить опыт работы
     */
    public function getWorkExperience(): array
    {
        $experience = [];
        
        foreach ($this->workExperience as $id => $work) {
            $experience[] = [
                'id' => $id,
                'title' => $this->getLocalizedName($work, 'en'),
                'type' => $work['type'] ?? 'Work',
                'company' => $work['company'] ?? ''
            ];
        }
        
        return $experience;
    }
    
    /**
     * Получить локализованное имя
     */
    private function getLocalizedName(array $data, string $lang): string
    {
        return $data['names'][$lang] ?? 
               $data['labels'][$lang] ?? 
               $data['names']['en'] ?? 
               $data['labels']['en'] ?? 
               'Unknown';
    }
    
    /**
     * Получить JSON-LD для встраивания в HTML
     */
    public function getJsonLd(): string
    {
        $jsonLd = [
            '@context' => 'http://schema.org',
            '@type' => 'Person',
            'name' => 'Dmytro Palahin',
            'jobTitle' => 'Full-Stack Developer & Data Engineer',
            'email' => 'dmytro.palahin@gmail.com',
            'telephone' => '+33 7 87 32 58 78',
            'nationality' => 'Ukrainian',
            'address' => [
                '@type' => 'PostalAddress',
                'addressLocality' => 'Paris',
                'addressCountry' => 'France'
            ],
            'sameAs' => [
                'https://github.com/DmytroPalahin',
                'https://linkedin.com/in/dmytropalahin',
                'https://t.me/dmytropalahin'
            ],
            'knowsAbout' => [
                'Python', 'JavaScript', 'SQL', 'Apache Spark', 
                'Kedro', 'MLFlow', 'Docker', 'Machine Learning', 
                'Data Engineering'
            ],
            'knowsLanguage' => [
                ['@type' => 'Language', 'name' => 'Ukrainian', 'proficiencyLevel' => 'Native'],
                ['@type' => 'Language', 'name' => 'Russian', 'proficiencyLevel' => 'Bilingual'],
                ['@type' => 'Language', 'name' => 'English', 'proficiencyLevel' => 'Fluent'],
                ['@type' => 'Language', 'name' => 'French', 'proficiencyLevel' => 'Fluent'],
                ['@type' => 'Language', 'name' => 'German', 'proficiencyLevel' => 'Beginner']
            ],
            'worksFor' => [
                '@type' => 'Organization',
                'name' => 'Société Générale Insurance',
                'location' => 'Paris, France'
            ],
            'award' => [
                '@type' => 'Award',
                'name' => 'Georges Besse Foundation Award',
                'dateReceived' => '2022'
            ]
        ];
        
        return json_encode($jsonLd, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    }
    
    /**
     * Генерировать RDFa атрибуты для HTML элементов
     */
    public function getRdfaAttributes(string $property, string $type = null): string
    {
        $attrs = "property=\"{$property}\"";
        if ($type) {
            $attrs .= " typeof=\"{$type}\"";
        }
        return $attrs;
    }
}
