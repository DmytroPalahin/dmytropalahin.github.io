# Multilingual Portfolio (XML + XSLT + RDFa + SPARQL)

Demo portfolio for Sup Galilée “Web sémantique” course.  
*Languages*: English / Français / Русский.

## Tech stack

- PHP 8.1 (mini-MVC, no framework)
- XML (TM X) + XSD validation
- XSLT 1.0 ⟶ XHTML5 + RDFa (schema.org)
- RDF/RDFS in Turtle
- SPARQL demo query
- Plain CSS, no build-step

Run locally:

```bash
php -S localhost:8000 -t public

http://localhost:8000
```

```bash
lsof -i :8000

kill -9 <PID>
```
