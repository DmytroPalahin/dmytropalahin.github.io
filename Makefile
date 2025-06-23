.PHONY: validate build clean serve schema-check

# Цвета для вывода
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[1;33m
NC = \033[0m

# Валидация XML
validate:
	@echo -e "$(BLUE)🔍 Running XML validation...$(NC)"
	@./scripts/validate.sh

# Проверка XSD схемы
schema-check:
	@echo -e "$(BLUE)📋 Checking XSD schema validity...$(NC)"
	@xmllint --schema http://www.w3.org/2001/XMLSchema.xsd data/content.xsd --noout
	@echo -e "$(GREEN)✅ XSD schema is valid$(NC)"

# Генерация HTML из XML+XSL
build: validate
	@echo -e "$(BLUE)🏗️  Building HTML from XML+XSLT...$(NC)"
	@mkdir -p dist
	@xsltproc --param uiLang "'en'" xslt/page.xsl data/content.xml > dist/index.html
	@xsltproc --param uiLang "'fr'" xslt/page.xsl data/content.xml > dist/index-fr.html
	@xsltproc --param uiLang "'ru'" xslt/page.xsl data/content.xml > dist/index-ru.html
	@xsltproc --param uiLang "'ua'" xslt/page.xsl data/content.xml > dist/index-ua.html
	@echo -e "$(GREEN)✅ Build complete: dist/index*.html$(NC)"

# Локальный сервер для тестирования
serve: build
	@echo -e "$(BLUE)🚀 Starting local server at http://localhost:8080$(NC)"
	@cd dist && python3 -m http.server 8080

# Очистка build директории
clean:
	@rm -rf dist
	@echo -e "$(YELLOW)🧹 Cleaned build directory$(NC)"

# Полная проверка: схема + XML + сборка
full-check: schema-check validate build
	@echo -e "$(GREEN)🎉 Full validation and build completed successfully!$(NC)"

# Показать статистику переводов
stats:
	@echo -e "$(BLUE)📊 Translation Statistics:$(NC)"
	@echo "Total translation units: $$(xmllint --xpath 'count(//tu)' data/content.xml)"
	@echo "English translations: $$(xmllint --xpath 'count(//tuv[@xml:lang=\"en\"])' data/content.xml)"
	@echo "French translations: $$(xmllint --xpath 'count(//tuv[@xml:lang=\"fr\"])' data/content.xml)"
	@echo "Russian translations: $$(xmllint --xpath 'count(//tuv[@xml:lang=\"ru\"])' data/content.xml)"
	@echo "Ukrainian translations: $$(xmllint --xpath 'count(//tuv[@xml:lang=\"ua\"])' data/content.xml)"

# Помощь
help:
	@echo -e "$(BLUE)Available commands:$(NC)"
	@echo "  validate      - Validate XML against XSD schema"
	@echo "  schema-check  - Validate XSD schema itself"
	@echo "  build         - Generate HTML from XML+XSLT"
	@echo "  serve         - Start local development server"
	@echo "  clean         - Clean build directory"
	@echo "  full-check    - Run all validations and build"
	@echo "  stats         - Show translation statistics"
	@echo "  help          - Show this help message"
