<?php

namespace Portfolio;

final class ContentProvider
{
    private \DOMDocument $xml;

    public function __construct()
    {
        $this->xml = new \DOMDocument();
        $this->xml->load(__DIR__ . '/../data/content.xml');
        // строгая валидация: отключи в production, если хочется быстрее
        @$this->xml->schemaValidate(__DIR__ . '/../data/content.xsd');
    }

    public function getPage(string $lang): \DOMDocument
    {
        $xslDoc = new \DOMDocument();
        $xslDoc->load(__DIR__ . '/../xslt/page.xsl');
        $proc = new \XSLTProcessor();
        $proc->importStylesheet($xslDoc);
        $proc->setParameter('', 'uiLang', $lang);
        return $proc->transformToDoc($this->xml);
    }
}
