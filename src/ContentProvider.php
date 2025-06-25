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
        
        return $proc->transformToDoc($this->xml);
    }
}
