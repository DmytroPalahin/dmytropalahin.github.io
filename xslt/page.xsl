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
                    <xsl:when test="$uiLang = 'ua'">ltr</xsl:when>
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
                                    <a href="?lang=ua" class="language-option" data-lang="ua">
                                        <xsl:if test="$uiLang = 'ua'">
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
                    <div class="hero-container">
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
                        'ua': 'Українська',
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
                        'ua': { flag: '\u{1F1FA}\u{1F1E6}', name: 'Українська' },
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