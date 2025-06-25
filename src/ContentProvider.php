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
        
        // Передаем RDFa данные как параметры
        $rdfaData = $this->rdfProvider->getRdfaData();
        $proc->setParameter('', 'rdfaPersonVocab', $rdfaData['person']['vocab']);
        $proc->setParameter('', 'rdfaPersonType', $rdfaData['person']['typeof']);
        
        // Передаем дополнительные RDFa типы для богатой семантической разметки
        $proc->setParameter('', 'rdfaOrganizationType', $rdfaData['organizations']['typeof'] ?? 'Organization');
        $proc->setParameter('', 'rdfaProjectType', $rdfaData['projects']['typeof'] ?? 'CreativeWork');
        $proc->setParameter('', 'rdfaEducationType', $rdfaData['education']['typeof'] ?? 'EducationalOccupationalCredential');
        $proc->setParameter('', 'rdfaAwardType', $rdfaData['awards']['typeof'] ?? 'Award');
        $proc->setParameter('', 'rdfaVideoType', $rdfaData['videos']['typeof'] ?? 'VideoObject');
        $proc->setParameter('', 'rdfaPublicationType', $rdfaData['publications']['typeof'] ?? 'ScholarlyArticle');
        $proc->setParameter('', 'rdfaAddressType', $rdfaData['address']['typeof'] ?? 'PostalAddress');
        $proc->setParameter('', 'rdfaWorkExperienceType', $rdfaData['workExperience']['typeof'] ?? 'WorkExperience');
        $proc->setParameter('', 'rdfaSkillType', $rdfaData['skills']['typeof'] ?? 'DefinedTerm');
        
        return $proc->transformToDoc($this->xml);
    }
}
