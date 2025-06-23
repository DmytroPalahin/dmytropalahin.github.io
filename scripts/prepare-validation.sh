#!/bin/bash

# Скрипт для подготовки сайта к W3C валидации

echo "🚀 Preparing site for W3C validation..."

# Генерируем HTML файлы
echo "📄 Generating HTML files..."
mkdir -p dist
xsltproc --param uiLang "'en'" xslt/page.xsl data/content.xml > dist/index-en.html
xsltproc --param uiLang "'fr'" xslt/page.xsl data/content.xml > dist/index-fr.html
xsltproc --param uiLang "'ru'" xslt/page.xsl data/content.xml > dist/index-ru.html
xsltproc --param uiLang "'ua'" xslt/page.xsl data/content.xml > dist/index-ua.html

echo "✅ HTML files generated in dist/ folder"
echo ""
echo "📋 Validation options:"
echo "🌐 Online validation: https://validator.w3.org/"
echo "   - Upload files from dist/ folder"
echo "   - Or validate by URI after starting server"
echo ""
echo "📁 Generated files:"
ls -la dist/*.html

echo ""
echo "🔗 Ready to validate at: https://validator.w3.org/"
