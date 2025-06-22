<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes"
        doctype-public="-//W3C//DTD HTML 4.01//EN"
        doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

    <xsl:template match="/portfolio">
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title><xsl:value-of select="personal/name" /> - Portfolio</title>
                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&amp;display=swap"
                    rel="stylesheet" />
                <style>
                    :root {
                    --bg-primary: #ffffff;
                    --bg-secondary: #f8fafc;
                    --text-primary: #1f2937;
                    --text-secondary: #6b7280;
                    --accent-color: #2563eb;
                    --border-color: #e5e7eb;
                    --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    }

                    [data-theme="dark"] {
                    --bg-primary: #0f0f23;
                    --bg-secondary: #1a1a2e;
                    --text-primary: #e4e4e7;
                    --text-secondary: #a1a1aa;
                    --border-color: #374151;
                    }

                    * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    }

                    body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        line-height: 1.6;
                    color: var(--text-primary);
                    background: var(--bg-primary);
                    transition: var(--transition);
                    }

                    .portfolio-wrapper {
                    min-height: 100vh;
                    transition: var(--transition);
                    }

                    /* Header &amp; Navigation */
                    .header {
                    position: fixed;
                    top: 0;
                    width: 100%;
                    background: rgba(255, 255, 255, 0.95);
                    backdrop-filter: blur(10px);
                    border-bottom: 1px solid var(--border-color);
                    z-index: 1000;
                    transition: var(--transition);
                    }

                    [data-theme="dark"] .header {
                    background: rgba(15, 15, 35, 0.95);
                    }

                    .navbar {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 1rem 2rem;
                    max-width: 1200px;
                    margin: 0 auto;
                    }

                    .nav-brand h1 {
                    font-size: 1.5rem;
                    font-weight: 700;
                    background: var(--gradient);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                    }

                    .nav-menu {
                    display: flex;
                    list-style: none;
                    gap: 2rem;
                    }

                    .nav-menu a {
                    text-decoration: none;
                    color: var(--text-secondary);
                    font-weight: 500;
                    transition: var(--transition);
                    position: relative;
                    }

                    .nav-menu a:hover {
                    color: var(--accent-color);
                    }

                    .nav-menu a::after {
                    content: '';
                    position: absolute;
                    bottom: -5px;
                    left: 0;
                    width: 0;
                    height: 2px;
                    background: var(--accent-color);
                    transition: var(--transition);
                    }

                    .nav-menu a:hover::after {
                    width: 100%;
                    }

                    .nav-menu a.active {
                    color: var(--accent-color);
                    }

                    .nav-menu a.active::after {
                    width: 100%;
                    }

                    .nav-controls {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    }

                    .language-select {
                    padding: 0.5rem;
                    border: 1px solid var(--border-color);
                    border-radius: 0.5rem;
                    background: var(--bg-secondary);
                    color: var(--text-primary);
                    transition: var(--transition);
                    }

                    .theme-toggle {
                    background: none;
                    border: 1px solid var(--border-color);
                    border-radius: 50%;
                    width: 40px;
                    height: 40px;
                    cursor: pointer;
                    transition: var(--transition);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.2rem;
                    }

                    .theme-toggle:hover {
                    background: var(--bg-secondary);
                    transform: scale(1.1);
                    }

                    /* Hero Section */
                    .hero {
                    padding: 8rem 2rem 4rem;
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary)
        100%);
                    transition: opacity 0.3s ease-in-out;
                    opacity: 1;
                    }

                    .hero-content {
                    max-width: 1200px;
                    margin: 0 auto;
                    display: grid;
                    grid-template-columns: 1fr 300px;
                    gap: 4rem;
                    align-items: center;
                    }

                    .hero-title {
                    font-size: 3.5rem;
                    font-weight: 800;
                    margin-bottom: 1rem;
                    line-height: 1.1;
                    }

                    .greeting {
                    display: block;
                    font-size: 1.5rem;
                    color: var(--text-secondary);
                    font-weight: 400;
                    }

                    .name {
                    background: var(--gradient);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                    }

                    .hero-subtitle {
                    font-size: 1.5rem;
                    color: var(--accent-color);
                    margin-bottom: 1.5rem;
                    }

                    .hero-description {
                    font-size: 1.125rem;
                    color: var(--text-secondary);
                    margin-bottom: 2rem;
                    max-width: 500px;
                    }

                    .hero-buttons {
                    display: flex;
                    gap: 1rem;
                    }

                    .avatar {
                    width: 250px;
                    height: 250px;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 4px solid var(--accent-color);
                    box-shadow: var(--shadow);
                    }

                    /* Buttons */
                    .btn {
                    padding: 0.75rem 1.5rem;
                    border-radius: 0.5rem;
                    font-weight: 600;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    transition: var(--transition);
                    cursor: pointer;
                    border: none;
                    font-size: 1rem;
                    }

                    .btn-primary {
                    background: var(--accent-color);
                    color: white;
                    }

                    .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 20px rgba(37, 99, 235, 0.3);
                    }

                    .btn-outline {
                    background: transparent;
                    color: var(--accent-color);
                    border: 2px solid var(--accent-color);
                    }

                    .btn-outline:hover {
                    background: var(--accent-color);
                    color: white;
                    }

                    .btn-sm {
                    padding: 0.5rem 1rem;
                    font-size: 0.875rem;
                    }

                    /* Sections */
                    .section {
                    padding: 4rem 2rem;
                    transition: opacity 0.3s ease-in-out;
                    min-height: calc(100vh - 80px);
                    opacity: 1;
                    }

                    .section.hidden {
                    display: none !important;
                    }

                    .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    }

                    .section-title {
                    font-size: 2.5rem;
                    font-weight: 700;
                    text-align: center;
                    margin-bottom: 3rem;
                    background: var(--gradient);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                    }

                    /* Skills Section */
                    .skills-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 1.5rem;
                    }

                    .skill-card {
                    background: var(--bg-secondary);
                    padding: 1.5rem;
                    border-radius: 1rem;
                    border: 1px solid var(--border-color);
                    transition: var(--transition);
                    }

                    .skill-card:hover {
                    transform: translateY(-5px);
                    box-shadow: var(--shadow);
                    }

                    .skill-name {
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                    color: var(--text-primary);
                    }

                    .skill-bar {
                    background: var(--border-color);
                    height: 8px;
                    border-radius: 4px;
                    overflow: hidden;
                    }

                    .skill-progress {
                    height: 100%;
                    background: var(--gradient);
                    border-radius: 4px;
                    transition: width 1s ease-in-out;
                    }

                    .skill-card[data-level="beginner"] .skill-progress { width: 25%; }
        .skill-card[data-level="intermediate"] .skill-progress { width: 50%; }
        .skill-card[data-level="advanced"] .skill-progress { width: 75%; }
        .skill-card[data-level="expert"] .skill-progress { width: 90%; }

                    /* Projects Section */
                    .projects-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                    gap: 2rem;
                    }

                    .project-card {
                    background: var(--bg-secondary);
                    border-radius: 1rem;
                    padding: 1.5rem;
                    border: 1px solid var(--border-color);
                    transition: var(--transition);
                    }

                    .project-card:hover {
                    transform: translateY(-5px);
                    box-shadow: var(--shadow);
                    }

                    .project-title {
                    font-size: 1.25rem;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                    color: var(--text-primary);
                    }

                    .project-description {
                    color: var(--text-secondary);
                    margin-bottom: 1rem;
                    }

                    .project-tech {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 0.5rem;
                    margin-bottom: 1rem;
                    }

                    .tech-tag {
                    background: var(--accent-color);
                    color: white;
                    padding: 0.25rem 0.75rem;
                    border-radius: 1rem;
                    font-size: 0.75rem;
                    font-weight: 500;
                    }

                    .project-links {
                    display: flex;
                    gap: 0.5rem;
                    }

                    /* Timeline */
                    .timeline {
                    position: relative;
                    padding-left: 2rem;
                    }

                    .timeline::before {
                    content: '';
                    position: absolute;
                    left: 0;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: var(--accent-color);
                    }

                    .timeline-item {
                    position: relative;
                    margin-bottom: 2rem;
                    }

                    .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -2rem;
                    top: 0.5rem;
                    width: 12px;
                    height: 12px;
                    border-radius: 50%;
                    background: var(--accent-color);
                    transform: translateX(-50%);
                    }

                    .timeline-content {
                    background: var(--bg-secondary);
                    padding: 1.5rem;
                    border-radius: 1rem;
                    border: 1px solid var(--border-color);
                    }

                    .timeline-content h3 {
                    color: var(--text-primary);
                    margin-bottom: 0.5rem;
                    }

                    .timeline-content h4 {
                    color: var(--accent-color);
                    margin-bottom: 0.5rem;
                    }

                    .period {
                    font-size: 0.875rem;
                    color: var(--text-secondary);
                    font-weight: 500;
                    }

                    /* Contact Section */
                    .contact-content {
                    max-width: 600px;
                    margin: 0 auto;
                    text-align: center;
                    }

                    .contact-info {
                    display: grid;
                    gap: 1rem;
                    }

                    .contact-item {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    padding: 1rem;
                    background: var(--bg-secondary);
                    border-radius: 0.5rem;
                    border: 1px solid var(--border-color);
                    transition: var(--transition);
                    }

                    .contact-item:hover {
                    transform: translateY(-2px);
                    box-shadow: var(--shadow);
                    }

                    .contact-item a {
                    color: var(--text-primary);
                    text-decoration: none;
                    font-weight: 500;
                    }

                    .contact-item a:hover {
                    color: var(--accent-color);
                    }

                    .icon {
                    font-size: 1.5rem;
                    }

                    /* Responsive Design */
                    @media (max-width: 768px) {
                    .nav-menu {
                    display: none;
                    }

                    .hero-content {
                    grid-template-columns: 1fr;
                    text-align: center;
                    gap: 2rem;
                    }

                    .hero-title {
                    font-size: 2.5rem;
                    }

                    .navbar {
                    padding: 1rem;
                    }

                    .hero {
                    padding: 6rem 1rem 2rem;
                    }

                    .section {
                    padding: 2rem 1rem;
                    }

                    .projects-grid {
                    grid-template-columns: 1fr;
                    }

                    .skills-grid {
                    grid-template-columns: 1fr;
                    }
                    }

                    /* Animations */
                    @keyframes fadeInUp {
                    from {
                    opacity: 0;
                    transform: translateY(30px);
                    }
                    to {
                    opacity: 1;
                    transform: translateY(0);
                    }
                    }

                    .skill-card,
                    .project-card,
                    .timeline-content {
                    animation: fadeInUp 0.6s ease-out;
                    }

                    html {
                    scroll-behavior: smooth;
                    }

                    .loading {
                    opacity: 0;
                    animation: fadeInUp 0.8s ease-out forwards;
                    }

                    .animate-in {
                    animation: fadeInUp 0.6s ease-out forwards;
                    }
                </style>
            </head>
            <body>
                <div class="portfolio-wrapper" data-theme="light">
                    <!-- Header with navigation -->
                    <header class="header">
                        <nav class="navbar">
                            <div class="nav-brand">
                                <h1>
                                    <xsl:value-of select="personal/name" />
                                </h1>
                            </div>
                            <ul class="nav-menu">
                                <li>
                                    <a href="#about" data-i18n="nav.about">About</a>
                                </li>
                                <li>
                                    <a href="#skills" data-i18n="nav.skills">Skills</a>
                                </li>
                                <li>
                                    <a href="#projects" data-i18n="nav.projects">Projects</a>
                                </li>
                                <li>
                                    <a href="#experience" data-i18n="nav.experience">Experience</a>
                                </li>
                                <li>
                                    <a href="#contact" data-i18n="nav.contact">Contact</a>
                                </li>
                            </ul>
                            <div class="nav-controls">
                                <select class="language-select" data-language-select="">
                                    <option value="en">EN</option>
                                    <option value="ua">UA</option>
                                    <option value="ru">RU</option>
                                    <option value="fr">FR</option>
                                </select>
                                <button class="theme-toggle" data-theme-toggle=""
                                    aria-label="Toggle theme">
                                    <span class="theme-icon">🌙</span>
                                </button>
                            </div>
                        </nav>
                    </header>

                    <!-- Hero Section -->
                    <section class="hero" id="about">
                        <div class="hero-content">
                            <div class="hero-text">
                                <h1 class="hero-title">
                                    <span class="greeting">Hello, I'm</span>
                                    <span class="name">
                                        <xsl:value-of select="personal/name" />
                                    </span>
                                </h1>
                                <h2 class="hero-subtitle">
                                    <xsl:value-of select="personal/title" />
                                </h2>
                                <p class="hero-description">
                                    <xsl:value-of select="personal/summary" />
                                </p>
                                <div class="hero-buttons">
                                    <a href="#contact" class="btn btn-primary">Contact Me</a>
                                    <a href="#projects" class="btn btn-outline">View Projects</a>
                                </div>
                            </div>
                            <div class="hero-image">
                                <img src="{personal/avatar}" alt="Profile" class="avatar" />
                            </div>
                        </div>
                    </section>

                    <!-- Skills Section -->
                    <section class="section skills-section" id="skills">
                        <div class="container">
                            <div class="section-header">
                                <a href="#about" class="back-button">← Back to Home</a>
                                <h2 class="section-title" data-i18n="sections.skills-title">My
        Skills</h2>
                            </div>
                            <div class="skills-grid">
                                <xsl:for-each select="skills/skill">
                                    <div class="skill-card" data-category="{@category}"
                                        data-level="{@level}">
                                        <div class="skill-name">
                                            <xsl:value-of select="." />
                                        </div>
                                        <div class="skill-level">
                                            <div class="skill-bar">
                                                <div class="skill-progress"></div>
                                            </div>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </section>

                    <!-- Projects Section -->
                    <section class="section projects-section" id="projects">
                        <div class="container">
                            <div class="section-header">
                                <a href="#about" class="back-button">← Back to Home</a>
                                <h2 class="section-title" data-i18n="sections.projects-title">Featured
        Projects</h2>
                            </div>
                            <div class="projects-grid">
                                <xsl:for-each select="projects/project">
                                    <div class="project-card">
                                        <div class="project-content">
                                            <h3 class="project-title">
                                                <xsl:value-of select="name" />
                                            </h3>
                                            <p class="project-description">
                                                <xsl:value-of select="description" />
                                            </p>
                                            <div class="project-tech">
                                                <xsl:for-each select="technologies/tech">
                                                    <span class="tech-tag">
                                                        <xsl:value-of select="." />
                                                    </span>
                                                </xsl:for-each>
                                            </div>
                                            <div class="project-links">
                                                <xsl:if test="link">
                                                    <a href="{link}" class="btn btn-sm"
                                                        data-i18n="ui.view-project">View Project</a>
                                                </xsl:if>
                                                <xsl:if test="github">
                                                    <a href="{github}"
                                                        class="btn btn-outline btn-sm"
                                                        data-i18n="ui.source-code">Source Code</a>
                                                </xsl:if>
                                            </div>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </section>

                    <!-- Experience Section -->
                    <section class="section experience-section" id="experience">
                        <div class="container">
                            <div class="section-header">
                                <a href="#about" class="back-button">← Back to Home</a>
                                <h2 class="section-title" data-i18n="sections.experience-title">Work
        Experience</h2>
                            </div>
                            <div class="timeline">
                                <xsl:for-each select="experience/job">
                                    <div class="timeline-item">
                                        <div class="timeline-content">
                                            <h3>
                                                <xsl:value-of select="position" />
                                            </h3>
                                            <h4>
                                                <xsl:value-of select="company" />
                                            </h4>
                                            <span class="period">
                                                <xsl:value-of select="period" />
                                            </span>
                                            <p>
                                                <xsl:value-of select="description" />
                                            </p>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </section>

                    <!-- Contact Section -->
                    <section class="section contact-section" id="contact">
                        <div class="container">
                            <h2 class="section-title" data-i18n="sections.contact-title">Get In
                                Touch</h2>
                            <div class="contact-content">
                                <div class="contact-info">
                                    <div class="contact-item">
                                        <span class="icon">📧</span>
                                        <a href="mailto:{contact/email}">
                                            <xsl:value-of select="contact/email" />
                                        </a>
                                    </div>
                                    <xsl:if test="contact/phone">
                                        <div class="contact-item">
                                            <span class="icon">📱</span>
                                            <a href="tel:{contact/phone}">
                                                <xsl:value-of select="contact/phone" />
                                            </a>
                                        </div>
                                    </xsl:if>
                                    <xsl:if test="contact/linkedin">
                                        <div class="contact-item">
                                            <span class="icon">💼</span>
                                            <a href="{contact/linkedin}" target="_blank">LinkedIn</a>
                                        </div>
                                    </xsl:if>
                                    <xsl:if test="contact/github">
                                        <div class="contact-item">
                                            <span class="icon">🐙</span>
                                            <a href="{contact/github}" target="_blank">GitHub</a>
                                        </div>
                                    </xsl:if>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>