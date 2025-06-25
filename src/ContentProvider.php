<?php

namespace Portfolio;

final class ContentProvider
{
    private \DOMDocument $xml;
    private RdfProvider $rdfProvider;

    public function __construct()
    {
        $this->xml = new \DOMDocument();
        $this->xml->load(__DIR__ . '/../data/content.xml');
        // строгая валидация: отключи в production, если хочется быстрее
        @$this->xml->schemaValidate(__DIR__ . '/../data/content.xsd');
        $this->rdfProvider = new RdfProvider();
    }

    public function getPage(string $lang): \DOMDocument
    {
        $xslDoc = new \DOMDocument();
        $xslDoc->load(__DIR__ . '/../xslt/page.xsl');
        $proc = new \XSLTProcessor();
        $proc->importStylesheet($xslDoc);
        $proc->setParameter('', 'uiLang', $lang);
        
        // Передаем RDFa данные как параметры с расширенными словарями
        $rdfaData = $this->rdfProvider->getRdfaData();
        
        // Основные префиксы для всех словарей
        $proc->setParameter('', 'rdfaPrefix', 'schema: https://schema.org/ foaf: http://xmlns.com/foaf/0.1/ dcterms: http://purl.org/dc/terms/ vcard: http://www.w3.org/2006/vcard/ns# org: http://www.w3.org/ns/org# time: http://www.w3.org/2006/time# geo: http://www.w3.org/2003/01/geo/wgs84_pos# skos: http://www.w3.org/2004/02/skos/core# prov: http://www.w3.org/ns/prov# ex: https://dmytro.example/schema#');
        
        // Основная персона с множественными типами
        $proc->setParameter('', 'rdfaPersonVocab', $rdfaData['person']['vocab']);
        $proc->setParameter('', 'rdfaPersonType', $rdfaData['person']['typeof']);
        $proc->setParameter('', 'rdfaPersonPrefix', $rdfaData['person']['prefix'] ?? '');
        
        // Секции с богатой семантической разметкой
        $proc->setParameter('', 'rdfaSkillsType', $rdfaData['skills']['typeof'] ?? 'schema:DefinedTerm skos:Concept');
        $proc->setParameter('', 'rdfaProjectsType', $rdfaData['projects']['typeof'] ?? 'schema:CreativeWork foaf:Project prov:Activity');
        $proc->setParameter('', 'rdfaEducationType', $rdfaData['education']['typeof'] ?? 'schema:EducationalOccupationalCredential schema:Course foaf:Organization');
        $proc->setParameter('', 'rdfaWorkExperienceType', $rdfaData['workExperience']['typeof'] ?? 'schema:WorkExperience org:Membership prov:Activity');
        $proc->setParameter('', 'rdfaAwardType', $rdfaData['awards']['typeof'] ?? 'schema:Award foaf:Document');
        $proc->setParameter('', 'rdfaOrganizationType', $rdfaData['organizations']['typeof'] ?? 'schema:Organization foaf:Organization org:Organization');
        $proc->setParameter('', 'rdfaVideoType', $rdfaData['videos']['typeof'] ?? 'schema:VideoObject foaf:Document');
        $proc->setParameter('', 'rdfaPublicationType', $rdfaData['publications']['typeof'] ?? 'schema:ScholarlyArticle foaf:Document');
        $proc->setParameter('', 'rdfaAddressType', $rdfaData['address']['typeof'] ?? 'schema:PostalAddress vcard:Address');
        
        // Улучшенные JSON-LD данные
        $proc->setParameter('', 'enhancedJsonLd', $this->rdfProvider->getEnhancedJsonLd());
        
        return $proc->transformToDoc($this->xml);
    }
}
