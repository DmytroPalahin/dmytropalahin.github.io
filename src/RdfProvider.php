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
    
    // FOAF vocabulary constants
    private const FOAF_NAME = 'foaf:name';
    private const FOAF_MBOX = 'foaf:mbox';
    private const FOAF_HOMEPAGE = 'foaf:homepage';
    private const FOAF_IMG = 'foaf:img';
    private const FOAF_NICK = 'foaf:nick';
    private const FOAF_TITLE = 'foaf:title';
    private const FOAF_ORGANIZATION_NAME = 'foaf:organization-name';
    private const FOAF_WORK_INFO_NOTE = 'foaf:workInfoNote';
    private const FOAF_ACCOUNT = 'foaf:account';
    private const FOAF_ACCOUNT_SERVICE_HOMEPAGE = 'foaf:accountServiceHomepage';
    private const FOAF_ACCOUNT_NAME = 'foaf:accountName';
    
    // DCterms vocabulary constants  
    private const DCTERMS_TITLE = 'dcterms:title';
    private const DCTERMS_DESCRIPTION = 'dcterms:description';
    private const DCTERMS_CREATOR = 'dcterms:creator';
    private const DCTERMS_DATE = 'dcterms:date';
    private const DCTERMS_SUBJECT = 'dcterms:subject';
    private const DCTERMS_IDENTIFIER = 'dcterms:identifier';
    private const DCTERMS_RELATION = 'dcterms:relation';
    private const DCTERMS_PUBLISHER = 'dcterms:publisher';
    private const DCTERMS_CREATED = 'dcterms:created';
    private const DCTERMS_MODIFIED = 'dcterms:modified';
    private const DCTERMS_ISSUED = 'dcterms:issued';
    
    // VCARD vocabulary constants
    private const VCARD_FN = 'vcard:fn';
    private const VCARD_EMAIL = 'vcard:email';
    private const VCARD_TEL = 'vcard:tel';
    private const VCARD_ADR = 'vcard:adr';
    private const VCARD_ORG = 'vcard:org';
    private const VCARD_TITLE = 'vcard:title';
    private const VCARD_URL = 'vcard:url';
    
    // Additional semantic vocabularies
    private const ORG_ORGANIZATION = 'org:Organization';
    private const ORG_MEMBERSHIP = 'org:membership';
    private const TIME_INTERVAL = 'time:Interval';
    private const GEO_POINT = 'geo:Point';
    private const SKOS_CONCEPT = 'skos:Concept';
    private const PROV_ACTIVITY = 'prov:Activity';
    
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
                'company' => $work['company'] ?? '',
                'period' => $work['period'] ?? '',
                'description' => $work['description'] ?? ''
            ];
        }
        
        return $experience;
    }
    
    private function getLocalizedName(array $data, string $lang): string
    {
        return $data['names'][$lang] ?? $data['labels'][$lang] ?? $data['name'] ?? '';
    }

    /**
     * Получить RDFa данные для интеграции с XSLT
     */
    public function getRdfaData(): array
    {
        return [
            'person' => [
                'vocab' => 'https://schema.org/',
                'typeof' => 'Person foaf:Person vcard:Individual',
                'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ vcard: http://www.w3.org/2006/vcard/ns# ex: https://dmytro.example/schema# org: http://www.w3.org/ns/org# time: http://www.w3.org/2006/time# geo: http://www.w3.org/2003/01/geo/wgs84_pos# skos: http://www.w3.org/2004/02/skos/core# prov: http://www.w3.org/ns/prov#',
                'properties' => [
                    // Schema.org properties - личные данные
                    'name' => 'schema:name',
                    'givenName' => 'schema:givenName',
                    'familyName' => 'schema:familyName',
                    'jobTitle' => 'schema:jobTitle',
                    'email' => 'schema:email',
                    'telephone' => 'schema:telephone',
                    'address' => 'schema:address',
                    'nationality' => 'schema:nationality',
                    'description' => 'schema:description',
                    'image' => 'schema:image',
                    'url' => 'schema:url',
                    'sameAs' => 'schema:sameAs',
                    'knowsAbout' => 'schema:knowsAbout',
                    'knowsLanguage' => 'schema:knowsLanguage',
                    'alumniOf' => 'schema:alumniOf',
                    'worksFor' => 'schema:worksFor',
                    'hasOccupation' => 'schema:hasOccupation',
                    'award' => 'schema:award',
                    'birthPlace' => 'schema:birthPlace',
                    'homeLocation' => 'schema:homeLocation',
                    
                    // FOAF properties - социальные связи
                    'foaf_name' => 'foaf:name',
                    'foaf_nick' => 'foaf:nick',
                    'foaf_mbox' => 'foaf:mbox',
                    'foaf_homepage' => 'foaf:homepage',
                    'foaf_img' => 'foaf:img',
                    'foaf_title' => 'foaf:title',
                    'foaf_workInfoHomepage' => 'foaf:workInfoHomepage',
                    'foaf_workplaceHomepage' => 'foaf:workplaceHomepage',
                    'foaf_schoolHomepage' => 'foaf:schoolHomepage',
                    'foaf_account' => 'foaf:account',
                    'foaf_currentProject' => 'foaf:currentProject',
                    'foaf_pastProject' => 'foaf:pastProject',
                    'foaf_interest' => 'foaf:interest',
                    'foaf_knows' => 'foaf:knows',
                    
                    // VCARD properties - контактная информация
                    'vcard_fn' => 'vcard:fn',
                    'vcard_email' => 'vcard:email',
                    'vcard_tel' => 'vcard:tel',
                    'vcard_adr' => 'vcard:adr',
                    'vcard_org' => 'vcard:org',
                    'vcard_title' => 'vcard:title',
                    'vcard_url' => 'vcard:url',
                    'vcard_photo' => 'vcard:photo',
                    'vcard_role' => 'vcard:role',
                    
                    // DCterms properties - метаданные
                    'dcterms_creator' => 'dcterms:creator',
                    'dcterms_description' => 'dcterms:description',
                    'dcterms_identifier' => 'dcterms:identifier',
                    'dcterms_subject' => 'dcterms:subject',
                    'dcterms_created' => 'dcterms:created',
                    'dcterms_modified' => 'dcterms:modified',
                    'dcterms_spatial' => 'dcterms:spatial'
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

    /**
     * Получить JSON-LD для улучшенной семантической разметки
     */
    public function getEnhancedJsonLd(): string
    {
        $context = [
            "@context" => [
                "schema" => "https://schema.org/",
                "foaf" => "http://xmlns.com/foaf/0.1/",
                "dcterms" => "http://purl.org/dc/terms/",
                "vcard" => "http://www.w3.org/2006/vcard/ns#",
                "org" => "http://www.w3.org/ns/org#",
                "time" => "http://www.w3.org/2006/time#",
                "geo" => "http://www.w3.org/2003/01/geo/wgs84_pos#",
                "skos" => "http://www.w3.org/2004/02/skos/core#",
                "prov" => "http://www.w3.org/ns/prov#",
                "ex" => "https://dmytro.example/schema#"
            ]
        ];
        
        $jsonLd = [
            // Основные данные о персоне
            "@type" => ["schema:Person", "foaf:Person", "vcard:Individual"],
            "@id" => "https://dmytro.example/#me",
            "schema:name" => "Dmytro Palahin",
            "foaf:name" => "Dmytro Palahin",
            "vcard:fn" => "Dmytro Palahin",
            "schema:givenName" => "Dmytro",
            "schema:familyName" => "Palahin",
            "schema:jobTitle" => "Data Engineer | Computer Science Student",
            "foaf:title" => "Mr.",
            "schema:description" => "Computer-science engineering student at Sup Galilée (Paris) and Data Engineer apprentice at Société Générale Insurance. Passionate about ML, optimization and clean code.",
            "dcterms:description" => "Data Engineer and Computer Science student specializing in machine learning, data pipelines, and MLOps.",
            
            // Контактная информация
            "schema:email" => "dmytro.palahin@gmail.com",
            "foaf:mbox" => "mailto:dmytro.palahin@gmail.com",
            "vcard:email" => "dmytro.palahin@gmail.com",
            "schema:telephone" => "+33 7 87 32 58 78",
            "vcard:tel" => "+33 7 87 32 58 78",
            
            // Социальные сети и профили
            "schema:sameAs" => [
                "https://github.com/DmytroPalahin",
                "https://linkedin.com/in/dmytropalahin",
                "https://t.me/dmytropalahin"
            ],
            "foaf:homepage" => "https://portfolio-dmytropalahin.vercel.app/",
            "foaf:account" => [
                [
                    "@type" => "foaf:OnlineAccount",
                    "foaf:accountServiceHomepage" => "https://github.com/",
                    "foaf:accountName" => "DmytroPalahin"
                ],
                [
                    "@type" => "foaf:OnlineAccount", 
                    "foaf:accountServiceHomepage" => "https://linkedin.com/",
                    "foaf:accountName" => "dmytropalahin"
                ]
            ],
            
            // Национальность и адрес
            "schema:nationality" => "Ukrainian",
            "schema:homeLocation" => [
                "@type" => ["schema:PostalAddress", "vcard:Address"],
                "schema:addressLocality" => "Paris",
                "schema:addressCountry" => "France",
                "schema:postalCode" => "75000",
                "schema:addressRegion" => "Île-de-France",
                "vcard:locality" => "Paris",
                "vcard:country-name" => "France",
                "geo:lat" => "48.8566",
                "geo:long" => "2.3522"
            ],
            
            // Навыки и компетенции
            "schema:knowsAbout" => [
                [
                    "@type" => ["schema:DefinedTerm", "skos:Concept"],
                    "schema:name" => "Python",
                    "skos:prefLabel" => "Python Programming",
                    "schema:category" => "Programming Language",
                    "ex:skillLevel" => "Expert",
                    "ex:yearsOfExperience" => "5"
                ],
                [
                    "@type" => ["schema:DefinedTerm", "skos:Concept"],
                    "schema:name" => "Machine Learning",
                    "skos:prefLabel" => "Machine Learning & MLOps",
                    "schema:category" => "Technical Skill",
                    "ex:skillLevel" => "Advanced",
                    "ex:yearsOfExperience" => "3"
                ],
                [
                    "@type" => ["schema:DefinedTerm", "skos:Concept"],
                    "schema:name" => "Apache Spark",
                    "skos:prefLabel" => "Big Data Processing with Apache Spark",
                    "schema:category" => "Big Data Technology",
                    "ex:skillLevel" => "Advanced",
                    "ex:yearsOfExperience" => "2"
                ]
            ],
            
            // Языки
            "schema:knowsLanguage" => [
                ["@type" => "schema:Language", "schema:name" => "Ukrainian", "ex:proficiencyLevel" => "Native"],
                ["@type" => "schema:Language", "schema:name" => "Russian", "ex:proficiencyLevel" => "Native"],
                ["@type" => "schema:Language", "schema:name" => "English", "ex:proficiencyLevel" => "Advanced"],
                ["@type" => "schema:Language", "schema:name" => "French", "ex:proficiencyLevel" => "Intermediate"]
            ]
        ];
        
        return json_encode(array_merge($context, $jsonLd), JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    /**
     * Получить расширенные семантические атрибуты с несколькими словарями
     */
    public function getEnhancedRdfaAttributes(string $elementType, array $properties = []): string
    {
        $rdfaData = $this->getRdfaData();
        
        if (!isset($rdfaData[$elementType])) {
            return '';
        }
        
        $element = $rdfaData[$elementType];
        $attrs = [];
        
        // Добавляем prefix для всех словарей
        if (isset($element['prefix'])) {
            $attrs[] = "prefix=\"{$element['prefix']}\"";
        }
        
        // Добавляем vocab если нет prefix
        if (!isset($element['prefix']) && isset($element['vocab'])) {
            $attrs[] = "vocab=\"{$element['vocab']}\"";
        }
        
        // Добавляем typeof с несколькими типами
        if (isset($element['typeof'])) {
            $attrs[] = "typeof=\"{$element['typeof']}\"";
        }
        
        // Добавляем свойства
        if (!empty($properties)) {
            $propertyAttrs = [];
            foreach ($properties as $prop) {
                if (isset($element['properties'][$prop])) {
                    $propertyAttrs[] = $element['properties'][$prop];
                }
            }
            if (!empty($propertyAttrs)) {
                $attrs[] = "property=\"" . implode(' ', $propertyAttrs) . "\"";
            }
        }
        
        return implode(' ', $attrs);
    }

    /**
     * Получить семантические метаданные для конкретного элемента
     */
    public function getElementMetadata(string $elementType, ?string $elementId = null): array
    {
        $rdfaData = $this->getRdfaData();
        
        if (!isset($rdfaData[$elementType])) {
            return [];
        }
        
        $metadata = [
            'vocab' => $rdfaData[$elementType]['vocab'] ?? '',
            'prefix' => $rdfaData[$elementType]['prefix'] ?? '',
            'typeof' => $rdfaData[$elementType]['typeof'] ?? '',
            'properties' => $rdfaData[$elementType]['properties'] ?? []
        ];
        
        // Добавляем специфические данные для элемента
        if ($elementId) {
            $metadata['id'] = $elementId;
        }
        
        return $metadata;
    }

    private function getSkillsRdfaData(): array
    {
        return [
            'typeof' => 'schema:DefinedTerm skos:Concept',
            'prefix' => 'schema: https://schema.org/ skos: http://www.w3.org/2004/02/skos/core# dcterms: http://purl.org/dc/terms/ ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'category' => 'schema:category',
                'skillLevel' => 'schema:skillLevel',
                'proficiencyLevel' => 'schema:proficiencyLevel',
                'educationalUse' => 'schema:educationalUse',
                
                // SKOS properties - концептуальная схема
                'skos_prefLabel' => 'skos:prefLabel',
                'skos_altLabel' => 'skos:altLabel',
                'skos_definition' => 'skos:definition',
                'skos_broader' => 'skos:broader',
                'skos_narrower' => 'skos:narrower',
                'skos_related' => 'skos:related',
                'skos_inScheme' => 'skos:inScheme',
                
                // DCterms properties
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_created' => 'dcterms:created',
                
                // Custom properties
                'ex_skillLevel' => 'ex:hasSkillLevel',
                'ex_yearsOfExperience' => 'ex:yearsOfExperience',
                'ex_skillCategory' => 'ex:skillCategory',
                'ex_proficiencyLevel' => 'ex:proficiencyLevel'
            ]
        ];
    }

    private function getProjectsRdfaData(): array
    {
        return [
            'typeof' => 'schema:CreativeWork foaf:Project prov:Activity',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ prov: http://www.w3.org/ns/prov# ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'dateCreated' => 'schema:dateCreated',
                'dateModified' => 'schema:dateModified',
                'creator' => 'schema:creator',
                'author' => 'schema:author',
                'contributor' => 'schema:contributor',
                'programmingLanguage' => 'schema:programmingLanguage',
                'url' => 'schema:url',
                'codeRepository' => 'schema:codeRepository',
                'license' => 'schema:license',
                'keywords' => 'schema:keywords',
                'about' => 'schema:about',
                'genre' => 'schema:genre',
                'applicationCategory' => 'schema:applicationCategory',
                
                // FOAF properties - проектная информация
                'foaf_homepage' => 'foaf:homepage',
                'foaf_currentProject' => 'foaf:currentProject',
                'foaf_pastProject' => 'foaf:pastProject',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_creator' => 'dcterms:creator',
                'dcterms_created' => 'dcterms:created',
                'dcterms_modified' => 'dcterms:modified',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_type' => 'dcterms:type',
                'dcterms_format' => 'dcterms:format',
                'dcterms_language' => 'dcterms:language',
                
                // PROV properties - провенанс
                'prov_startedAtTime' => 'prov:startedAtTime',
                'prov_endedAtTime' => 'prov:endedAtTime',
                'prov_wasAssociatedWith' => 'prov:wasAssociatedWith',
                'prov_used' => 'prov:used',
                'prov_generated' => 'prov:generated',
                
                // Custom properties
                'ex_projectType' => 'ex:projectType',
                'ex_projectStatus' => 'ex:projectStatus',
                'ex_usedTechnology' => 'ex:usedTechnology',
                'ex_repositoryUrl' => 'ex:repositoryUrl',
                'ex_demoUrl' => 'ex:demoUrl'
            ]
        ];
    }

    private function getEducationRdfaData(): array
    {
        return [
            'typeof' => 'schema:EducationalOccupationalCredential schema:Course foaf:Organization',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ time: http://www.w3.org/2006/time# ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'educationalCredentialAwarded' => 'schema:educationalCredentialAwarded',
                'credentialCategory' => 'schema:credentialCategory',
                'educationalLevel' => 'schema:educationalLevel',
                'competencyRequired' => 'schema:competencyRequired',
                'recognizedBy' => 'schema:recognizedBy',
                'sourceOrganization' => 'schema:sourceOrganization',
                'startDate' => 'schema:startDate',
                'endDate' => 'schema:endDate',
                'validFrom' => 'schema:validFrom',
                'validThrough' => 'schema:validThrough',
                'about' => 'schema:about',
                'teaches' => 'schema:teaches',
                'courseCode' => 'schema:courseCode',
                'numberOfCredits' => 'schema:numberOfCredits',
                
                // FOAF properties - образовательные связи
                'foaf_schoolHomepage' => 'foaf:schoolHomepage',
                'foaf_organization' => 'foaf:Organization',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_created' => 'dcterms:created',
                'dcterms_issued' => 'dcterms:issued',
                'dcterms_publisher' => 'dcterms:publisher',
                'dcterms_type' => 'dcterms:type',
                'dcterms_format' => 'dcterms:format',
                
                // Time ontology properties
                'time_hasBeginning' => 'time:hasBeginning',
                'time_hasEnd' => 'time:hasEnd',
                'time_hasDuration' => 'time:hasDuration',
                
                // Custom properties
                'ex_degreeType' => 'ex:degreeType',
                'ex_fieldOfStudy' => 'ex:fieldOfStudy',
                'ex_gpa' => 'ex:gpa',
                'ex_academicHonors' => 'ex:academicHonors',
                'ex_hasInstitution' => 'ex:hasInstitution'
            ]
        ];
    }

    private function getWorkExperienceRdfaData(): array
    {
        return [
            'typeof' => 'schema:WorkExperience org:Membership prov:Activity',
            'prefix' => 'schema: https://schema.org/ org: http://www.w3.org/ns/org# foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ time: http://www.w3.org/2006/time# prov: http://www.w3.org/ns/prov# ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'jobTitle' => 'schema:jobTitle',
                'worksFor' => 'schema:worksFor',
                'employer' => 'schema:employer',
                'occupationalCategory' => 'schema:occupationalCategory',
                'startDate' => 'schema:startDate',
                'endDate' => 'schema:endDate',
                'workLocation' => 'schema:workLocation',
                'employmentType' => 'schema:employmentType',
                'skills' => 'schema:skills',
                'responsibilities' => 'schema:responsibilities',
                'qualifications' => 'schema:qualifications',
                'baseSalary' => 'schema:baseSalary',
                
                // ORG ontology properties - организационная структура
                'org_organization' => 'org:organization',
                'org_role' => 'org:role',
                'org_member' => 'org:member',
                'org_memberDuring' => 'org:memberDuring',
                'org_hasPost' => 'org:hasPost',
                
                // FOAF properties - профессиональные связи
                'foaf_workInfoHomepage' => 'foaf:workInfoHomepage',
                'foaf_workplaceHomepage' => 'foaf:workplaceHomepage',
                'foaf_title' => 'foaf:title',
                'foaf_currentProject' => 'foaf:currentProject',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_created' => 'dcterms:created',
                'dcterms_type' => 'dcterms:type',
                
                // Time ontology properties
                'time_hasBeginning' => 'time:hasBeginning',
                'time_hasEnd' => 'time:hasEnd',
                'time_hasDuration' => 'time:hasDuration',
                
                // PROV properties - провенанс деятельности
                'prov_startedAtTime' => 'prov:startedAtTime',
                'prov_endedAtTime' => 'prov:endedAtTime',
                'prov_wasAssociatedWith' => 'prov:wasAssociatedWith',
                
                // Custom properties
                'ex_hasEmployer' => 'ex:hasEmployer',
                'ex_positionLevel' => 'ex:positionLevel',
                'ex_isRemoteWork' => 'ex:isRemoteWork',
                'ex_keyAchievement' => 'ex:keyAchievement'
            ]
        ];
    }

    private function getAwardsRdfaData(): array
    {
        return [
            'typeof' => 'schema:Award foaf:Document',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'awardingOrganization' => 'schema:awardingOrganization',
                'dateReceived' => 'schema:dateReceived',
                'award' => 'schema:award',
                'category' => 'schema:category',
                'recipient' => 'schema:recipient',
                'recognizingAuthority' => 'schema:recognizingAuthority',
                
                // FOAF properties
                'foaf_topic' => 'foaf:topic',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_issued' => 'dcterms:issued',
                'dcterms_publisher' => 'dcterms:publisher',
                'dcterms_type' => 'dcterms:type',
                'dcterms_subject' => 'dcterms:subject',
                
                // Custom properties
                'ex_awardValue' => 'ex:awardValue',
                'ex_awardCriteria' => 'ex:awardCriteria',
                'ex_awardCategory' => 'ex:awardCategory'
            ]
        ];
    }

    private function getOrganizationsRdfaData(): array
    {
        return [
            'typeof' => 'schema:Organization foaf:Organization org:Organization',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ org: http://www.w3.org/ns/org# dcterms: http://purl.org/dc/terms/ geo: http://www.w3.org/2003/01/geo/wgs84_pos# ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'location' => 'schema:location',
                'url' => 'schema:url',
                'sameAs' => 'schema:sameAs',
                'industry' => 'schema:industry',
                'address' => 'schema:address',
                'telephone' => 'schema:telephone',
                'email' => 'schema:email',
                'logo' => 'schema:logo',
                'foundingDate' => 'schema:foundingDate',
                'numberOfEmployees' => 'schema:numberOfEmployees',
                'parentOrganization' => 'schema:parentOrganization',
                'subOrganization' => 'schema:subOrganization',
                'department' => 'schema:department',
                'legalName' => 'schema:legalName',
                
                // FOAF properties
                'foaf_name' => 'foaf:name',
                'foaf_homepage' => 'foaf:homepage',
                'foaf_mbox' => 'foaf:mbox',
                'foaf_phone' => 'foaf:phone',
                'foaf_logo' => 'foaf:logo',
                'foaf_member' => 'foaf:member',
                
                // ORG ontology properties
                'org_classification' => 'org:classification',
                'org_purpose' => 'org:purpose',
                'org_hasPost' => 'org:hasPost',
                'org_hasMember' => 'org:hasMember',
                'org_hasPrimaryActivity' => 'org:hasPrimaryActivity',
                'org_hasSubOrganization' => 'org:hasSubOrganization',
                'org_subOrganizationOf' => 'org:subOrganizationOf',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_identifier' => 'dcterms:identifier',
                'dcterms_type' => 'dcterms:type',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_spatial' => 'dcterms:spatial',
                
                // Geo properties
                'geo_lat' => 'geo:lat',
                'geo_long' => 'geo:long',
                'geo_location' => 'geo:location'
            ]
        ];
    }

    private function getVideosRdfaData(): array
    {
        return [
            'typeof' => 'schema:VideoObject foaf:Document',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'description' => 'schema:description',
                'contentUrl' => 'schema:contentUrl',
                'embedUrl' => 'schema:embedUrl',
                'thumbnailUrl' => 'schema:thumbnailUrl',
                'uploadDate' => 'schema:uploadDate',
                'duration' => 'schema:duration',
                'encodingFormat' => 'schema:encodingFormat',
                'width' => 'schema:width',
                'height' => 'schema:height',
                'bitrate' => 'schema:bitrate',
                'videoFrameSize' => 'schema:videoFrameSize',
                'videoQuality' => 'schema:videoQuality',
                'inLanguage' => 'schema:inLanguage',
                'caption' => 'schema:caption',
                'transcript' => 'schema:transcript',
                'creator' => 'schema:creator',
                'producer' => 'schema:producer',
                'director' => 'schema:director',
                'about' => 'schema:about',
                'genre' => 'schema:genre',
                'keywords' => 'schema:keywords',
                
                // FOAF properties
                'foaf_topic' => 'foaf:topic',
                'foaf_homepage' => 'foaf:homepage',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_creator' => 'dcterms:creator',
                'dcterms_created' => 'dcterms:created',
                'dcterms_modified' => 'dcterms:modified',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_type' => 'dcterms:type',
                'dcterms_format' => 'dcterms:format',
                'dcterms_language' => 'dcterms:language',
                'dcterms_identifier' => 'dcterms:identifier'
            ]
        ];
    }

    private function getPublicationsRdfaData(): array
    {
        return [
            'typeof' => 'schema:ScholarlyArticle foaf:Document',
            'prefix' => 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'name' => 'schema:name',
                'headline' => 'schema:headline',
                'description' => 'schema:description',
                'abstract' => 'schema:abstract',
                'author' => 'schema:author',
                'creator' => 'schema:creator',
                'editor' => 'schema:editor',
                'contributor' => 'schema:contributor',
                'datePublished' => 'schema:datePublished',
                'dateCreated' => 'schema:dateCreated',
                'dateModified' => 'schema:dateModified',
                'isPartOf' => 'schema:isPartOf',
                'publisher' => 'schema:publisher',
                'publication' => 'schema:publication',
                'pageStart' => 'schema:pageStart',
                'pageEnd' => 'schema:pageEnd',
                'pagination' => 'schema:pagination',
                'volumeNumber' => 'schema:volumeNumber',
                'issueNumber' => 'schema:issueNumber',
                'doi' => 'schema:doi',
                'issn' => 'schema:issn',
                'isbn' => 'schema:isbn',
                'url' => 'schema:url',
                'sameAs' => 'schema:sameAs',
                'about' => 'schema:about',
                'keywords' => 'schema:keywords',
                'genre' => 'schema:genre',
                'inLanguage' => 'schema:inLanguage',
                'citation' => 'schema:citation',
                'license' => 'schema:license',
                
                // FOAF properties
                'foaf_topic' => 'foaf:topic',
                'foaf_homepage' => 'foaf:homepage',
                
                // DCterms properties
                'dcterms_title' => 'dcterms:title',
                'dcterms_description' => 'dcterms:description',
                'dcterms_creator' => 'dcterms:creator',
                'dcterms_publisher' => 'dcterms:publisher',
                'dcterms_date' => 'dcterms:date',
                'dcterms_created' => 'dcterms:created',
                'dcterms_modified' => 'dcterms:modified',
                'dcterms_issued' => 'dcterms:issued',
                'dcterms_subject' => 'dcterms:subject',
                'dcterms_type' => 'dcterms:type',
                'dcterms_format' => 'dcterms:format',
                'dcterms_language' => 'dcterms:language',
                'dcterms_identifier' => 'dcterms:identifier',
                'dcterms_relation' => 'dcterms:relation',
                'dcterms_bibliographicCitation' => 'dcterms:bibliographicCitation',
                
                // Custom properties
                'ex_doi' => 'ex:doi',
                'ex_impactFactor' => 'ex:impactFactor',
                'ex_citationCount' => 'ex:citationCount',
                'ex_publicationType' => 'ex:publicationType'
            ]
        ];
    }

    private function getAddressRdfaData(): array
    {
        return [
            'typeof' => 'schema:PostalAddress vcard:Address',
            'prefix' => 'schema: https://schema.org/ vcard: http://www.w3.org/2006/vcard/ns# geo: http://www.w3.org/2003/01/geo/wgs84_pos# dcterms: http://purl.org/dc/terms# ex: https://dmytro.example/schema#',
            'properties' => [
                // Schema.org properties
                'addressLocality' => 'schema:addressLocality',
                'addressRegion' => 'schema:addressRegion',
                'addressCountry' => 'schema:addressCountry',
                'postalCode' => 'schema:postalCode',
                'streetAddress' => 'schema:streetAddress',
                'postOfficeBoxNumber' => 'schema:postOfficeBoxNumber',
                'name' => 'schema:name',
                'description' => 'schema:description',
                
                // VCARD properties
                'vcard_locality' => 'vcard:locality',
                'vcard_region' => 'vcard:region',
                'vcard_country-name' => 'vcard:country-name',
                'vcard_postal-code' => 'vcard:postal-code',
                'vcard_street-address' => 'vcard:street-address',
                'vcard_extended-address' => 'vcard:extended-address',
                'vcard_post-office-box' => 'vcard:post-office-box',
                
                // Geographic properties
                'geo_lat' => 'geo:lat',
                'geo_long' => 'geo:long',
                'geo_location' => 'geo:location',
                
                // DCterms properties
                'dcterms_spatial' => 'dcterms:spatial',
                'dcterms_identifier' => 'dcterms:identifier',
                
                // Custom properties  
                'ex_addressType' => 'ex:addressType',
                'ex_primaryAddress' => 'ex:primaryAddress'
            ]
        ];
    }
}
