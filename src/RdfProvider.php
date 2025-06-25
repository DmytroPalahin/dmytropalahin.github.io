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
    
    // RDFa Schema.org constants
    private const SCHEMA_NAME = 'schema:name';
    private const SCHEMA_DESCRIPTION = 'schema:description';
    private const SCHEMA_START_DATE = 'schema:startDate';
    private const SCHEMA_END_DATE = 'schema:endDate';
    private const SCHEMA_URL = 'schema:url';
    
    private array $rdfData = [];
    private array $skills = [];
    private array $projects = [];
    private array $education = [];
    private array $workExperience = [];
    private array $awards = [];
    private array $organizations = [];
    private array $videos = [];
    private array $publications = [];
    private array $address = [];
    private array $person = [];
    
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
        
        // Парсим основные триплеты (упрощенно) - включаем дефисы в имена
        preg_match_all('/:([a-zA-Z0-9_-]+)\s+a\s+ex:(\w+)\s*;/m', $content, $matches, PREG_SET_ORDER);
        
        foreach ($matches as $match) {
            $subject = $match[1];
            $type = $match[2];
            
            $this->rdfData[$subject] = ['type' => $type];
            
            // Парсим свойства для этого субъекта
            $this->parseProperties($content, $subject);
        }
        
        // Отладочная информация
        if (empty($this->rdfData)) {
            error_log("No RDF data parsed. Content preview: " . substr($content, 0, 500));
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
            if (preg_match_all('/rdfs:label\s+"([^"]+)"@(\w+)/', $block, $labelMatches, PREG_SET_ORDER)) {
                foreach ($labelMatches as $labelMatch) {
                    $this->rdfData[$subject]['labels'][$labelMatch[2]] = $labelMatch[1];
                }
            }
            
            // Парсим schema:name
            if (preg_match_all('/schema:name\s+"([^"]+)"/', $block, $nameMatches, PREG_SET_ORDER)) {
                foreach ($nameMatches as $nameMatch) {
                    $this->rdfData[$subject]['names']['en'] = $nameMatch[1];
                }
            }
            
            // Парсим ex:hasSkillLevel
            if (preg_match('/ex:hasSkillLevel\s+"([^"]+)"/', $block, $skillMatch)) {
                $this->rdfData[$subject]['skillLevel'] = $skillMatch[1];
            }
            
            // Парсим ex:skillCategory
            if (preg_match('/ex:skillCategory\s+"([^"]+)"/', $block, $categoryMatch)) {
                $this->rdfData[$subject]['category'] = $categoryMatch[1];
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
                    
                case 'AcademicAward':
                case 'ProfessionalAward':
                    $this->awards[$id] = $data;
                    break;
                    
                case 'Organization':
                case 'EducationalOrganization':
                    $this->organizations[$id] = $data;
                    break;
                    
                case 'VideoObject':
                    $this->videos[$id] = $data;
                    break;
                    
                case 'JournalArticle':
                case 'ScholarlyArticle':
                    $this->publications[$id] = $data;
                    break;
                    
                case 'PostalAddress':
                    $this->address[$id] = $data;
                    break;
                    
                case 'Person':
                    $this->person[$id] = $data;
                    break;
                    
                default:
                    // Неизвестный тип - сохраняем в общем массиве
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
     * Получить награды
     */
    public function getAwards(): array
    {
        $awards = [];
        
        foreach ($this->awards as $id => $award) {
            $awards[] = [
                'id' => $id,
                'name' => $this->getLocalizedName($award, 'en'),
                'type' => $award['type'] ?? 'Award',
                'dateReceived' => $award['dateReceived'] ?? '',
                'organization' => $award['awardingOrganization'] ?? ''
            ];
        }
        
        return $awards;
    }
    
    /**
     * Получить организации
     */
    public function getOrganizations(): array
    {
        $organizations = [];
        
        foreach ($this->organizations as $id => $org) {
            $organizations[] = [
                'id' => $id,
                'name' => $this->getLocalizedName($org, 'en'),
                'type' => $org['type'] ?? 'Organization',
                'location' => $org['location'] ?? '',
                'url' => $org['url'] ?? ''
            ];
        }
        
        return $organizations;
    }
    
    /**
     * Получить видео
     */
    public function getVideos(): array
    {
        $videos = [];
        
        foreach ($this->videos as $id => $video) {
            $videos[] = [
                'id' => $id,
                'name' => $this->getLocalizedName($video, 'en'),
                'type' => $video['type'] ?? 'VideoObject',
                'url' => $video['contentUrl'] ?? '',
                'description' => $video['description'] ?? ''
            ];
        }
        
        return $videos;
    }
    
    /**
     * Получить публикации
     */
    public function getPublications(): array
    {
        $publications = [];
        
        foreach ($this->publications as $id => $pub) {
            $publications[] = [
                'id' => $id,
                'title' => $this->getLocalizedName($pub, 'en'),
                'type' => $pub['type'] ?? 'ScholarlyArticle',
                'journal' => $pub['isPartOf'] ?? '',
                'datePublished' => $pub['datePublished'] ?? ''
            ];
        }
        
        return $publications;
    }
    
    /**
     * Получить адрес
     */
    public function getAddress(): array
    {
        $addressData = [];
        
        foreach ($this->address as $id => $addr) {
            $addressData[] = [
                'id' => $id,
                'locality' => $addr['addressLocality'] ?? '',
                'country' => $addr['addressCountry'] ?? '',
                'postalCode' => $addr['postalCode'] ?? '',
                'type' => $addr['type'] ?? 'PostalAddress'
            ];
        }
        
        return $addressData;
    }
    
    /**
     * Получить данные персоны
     */
    public function getPersonData(): array
    {
        $personData = [];
        
        foreach ($this->person as $id => $person) {
            $personData[] = [
                'id' => $id,
                'name' => $this->getLocalizedName($person, 'en'),
                'jobTitle' => $person['jobTitle'] ?? '',
                'email' => $person['email'] ?? '',
                'telephone' => $person['telephone'] ?? '',
                'nationality' => $person['nationality'] ?? ''
            ];
        }
        
        return $personData;
    }
    private function getLocalizedName(array $data, string $lang): string
    {
        // Если есть прямое имя из schema:name
        if (isset($data['names']['en'])) {
            return $data['names']['en'];
        }
        
        // Если есть label
        if (isset($data['labels']['en'])) {
            return $data['labels']['en'];
        }
        
        // Попробуем извлечь из других полей
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
     * Получить RDFa данные для интеграции с XSLT
     */
    public function getRdfaData(): array
    {
        return [
            'person' => [
                'vocab' => 'https://schema.org/',
                'typeof' => 'Person',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'jobTitle' => 'schema:jobTitle',
                    'email' => 'schema:email',
                    'telephone' => 'schema:telephone',
                    'address' => 'schema:address',
                    'nationality' => 'schema:nationality',
                    'description' => self::SCHEMA_DESCRIPTION,
                    'image' => 'schema:image',
                    'url' => self::SCHEMA_URL,
                    'sameAs' => 'schema:sameAs',
                    'knowsAbout' => 'schema:knowsAbout',
                    'knowsLanguage' => 'schema:knowsLanguage',
                    'alumniOf' => 'schema:alumniOf',
                    'worksFor' => 'schema:worksFor'
                ]
            ],
            'skills' => $this->getSkillsRdfaData(),
            'projects' => $this->getProjectsRdfaData(),
            'education' => $this->getEducationRdfaData(),
            'workExperience' => $this->getWorkExperienceRdfaData(),
            'awards' => $this->getAwardsRdfaData(),
            'organizations' => $this->getOrganizationsRdfaData(),
            'videos' => $this->getVideosRdfaData(),
            'publications' => $this->getPublicationsRdfaData(),
            'address' => $this->getAddressRdfaData()
        ];
    }

    private function getSkillsRdfaData(): array
    {
        $rdfaSkills = [];
        foreach ($this->skills as $id => $skill) {
            $rdfaSkills[$id] = [
                'typeof' => 'schema:DefinedTerm',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'skillLevel' => 'ex:hasSkillLevel',
                    'category' => 'schema:category'
                ]
            ];
        }
        return $rdfaSkills;
    }

    private function getProjectsRdfaData(): array
    {
        $rdfaProjects = [];
        foreach ($this->projects as $id => $project) {
            $rdfaProjects[$id] = [
                'typeof' => 'schema:CreativeWork',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'description' => self::SCHEMA_DESCRIPTION,
                    'dateCreated' => 'schema:dateCreated',
                    'creator' => 'schema:creator',
                    'programmingLanguage' => 'schema:programmingLanguage',
                    'url' => self::SCHEMA_URL
                ]
            ];
        }
        return $rdfaProjects;
    }

    private function getEducationRdfaData(): array
    {
        $rdfaEducation = [];
        foreach ($this->education as $id => $edu) {
            $rdfaEducation[$id] = [
                'typeof' => 'schema:EducationalOccupationalCredential',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'educationalCredentialAwarded' => 'schema:educationalCredentialAwarded',
                    'sourceOrganization' => 'schema:sourceOrganization',
                    'startDate' => self::SCHEMA_START_DATE,
                    'endDate' => self::SCHEMA_END_DATE
                ]
            ];
        }
        return $rdfaEducation;
    }

    private function getWorkExperienceRdfaData(): array
    {
        $rdfaWork = [];
        foreach ($this->workExperience as $id => $work) {
            $rdfaWork[$id] = [
                'typeof' => 'schema:WorkExperience',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'jobTitle' => 'schema:jobTitle',
                    'worksFor' => 'schema:worksFor',
                    'startDate' => self::SCHEMA_START_DATE,
                    'endDate' => self::SCHEMA_END_DATE,
                    'description' => self::SCHEMA_DESCRIPTION
                ]
            ];
        }
        return $rdfaWork;
    }

    private function getAwardsRdfaData(): array
    {
        return [
            'typeof' => 'schema:Award',
            'properties' => [
                'name' => self::SCHEMA_NAME,
                'awardingOrganization' => 'schema:awardingOrganization',
                'dateReceived' => 'schema:dateReceived'
            ]
        ];
    }
    
    private function getOrganizationsRdfaData(): array
    {
        $rdfaOrganizations = [];
        foreach ($this->organizations as $id => $org) {
            $rdfaOrganizations[$id] = [
                'typeof' => 'schema:Organization',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'location' => 'schema:location',
                    'url' => self::SCHEMA_URL,
                    'industry' => 'schema:industry'
                ]
            ];
        }
        return $rdfaOrganizations;
    }
    
    private function getVideosRdfaData(): array
    {
        $rdfaVideos = [];
        foreach ($this->videos as $id => $video) {
            $rdfaVideos[$id] = [
                'typeof' => 'schema:VideoObject',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'description' => self::SCHEMA_DESCRIPTION,
                    'contentUrl' => 'schema:contentUrl',
                    'encodingFormat' => 'schema:encodingFormat',
                    'duration' => 'schema:duration'
                ]
            ];
        }
        return $rdfaVideos;
    }
    
    private function getPublicationsRdfaData(): array
    {
        $rdfaPublications = [];
        foreach ($this->publications as $id => $pub) {
            $rdfaPublications[$id] = [
                'typeof' => 'schema:ScholarlyArticle',
                'properties' => [
                    'name' => self::SCHEMA_NAME,
                    'description' => self::SCHEMA_DESCRIPTION,
                    'datePublished' => 'schema:datePublished',
                    'author' => 'schema:author',
                    'isPartOf' => 'schema:isPartOf'
                ]
            ];
        }
        return $rdfaPublications;
    }
    
    private function getAddressRdfaData(): array
    {
        return [
            'typeof' => 'schema:PostalAddress',
            'properties' => [
                'addressLocality' => 'schema:addressLocality',
                'addressCountry' => 'schema:addressCountry',
                'postalCode' => 'schema:postalCode',
                'addressRegion' => 'schema:addressRegion'
            ]
        ];
    }

    /**
     * Генерировать полные RDFa атрибуты для элемента
     */
    public function getElementRdfaAttributes(string $elementType, ?string $property = null): string
    {
        $rdfaData = $this->getRdfaData();
        
        if (!isset($rdfaData[$elementType])) {
            return '';
        }
        
        $element = $rdfaData[$elementType];
        $attrs = [];
        
        if (isset($element['vocab'])) {
            $attrs[] = "vocab=\"{$element['vocab']}\"";
        }
        
        if (isset($element['typeof'])) {
            $attrs[] = "typeof=\"{$element['typeof']}\"";
        }
        
        if ($property && isset($element['properties'][$property])) {
            $attrs[] = "property=\"{$element['properties'][$property]}\"";
        }
        
        return implode(' ', $attrs);
    }

    /**
     * Генерировать RDFa атрибуты для HTML элементов (простой вариант)
     */
    public function getRdfaAttributes(string $property, ?string $type = null): string
    {
        $attrs = "property=\"{$property}\"";
        if ($type) {
            $attrs .= " typeof=\"{$type}\"";
        }
        return $attrs;
    }
}
