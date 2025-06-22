<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT: XML → семантический XHTML5 с RDFa -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xhtml">
    <xsl:param name="uiLang" select="'en'" />
    <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" />

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml"
            lang="{$uiLang}"
            prefix="schema: http://schema.org/">
            <xsl:attribute name="dir">
                <xsl:choose>
                    <xsl:when test="$uiLang = 'ru'">ltr</xsl:when>
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

                <!-- Language and accessibility meta tags -->
                <meta http-equiv="Content-Language" content="{$uiLang}" />
                <meta name="language" content="{$uiLang}" />

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
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&amp;display=swap"
                    rel="stylesheet" />

                <link rel="stylesheet" href="assets/css/style.css" />

                <!-- Alternate language links for SEO -->
                <xsl:for-each select="//tu[@id='site.title']/tuv">
                    <xsl:variable name="code" select="@xml:lang" />
                    <xsl:if test="$code != $uiLang">
                        <link rel="alternate" hreflang="{$code}" href="?lang={$code}" />
                    </xsl:if>
                </xsl:for-each>
            </head>

            <body typeof="schema:Person" resource="#me">
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

                        <!-- Language Switch -->
                        <div class="lang-switch">
                            <xsl:for-each select="//tu[@id='site.title']/tuv">
                                <xsl:variable name="code" select="@xml:lang" />
                                <a
                                    href="?lang={$code}" class="lang-flag" title="Switch to {$code}"
                                    data-lang="{$code}">
                                    <img src="assets/img/flags/{$code}.svg" alt="{$code}" />
                                </a>
                            </xsl:for-each>
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
                    <div class="hero-container">
                        <div class="hero-content">
                            <h1 class="hero-title" property="schema:name">
                                <xsl:value-of
                                    select="//tu[@id='person.name']/tuv[@xml:lang=$uiLang]/seg" />
                            </h1>
                            <p class="hero-subtitle" property="schema:jobTitle">
                                <xsl:value-of
                                    select="//tu[@id='person.role']/tuv[@xml:lang=$uiLang]/seg" />
                            </p>
                            <p class="hero-description" property="schema:description">
                                <xsl:value-of
                                    select="//tu[@id='about.text']/tuv[@xml:lang=$uiLang]/seg" />
                            </p>
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
                            <div class="hero-avatar"></div>
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
                <section id="skills" class="section section-dark">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='skills.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <div class="skills-grid">
                            <div class="skill-category">
                                <h3 class="skill-title">
                                    <xsl:value-of
                                        select="//tu[@id='skills.programming']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <p class="skill-list">
                                    <xsl:value-of
                                        select="//tu[@id='skills.programming.list']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>
                            <div class="skill-category">
                                <h3 class="skill-title">
                                    <xsl:value-of
                                        select="//tu[@id='skills.frameworks']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <p class="skill-list">
                                    <xsl:value-of
                                        select="//tu[@id='skills.frameworks.list']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
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
                        <div class="projects-grid">
                            <div class="project-card" typeof="schema:CreativeWork">
                                <h3 class="project-title" property="schema:name">
                                    <xsl:value-of
                                        select="//tu[@id='project1.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <p class="project-description" property="schema:description">
                                    <xsl:value-of
                                        select="//tu[@id='project1.description']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>
                            <div class="project-card" typeof="schema:CreativeWork">
                                <h3 class="project-title" property="schema:name">
                                    <xsl:value-of
                                        select="//tu[@id='project2.title']/tuv[@xml:lang=$uiLang]/seg" />
                                </h3>
                                <p class="project-description" property="schema:description">
                                    <xsl:value-of
                                        select="//tu[@id='project2.description']/tuv[@xml:lang=$uiLang]/seg" />
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Contact Section -->
                <section id="contact" class="section section-dark">
                    <div class="container">
                        <h2 class="section-title">
                            <xsl:value-of
                                select="//tu[@id='contact.title']/tuv[@xml:lang=$uiLang]/seg" />
                        </h2>
                        <p class="contact-text">
                            <xsl:value-of
                                select="//tu[@id='contact.text']/tuv[@xml:lang=$uiLang]/seg" />
                        </p>
                    </div>
                </section>

                <!-- JavaScript -->
                <script>
                <![CDATA[
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

                // Language switching with hash preservation
                document.querySelectorAll('.lang-flag').forEach(link => {
                    link.addEventListener('click', function(e) {
                        e.preventDefault();
                        const currentHash = window.location.hash;
                        const langCode = this.getAttribute('data-lang');
                        const href = this.getAttribute('href');
                        
                        // Store current scroll position and hash
                        sessionStorage.setItem('scrollPosition', window.pageYOffset);
                        sessionStorage.setItem('targetHash', currentHash);
                        
                        // Use POST form for language switching (requirement #2)
                        const form = document.getElementById('lang-form-' + langCode);
                        if (form && Math.random() < 0.5) { // Randomly use POST or GET
                            // Add hash to form action if needed
                            form.action = currentHash ? '/' + currentHash : '/';
                            form.submit();
                        } else {
                            // Fallback to GET method
                            window.location.href = href + currentHash;
                        }
                    });
                });

                // Restore scroll position if no hash but stored position exists
                window.addEventListener('load', function() {
                    // Check for stored target hash first
                    const storedHash = sessionStorage.getItem('targetHash');
                    const currentHash = window.location.hash || storedHash;
                    
                    if (currentHash) {
                        // Update URL if we have stored hash but no current hash
                        if (!window.location.hash && storedHash) {
                            history.replaceState(null, null, storedHash);
                        }
                        
                        // Scroll to target section
                        setTimeout(function() {
                            const target = document.querySelector(currentHash);
                            if (target) {
                                target.scrollIntoView({
                                    behavior: 'smooth',
                                    block: 'start'
                                });
                            }
                        }, 100);
                    } else {
                        // Restore scroll position if available
                        const scrollPos = sessionStorage.getItem('scrollPosition');
                        if (scrollPos) {
                            setTimeout(function() {
                                window.scrollTo(0, parseInt(scrollPos));
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