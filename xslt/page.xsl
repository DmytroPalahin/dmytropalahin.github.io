<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT: XML → семантический XHTML5 с RDFa -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xhtml">
    <xsl:param name="uiLang" select="'en'" />
    <xsl:param name="rdfaPersonVocab" select="'https://schema.org/'" />
    <xsl:param name="rdfaPersonType" select="'Person'" />
    <xsl:output method="html"
        omit-xml-declaration="yes"
        indent="yes"
        encoding="UTF-8" />

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;
</xsl:text><html lang="{$uiLang}">
            <xsl:attribute name="dir">
                <xsl:choose>
                    <xsl:when test="$uiLang = 'ru'">ltr</xsl:when>
                    <xsl:when test="$uiLang = 'uk'">ltr</xsl:when>
                    <xsl:otherwise>ltr</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta name="description"
                    content="{//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg}" />
                <meta name="keywords"
                    content="Dmytro Palahin, Full-Stack Developer, Data Engineer, Portfolio" />
                <meta name="author" content="{//tu[@id='person.name']/tuv[@xml:lang=$uiLang]/seg}" />
                <meta name="robots" content="index, follow" />

                <!-- Open Graph / Facebook -->
                <meta property="og:type" content="website" />
                <meta property="og:title"
                    content="{//tu[@id='site.title']/tuv[@xml:lang=$uiLang]/seg}" />
                <meta property="og:description"
                    content="{//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg}" />
                <meta property="og:locale" content="{$uiLang}" />

                <!-- Twitter -->
                <meta property="twitter:card" content="summary_large_image" />
                <meta property="twitter:title"
                    content="{//tu[@id='site.title']/tuv[@xml:lang=$uiLang]/seg}" />
                <meta property="twitter:description"
                    content="{//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg}" />

                <title>
                    <xsl:value-of select="//tu[@id='site.title']/tuv[@xml:lang=$uiLang]/seg" />
                </title>

                <!-- Preload fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&amp;display=swap"
                    rel="stylesheet" />

                <link rel="stylesheet" href="assets/css/style.css" />

                <!-- Custom styles for language selector hover effects -->
                <style>
                <![CDATA[
                /* Language selector hover effects */
                .language-option {
                    position: relative;
                    padding: 8px 16px;
                    border-radius: 6px;
                    color: rgba(255, 255, 255, 0.8);
                    text-decoration: none;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    font-weight: 500;
                    font-size: 14px;
                    letter-spacing: 0.5px;
                }

                /* Hover effect - приглушенный синий без линии */
                .language-option:hover:not(.active) {
                    background-color: rgba(59, 130, 246, 0.15);
                    color: rgba(147, 197, 253, 0.9);
                    transform: translateX(2px);
                    backdrop-filter: blur(8px);
                }

                /* Active state - яркая синяя линия слева */
                .language-option.active {
                    background-color: rgba(59, 130, 246, 0.1);
                    color: rgba(147, 197, 253, 1);
                    font-weight: 600;
                }

                .language-option.active::before {
                    content: '';
                    position: absolute;
                    left: 0;
                    top: 50%;
                    transform: translateY(-50%);
                    width: 3px;
                    height: 16px;
                    background: linear-gradient(135deg, #3b82f6, #60a5fa);
                    border-radius: 0 2px 2px 0;
                    box-shadow: 0 0 8px rgba(59, 130, 246, 0.3);
                }

                /* Smooth dropdown animation */
                .language-dropdown {
                    transform: translateY(-10px);
                    opacity: 0;
                    visibility: hidden;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                }

                .language-dropdown.open {
                    transform: translateY(0);
                    opacity: 1;
                    visibility: visible;
                }

                /* Language toggle button hover */
                .language-toggle:hover {
                    background-color: rgba(255, 255, 255, 0.1);
                    transform: scale(1.05);
                }

                .language-toggle:hover .language-icon {
                    color: rgba(147, 197, 253, 0.9);
                }
                ]]>
                </style>

                <!-- Alternate language links for SEO -->
                <xsl:for-each select="//tu[@id='site.title']/tuv">
                    <xsl:variable name="code" select="@xml:lang" />
                    <xsl:if test="$code != $uiLang">
                        <link rel="alternate" hreflang="{$code}" href="?lang={$code}" />
                    </xsl:if>
                </xsl:for-each>
            </head>

            <body>
                <!-- Navigation Bar -->
                <nav class="navbar" id="navbar">
                    <div class="nav-container">
                        <div class="nav-logo">
                            <xsl:value-of
                                select="//tu[@id='person.name']/tuv[@xml:lang=$uiLang]/seg" />
                        </div>

                        <!-- Navigation Menu -->
                        <ul class="nav-menu" id="nav-menu">
                            <li class="nav-item">
                                <a href="#home" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='nav.home']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#about" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='about.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#skills" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='skills.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#experience" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='experience.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#education" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='education.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#projects" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='projects.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#contact" class="nav-link">
                                    <xsl:value-of
                                        select="//tu[@id='contact.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </li>
                        </ul>

                        <!-- Modern Language Switch -->
                        <div class="language-selector">
                            <button class="language-toggle" id="language-toggle" type="button"
                                aria-label="Change language">
                                <svg class="language-icon" width="20" height="20"
                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="m5 8 6 6"></path>
                                    <path d="m4 14 6-6 2-3"></path>
                                    <path d="M2 5h12"></path>
                                    <path d="M7 2h1"></path>
                                    <path d="m22 22-5-10-5 10"></path>
                                    <path d="M14 18h6"></path>
                                </svg>
                            </button>
                            <div class="language-dropdown" id="language-dropdown">
                                <div class="language-dropdown-content">
                                    <!-- English -->
                                    <a href="?lang=en" class="language-option" data-lang="en">
                                        <xsl:if test="$uiLang = 'en'">
                                            <xsl:attribute name="class">language-option active</xsl:attribute>
                                        </xsl:if>
        EN </a>
                                    <!-- French -->
                                    <a href="?lang=fr" class="language-option" data-lang="fr">
                                        <xsl:if test="$uiLang = 'fr'">
                                            <xsl:attribute name="class">language-option active</xsl:attribute>
                                        </xsl:if>
        FR </a>
                                    <!-- Ukrainian -->
                                    <a href="?lang=uk" class="language-option" data-lang="uk">
                                        <xsl:if test="$uiLang = 'uk'">
                                            <xsl:attribute name="class">language-option active</xsl:attribute>
                                        </xsl:if>
        UA </a>
                                    <!-- Russian -->
                                    <a href="?lang=ru" class="language-option" data-lang="ru">
                                        <xsl:if test="$uiLang = 'ru'">
                                            <xsl:attribute name="class">language-option active</xsl:attribute>
                                        </xsl:if>
        RU </a>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden POST forms for language switching (requirement #2) -->
                        <div style="display: none;">
                            <xsl:for-each select="//tu[@id='site.title']/tuv">
                                <xsl:variable name="code" select="@xml:lang" />
                                <form method="post"
                                    id="lang-form-{$code}">
                                    <input type="hidden" name="lang" value="{$code}" />
                                </form>
                            </xsl:for-each>
                        </div>

                        <!-- Mobile Menu Toggle -->
                        <div class="nav-toggle" id="mobile-menu">
                            <span class="bar"></span>
                            <span class="bar"></span>
                            <span class="bar"></span>
                        </div>
                    </div>
                </nav>

                <!-- Hero Section -->
                <section id="home" class="hero-section">
                    <div class="hero-container" vocab="{$rdfaPersonVocab}"
                        typeof="{$rdfaPersonType}">
                        <div class="hero-content">
                            <div class="hero-greeting">
                                <span class="greeting-text">
                                    <xsl:value-of
                                        select="//tu[@id='person.greeting']/tuv[@xml:lang=$uiLang]/seg" />
                                </span>
                                <img src="assets/img/animations/waving-hand.gif"
                                    alt="Waving hand"
                                    class="waving-hand" />
                            </div>
                            <h1 class="hero-title" property="name">
                                <xsl:value-of
                                    select="//tu[@id='person.name']/tuv[@xml:lang=$uiLang]/seg" />
                            </h1>
                            <p class="hero-subtitle" property="jobTitle">
                                <xsl:value-of
                                    select="//tu[@id='person.role']/tuv[@xml:lang=$uiLang]/seg" />
                            </p>
                            <p class="hero-description" property="description">
                                <xsl:value-of
                                    select="//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg" />
                            </p>

                            <!-- Hidden Contact Information with RDFa -->
                            <span property="email" style="display: none;">
                                <xsl:value-of
                                    select="//tu[@id='contact.social.email']/tuv[@xml:lang=$uiLang]/seg" />
                            </span>
                            <span property="telephone" style="display: none;">
                                <xsl:value-of
                                    select="//tu[@id='contact.social.phone']/tuv[@xml:lang=$uiLang]/seg" />
                            </span>
                            <span property="nationality" style="display: none;">Ukrainian</span>

                            <!-- Address Information -->
                            <div property="address" typeof="PostalAddress" style="display: none;">
                                <span property="addressLocality">Paris</span>
                                <span property="addressCountry">France</span>
                            </div>

                            <!-- CTA Buttons -->
                            <div class="hero-buttons">
                                <a href="#contact" class="btn btn-primary">
                                    <xsl:value-of
                                        select="//tu[@id='contact.cta']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                                <a href="#about" class="btn btn-secondary">
                                    <xsl:value-of
                                        select="//tu[@id='about.cta']/tuv[@xml:lang=$uiLang]/seg" />
                                </a>
                            </div>
                        </div>
                        <div class="hero-image">
                            <img src="assets/img/memoji.png"
                                alt="Dmytro Palahin"
                                class="hero-avatar"
                                property="image" />
                        </div>
                    </div>
                </section>

                <!-- About Section -->
                <section id="about" class="section">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='about.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="about-content">
                            <div class="about-text">
                                <p property="schema:description">
                                    <xsl:value-of
                                        select="//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Skills Section -->
                <section id="skills" class="section section-dark" vocab="{$rdfaPersonVocab}"
                    typeof="{$rdfaPersonType}">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='skills.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="skills-grid" property="knowsAbout">
                            <div class="skill-category">
                                <h3 class="skill-title">
                                    <xsl:value-of
                                        select="//tu[@id='skills.programming']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <div class="skill-items">
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">Python</span>
                                        <span class="skill-level" property="skillLevel">Expert</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">JavaScript</span>
                                        <span class="skill-level" property="skillLevel">Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">SQL</span>
                                        <span class="skill-level" property="skillLevel">Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">PHP</span>
                                        <span class="skill-level" property="skillLevel">Intermediate</span>
                                    </div>
                                </div>
                            </div>
                            <div class="skill-category">
                                <h3 class="skill-title">
                                    <xsl:value-of
                                        select="//tu[@id='skills.frameworks']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <div class="skill-items">
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">Apache Spark</span>
                                        <span class="skill-level" property="skillLevel">Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">Kedro</span>
                                        <span class="skill-level" property="skillLevel">Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">MLflow</span>
                                        <span class="skill-level" property="skillLevel">Intermediate</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">Docker</span>
                                        <span class="skill-level" property="skillLevel">Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="DefinedTerm">
                                        <span property="name">React</span>
                                        <span class="skill-level" property="skillLevel">Intermediate</span>
                                    </div>
                                </div>
                            </div>
                            <div class="skill-category">
                                <h3 class="skill-title">Languages</h3>
                                <div class="skill-items" property="knowsLanguage">
                                    <div class="skill-item" typeof="Language">
                                        <span property="name">Ukrainian</span>
                                        <span class="skill-level" property="proficiencyLevel">Native</span>
                                    </div>
                                    <div class="skill-item" typeof="Language">
                                        <span property="name">Russian</span>
                                        <span class="skill-level" property="proficiencyLevel">Native</span>
                                    </div>
                                    <div class="skill-item" typeof="Language">
                                        <span property="name">English</span>
                                        <span class="skill-level" property="proficiencyLevel">
        Advanced</span>
                                    </div>
                                    <div class="skill-item" typeof="Language">
                                        <span property="name">French</span>
                                        <span class="skill-level" property="proficiencyLevel">
        Intermediate</span>
                                    </div>
                                    <div class="skill-item" typeof="Language">
                                        <span property="name">German</span>
                                        <span class="skill-level" property="proficiencyLevel">
        Beginner</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>                <!--
                Experience Section -->
                <section id="experience" class="section">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='experience.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="experience-container">
                            <!-- Current Experience -->
                            <div class="experience-card">
                                <div class="experience-header">
                                    <h3 class="experience-company">
                                        <xsl:value-of
                                            select="//tu[@id='experience.current.title']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                    <span class="experience-duration">
                                        <xsl:value-of
                                            select="//tu[@id='experience.current.period']/tuv[@xml:lang=$uiLang]/seg" />
                                    </span>
                                </div>
                                <h4 class="experience-position">
                                    <xsl:value-of
                                        select="//tu[@id='experience.current.role']/tuv[@xml:lang=$uiLang]/seg" />
                                </h4>
                                <ul class="experience-description">
                                    <li>
                                        <xsl:value-of
                                            select="//tu[@id='experience.current.task1']/tuv[@xml:lang=$uiLang]/seg" />
                                    </li>
                                    <li>
                                        <xsl:value-of
                                            select="//tu[@id='experience.current.task2']/tuv[@xml:lang=$uiLang]/seg" />
                                    </li>
                                    <li>
                                        <xsl:value-of
                                            select="//tu[@id='experience.current.task3']/tuv[@xml:lang=$uiLang]/seg" />
                                    </li>
                                </ul>
                                <div class="experience-tech">
                                    <strong>Technologies: </strong>
                                    <xsl:value-of
                                        select="//tu[@id='experience.current.technologies']/tuv[@xml:lang=$uiLang]/seg" />
                                </div>
                            </div>

                            <!-- Course 2021 -->
                            <div class="experience-card">
                                <div class="experience-header">
                                    <h3 class="experience-company">
                                        <xsl:value-of
                                            select="//tu[@id='experience.course2021.title']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                    <span class="experience-duration">
                                        <xsl:value-of
                                            select="//tu[@id='experience.course2021.period']/tuv[@xml:lang=$uiLang]/seg" />
                                    </span>
                                </div>
                                <div class="experience-tech">
                                    <strong>Technologies: </strong>
                                    <xsl:value-of
                                        select="//tu[@id='experience.course2021.technologies']/tuv[@xml:lang=$uiLang]/seg" />
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- Education Section -->
                <section id="education" class="section section-dark">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='education.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="education-container">
                            <!-- Current Education -->
                            <div class="education-card">
                                <div class="education-header">
                                    <h3 class="education-school">
                                        <xsl:value-of
                                            select="//tu[@id='education.current.institution']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                    <span class="education-duration">
                                        <xsl:value-of
                                            select="//tu[@id='education.current.period']/tuv[@xml:lang=$uiLang]/seg" />
                                    </span>
                                </div>
                                <h4 class="education-degree">
                                    <xsl:value-of
                                        select="//tu[@id='education.current.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </h4>
                            </div>

                            <!-- Preparatory -->
                            <div class="education-card">
                                <div class="education-header">
                                    <h3 class="education-school">
                                        <xsl:value-of
                                            select="//tu[@id='education.preparatory.institution']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                    <span class="education-duration">
                                        <xsl:value-of
                                            select="//tu[@id='education.preparatory.period']/tuv[@xml:lang=$uiLang]/seg" />
                                    </span>
                                </div>
                                <h4 class="education-degree">
                                    <xsl:value-of
                                        select="//tu[@id='education.preparatory.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </h4>
                            </div>

                            <!-- High School -->
                            <div class="education-card">
                                <div class="education-header">
                                    <h3 class="education-school">
                                        <xsl:value-of
                                            select="//tu[@id='education.highschool.institution']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                    <span class="education-duration">
                                        <xsl:value-of
                                            select="//tu[@id='education.highschool.period']/tuv[@xml:lang=$uiLang]/seg" />
                                    </span>
                                </div>
                                <h4 class="education-degree">
                                    <xsl:value-of
                                        select="//tu[@id='education.highschool.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </h4>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Projects Section -->
                <section id="projects" class="section">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='projects.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="projects-container">
                            <div class="project-card" typeof="schema:CreativeWork">
                                <div class="project-header">
                                    <h3 class="project-name" property="schema:name">
                                        <xsl:value-of
                                            select="//tu[@id='project1.title']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                </div>
                                <p class="project-description" property="schema:description">
                                    <xsl:value-of
                                        select="//tu[@id='project1.description']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>

                            <div class="project-card" typeof="schema:CreativeWork">
                                <div class="project-header">
                                    <h3 class="project-name" property="schema:name">
                                        <xsl:value-of
                                            select="//tu[@id='project2.title']/tuv[@xml:lang=$uiLang]/seg" />
                                    </h3>
                                </div>
                                <p class="project-description" property="schema:description">
                                    <xsl:value-of
                                        select="//tu[@id='project2.description']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Contact Section -->
                <section id="contact" class="section section-dark" vocab="https://schema.org/"
                    typeof="Person">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='contact.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <p class="contact-text">
                            <xsl:value-of
                                select="//tu[@id='contact.text']/tuv[@xml:lang=$uiLang]/seg" />
                        </p>

                        <!-- Contact Cards Grid -->
                        <div class="contact-grid">
                            <!-- Email -->
                            <div class="contact-card">
                                <div class="contact-icon email">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor">
                                        <rect x="2" y="4" width="20" height="16" rx="2" />
                                        <path d="m2 7 10 5 10-5" />
                                    </svg>
                                </div>
                                <div class="contact-info">
                                    <h3 class="contact-label">Email</h3>
                                    <a
                                        href="mailto:{//tu[@id='contact.social.email']/tuv[@xml:lang=$uiLang]/seg}"
                                        class="contact-value" property="email">
                                        <xsl:value-of
                                            select="//tu[@id='contact.social.email']/tuv[@xml:lang=$uiLang]/seg" />
                                    </a>
                                </div>
                            </div>

                            <!-- GitHub -->
                            <div class="contact-card">
                                <div class="contact-icon github">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor">
                                        <path
                                            d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22" />
                                    </svg>
                                </div>
                                <div class="contact-info">
                                    <h3 class="contact-label">GitHub</h3>
                                    <a
                                        href="https://{//tu[@id='contact.social.github']/tuv[@xml:lang=$uiLang]/seg}"
                                        class="contact-value" property="sameAs" target="_blank"
                                        rel="noopener">
                                        <xsl:value-of
                                            select="//tu[@id='contact.social.github']/tuv[@xml:lang=$uiLang]/seg" />
                                    </a>
                                </div>
                            </div>

                            <!-- LinkedIn -->
                            <div class="contact-card">
                                <div class="contact-icon linkedin">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor">
                                        <path
                                            d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z" />
                                        <rect x="2" y="9" width="4" height="12" />
                                        <circle cx="4" cy="4" r="2" />
                                    </svg>
                                </div>
                                <div class="contact-info">
                                    <h3 class="contact-label">LinkedIn</h3>
                                    <a
                                        href="https://{//tu[@id='contact.social.linkedin']/tuv[@xml:lang=$uiLang]/seg}"
                                        class="contact-value" property="sameAs" target="_blank"
                                        rel="noopener">
                                        <xsl:value-of
                                            select="//tu[@id='contact.social.linkedin']/tuv[@xml:lang=$uiLang]/seg" />
                                    </a>
                                </div>
                            </div>

                            <!-- Telegram -->
                            <div class="contact-card">
                                <div class="contact-icon telegram">
                                    <svg width="24" height="24" viewBox="0 0 24 24"
                                        fill="currentColor">
                                        <path
                                            d="M11.944 0C5.345 0 0 5.345 0 11.944c0 6.599 5.345 11.944 11.944 11.944 6.599 0 11.944-5.345 11.944-11.944C23.888 5.345 18.543 0 11.944 0zm5.205 8.043l-1.412 6.639c-.106.472-.392.59-.796.367l-2.197-1.619-1.06 1.02c-.117.117-.216.216-.443.216l.158-2.254 4.09-3.696c.177-.158-.04-.246-.276-.088l-5.06 3.186-2.186-.684c-.475-.148-.484-.475.099-.702l8.533-3.28c.395-.151.743.089.611.711z" />
                                    </svg>
                                </div>
                                <div class="contact-info">
                                    <h3 class="contact-label">Telegram</h3>
                                    <a
                                        href="https://t.me/{substring-after(//tu[@id='contact.social.telegram']/tuv[@xml:lang=$uiLang]/seg, '@')}"
                                        class="contact-value" target="_blank" rel="noopener">
                                        <xsl:value-of
                                            select="//tu[@id='contact.social.telegram']/tuv[@xml:lang=$uiLang]/seg" />
                                    </a>
                                </div>
                            </div>

                            <!-- Phone -->
                            <div class="contact-card">
                                <div class="contact-icon phone">
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                        stroke="currentColor">
                                        <path
                                            d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
                                    </svg>
                                </div>
                                <div class="contact-info">
                                    <h3 class="contact-label">Phone</h3>
                                    <a
                                        href="tel:{//tu[@id='contact.social.phone']/tuv[@xml:lang=$uiLang]/seg}"
                                        class="contact-value" property="telephone">
                                        <xsl:value-of
                                            select="//tu[@id='contact.social.phone']/tuv[@xml:lang=$uiLang]/seg" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- JavaScript -->
                <script>
                <![CDATA[
                // Interactive waving hand
                document.addEventListener('DOMContentLoaded', function() {
                    const wavingHand = document.querySelector('.waving-hand');
                    if (wavingHand) {
                        wavingHand.addEventListener('click', function() {
                            this.classList.add('active-wave');
                            setTimeout(() => {
                                this.classList.remove('active-wave');
                            }, 600);
                        });
                    }
                    
                    // Modern language selector
                    const languageToggle = document.getElementById('language-toggle');
                    const languageDropdown = document.getElementById('language-dropdown');
                    
                    if (languageToggle && languageDropdown) {
                        languageToggle.addEventListener('click', function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                            
                            const isOpen = languageDropdown.classList.contains('open');
                            if (isOpen) {
                                languageDropdown.classList.remove('open');
                                languageToggle.setAttribute('aria-expanded', 'false');
                            } else {
                                languageDropdown.classList.add('open');
                                languageToggle.setAttribute('aria-expanded', 'true');
                            }
                        });
                        
                        // Close dropdown when clicking outside
                        document.addEventListener('click', function(e) {
                            if (!languageToggle.contains(e.target) && !languageDropdown.contains(e.target)) {
                                languageDropdown.classList.remove('open');
                                languageToggle.setAttribute('aria-expanded', 'false');
                            }
                        });
                        
                        // Enhanced language switching with smooth transitions
                        const languageOptions = document.querySelectorAll('.language-option');
                        languageOptions.forEach(option => {
                            option.addEventListener('click', function(e) {
                                e.preventDefault();
                                
                                const href = this.getAttribute('href');
                                const langCode = this.getAttribute('data-lang');
                                const currentHash = window.location.hash;
                                
                                // Store current position for smooth transition
                                const currentScrollY = window.pageYOffset;
                                sessionStorage.setItem('scrollPosition', currentScrollY);
                                sessionStorage.setItem('targetHash', currentHash);
                                sessionStorage.setItem('preventScrollRestore', 'true');
                                sessionStorage.setItem('langChanged', 'true');
                                
                                // Show loading animation
                                showLanguageLoader(langCode);
                                
                                // Close dropdown
                                languageDropdown.classList.remove('open');
                                languageToggle.setAttribute('aria-expanded', 'false');
                                
                                // Modern page transition with blur and fade effects
                                document.body.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)';
                                document.body.style.opacity = '0.3';
                                document.body.style.filter = 'blur(2px)';
                                document.body.style.transform = 'scale(0.98)';
                                
                                setTimeout(() => {
                                    window.location.href = href + currentHash;
                                }, 200);
                            });
                        });
                    }
                });

                // Language switching functions
                function showLanguageLoader(langCode) {
                    const loader = document.getElementById('language-loader');
                    const loaderText = document.getElementById('loader-text');
                    const langNames = {
                        'en': 'English',
                        'fr': 'Français', 
                        'uk': 'Українська',
                        'ru': 'Русский'
                    };
                    
                    if (loader && loaderText) {
                        loaderText.textContent = `Switching to ${langNames[langCode] || langCode}...`;
                        loader.classList.add('active');
                    }
                    document.body.classList.add('lang-switching');
                }

                function showLanguageIndicator(langCode) {
                    const indicator = document.getElementById('lang-indicator');
                    const langData = {
                        'en': { flag: '\u{1F1FA}\u{1F1F8}', name: 'English' },
                        'fr': { flag: '\u{1F1EB}\u{1F1F7}', name: 'Français' }, 
                        'uk': { flag: '\u{1F1FA}\u{1F1E6}', name: 'Українська' },
                        'ru': { flag: '\u{1F1F7}\u{1F1FA}', name: 'Русский' }
                    };
                    
                    if (indicator) {
                        const data = langData[langCode] || { flag: '', name: langCode };
                        indicator.innerHTML = `<span class="flag-emoji">${data.flag}</span> <span class="lang-name">${data.name}</span>`;
                        indicator.classList.add('show');
                        
                        setTimeout(() => {
                            indicator.classList.remove('show');
                        }, 2500);
                    }
                }

                // Smooth scrolling navigation with hash preservation
                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                    anchor.addEventListener('click', function (e) {
                        e.preventDefault();
                        const target = document.querySelector(this.getAttribute('href'));
                        if (target) {
                            target.scrollIntoView({
                                behavior: 'smooth',
                                block: 'start'
                            });
                            // Update URL hash without jumping
                            history.pushState(null, null, this.getAttribute('href'));
                        }
                    });
                });

                // Active navigation highlighting
                function updateActiveNav() {
                    const sections = document.querySelectorAll('section[id]');
                    const navLinks = document.querySelectorAll('.nav-link');
                    
                    let currentSection = '';
                    sections.forEach(section => {
                        const sectionTop = section.offsetTop - 100;
                        const sectionHeight = section.offsetHeight;
                        if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
                            currentSection = section.getAttribute('id');
                        }
                    });
                    
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === '#' + currentSection) {
                            link.classList.add('active');
                        }
                    });
                }

                window.addEventListener('scroll', updateActiveNav);
                window.addEventListener('load', updateActiveNav);
                window.addEventListener('hashchange', function() {
                    updateActiveNav();
                    updateAlternateLinks();
                });

                // Navbar background on scroll
                window.addEventListener('scroll', function() {
                    const navbar = document.getElementById('navbar');
                    if (window.scrollY > 50) {
                        navbar.classList.add('scrolled');
                    } else {
                        navbar.classList.remove('scrolled');
                    }
                });

                // Mobile menu toggle
                const mobileMenu = document.getElementById('mobile-menu');
                const navMenu = document.getElementById('nav-menu');
                
                if (mobileMenu && navMenu) {
                    mobileMenu.addEventListener('click', function() {
                        navMenu.classList.toggle('active');
                        mobileMenu.classList.toggle('active');
                    });
                }

                // Language switching with hash preservation (smooth, no jumping)
                document.querySelectorAll('.lang-flag').forEach(link => {
                    link.addEventListener('click', function(e) {
                        e.preventDefault();
                        
                        const currentHash = window.location.hash;
                        const langCode = this.getAttribute('data-lang');
                        const href = this.getAttribute('href');
                        
                        // Add class to prevent any visual jumps
                        document.body.classList.add('lang-switching');
                        
                        // Store scroll position and hash for restoration
                        const currentScrollY = window.pageYOffset;
                        sessionStorage.setItem('scrollPosition', currentScrollY);
                        sessionStorage.setItem('targetHash', currentHash);
                        sessionStorage.setItem('preventScrollRestore', 'true');
                        
                        // Redirect with current hash preserved
                        window.location.href = href + currentHash;
                    });
                });

                // Restore scroll position (instant, no jumping)
                window.addEventListener('load', function() {
                    // Remove any language switching class immediately
                    document.body.classList.remove('lang-switching');
                    
                    const preventScrollRestore = sessionStorage.getItem('preventScrollRestore');
                    const storedHash = sessionStorage.getItem('targetHash');
                    const storedScrollPos = sessionStorage.getItem('scrollPosition');
                    const currentHash = window.location.hash || storedHash;
                    
                    if (preventScrollRestore === 'true') {
                        // Disable smooth scrolling temporarily for instant restoration
                        const originalScrollBehavior = document.documentElement.style.scrollBehavior;
                        document.documentElement.style.scrollBehavior = 'auto';
                        
                        if (currentHash) {
                            // Update URL hash without scrolling
                            if (!window.location.hash && storedHash) {
                                history.replaceState(null, null, storedHash);
                            }
                            
                            // Find target and scroll instantly
                            const target = document.querySelector(currentHash);
                            if (target) {
                                target.scrollIntoView({ block: 'start' });
                            }
                        } else if (storedScrollPos) {
                            // Restore exact scroll position instantly
                            window.scrollTo(0, parseInt(storedScrollPos));
                        }
                        
                        // Restore smooth scrolling after a brief delay
                        setTimeout(() => {
                            document.documentElement.style.scrollBehavior = originalScrollBehavior;
                        }, 100);
                        
                        // Clear the flag
                        sessionStorage.removeItem('preventScrollRestore');
                    } else {
                        // Normal hash scrolling for direct navigation
                        if (currentHash) {
                            setTimeout(function() {
                                const target = document.querySelector(currentHash);
                                if (target) {
                                    target.scrollIntoView({
                                        behavior: 'smooth',
                                        block: 'start'
                                    });
                                }
                            }, 100);
                        }
                    }
                    
                    // Clear stored values
                    sessionStorage.removeItem('scrollPosition');
                    sessionStorage.removeItem('targetHash');
                    
                    // Update alternate links and navigation
                    updateAlternateLinks();
                    updateActiveNav();
                });

                // Function to update alternate links (defined in head)
                function updateAlternateLinks() {
                    const currentHash = window.location.hash;
                    const alternateLinks = document.querySelectorAll('link[rel="alternate"]');
                    alternateLinks.forEach(link => {
                        const href = link.getAttribute('href');
                        const baseHref = href.split('#')[0];
                        link.setAttribute('href', baseHref + currentHash);
                    });
                }
                ]]>
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>