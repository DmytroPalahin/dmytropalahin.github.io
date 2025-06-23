#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Validating XML against XSD schema...${NC}"

# Проверка XML валидности
if xmllint --schema data/content.xsd data/content.xml --noout 2>/dev/null; then
    echo -e "${GREEN}✅ XML is valid according to XSD schema${NC}"
else
    echo -e "${RED}❌ XML validation failed:${NC}"
    xmllint --schema data/content.xsd data/content.xml --noout
    exit 1
fi

# Проверка completeness переводов
echo -e "${BLUE}🌐 Checking translation completeness...${NC}"

# Подсчёт количества tu элементов
TU_COUNT=$(xmllint --xpath "count(//tu)" data/content.xml)
echo -e "${BLUE}Found $TU_COUNT translation units${NC}"

# Проверка каждого языка
LANGUAGES=("en" "fr" "ru" "ua")
MISSING_TRANSLATIONS=false

for LANG in "${LANGUAGES[@]}"; do
    LANG_COUNT=$(xmllint --xpath "count(//tuv[@xml:lang='$LANG'])" data/content.xml)
    if [ "$LANG_COUNT" -eq "$TU_COUNT" ]; then
        echo -e "${GREEN}✅ $LANG: $LANG_COUNT/$TU_COUNT translations${NC}"
    else
        echo -e "${YELLOW}⚠️  $LANG: $LANG_COUNT/$TU_COUNT translations (missing $(($TU_COUNT - $LANG_COUNT)))${NC}"
        MISSING_TRANSLATIONS=true
        
        # Показываем какие именно переводы отсутствуют
        echo -e "${YELLOW}   Missing translations for $LANG:${NC}"
        xmllint --xpath "//tu[not(tuv[@xml:lang='$LANG'])]/@id" data/content.xml 2>/dev/null | sed 's/id="//g' | sed 's/"//g' | tr ' ' '\n' | grep -v '^$' | sed 's/^/   - /'
    fi
done

# Проверка пустых сегментов
echo -e "${BLUE}📝 Checking for empty segments...${NC}"
EMPTY_SEGS=$(xmllint --xpath "count(//seg[not(text()) or normalize-space(text())=''])" data/content.xml)
if [ "$EMPTY_SEGS" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found $EMPTY_SEGS empty segments${NC}"
    xmllint --xpath "//seg[not(text()) or normalize-space(text())='']/../@xml:lang | //seg[not(text()) or normalize-space(text())='']/../../../@id" data/content.xml 2>/dev/null
else
    echo -e "${GREEN}✅ No empty segments found${NC}"
fi

if [ "$MISSING_TRANSLATIONS" = false ] && [ "$EMPTY_SEGS" -eq 0 ]; then
    echo -e "${GREEN}🎉 All validation checks passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Some issues found, but XML structure is valid${NC}"
fi

: <<'RUN-VALIDATE'
./scripts/validate.sh
RUN-VALIDATE
