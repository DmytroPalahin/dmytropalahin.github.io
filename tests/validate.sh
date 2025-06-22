#!/usr/bin/env bash
set -e
echo "XML schema validation…"
xmllint --noout --schema data/content.xsd data/content.xml
echo "XHTML output validation…"
php -r 'require "public/index.php";' | tidy -q -e -utf8