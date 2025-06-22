import { ThemeManager } from './themeToggle';
import { I18nManager } from './languageSwitch';

class PortfolioApp {
  private themeManager: ThemeManager;
  private i18nManager: I18nManager;
  private themeToggleHandler?: (e: Event) => void;
  private languageChangeHandler?: (e: Event) => void;
  private navigationHandler?: (e: Event) => void;
  private currentPage: string = 'about';

  constructor() {
    this.themeManager = new ThemeManager();
    this.i18nManager = new I18nManager();
  }

  async init(): Promise<void> {
    // Проверяем, не была ли уже инициализирована
    if (document.body.classList.contains('portfolio-initialized')) {
      return;
    }

    await this.loadAndTransformXML();
    // Дать браузеру время на рендеринг HTML
    setTimeout(() => {
      this.themeManager.init();
      this.i18nManager.init();
      this.setupEventListeners();
      this.animateElements();
      this.showPage('about'); // Показать главную страницу по умолчанию
      document.body.classList.add('portfolio-initialized');
    }, 100);
  }

  private async loadAndTransformXML(): Promise<void> {
    try {
      console.log('Loading XML and XSL files...');

      // Load XML and XSL files
      const [xmlResponse, xslResponse] = await Promise.all([
        fetch('src/data/portfolio.xml'),
        fetch('src/styles/portfolio.xsl')
      ]);

      if (!xmlResponse.ok || !xslResponse.ok) {
        throw new Error('Failed to load XML or XSL files');
      }

      const xmlText = await xmlResponse.text();
      const xslText = await xslResponse.text();

      // Parse XML and XSL
      const parser = new DOMParser();
      const xmlDoc = parser.parseFromString(xmlText, 'text/xml');
      const xslDoc = parser.parseFromString(xslText, 'text/xml');

      // Check for XML parsing errors
      const xmlError = xmlDoc.querySelector('parsererror');
      const xslError = xslDoc.querySelector('parsererror');

      if (xmlError || xslError) {
        throw new Error('XML or XSL parsing error');
      }

      // Transform XML using XSLT
      const xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xslDoc);
      const resultDoc = xsltProcessor.transformToDocument(xmlDoc);

      // Replace entire document with transformed content
      if (resultDoc && resultDoc.documentElement) {
        document.documentElement.innerHTML = resultDoc.documentElement.innerHTML;
        console.log('Portfolio loaded successfully!');
      }
    } catch (error) {
      console.error('Error loading and transforming XML:', error);
      this.showErrorMessage();
    }
  }

  private setupEventListeners(): void {
    // Удаляем существующие listeners чтобы избежать дублирования
    this.removeEventListeners();

    // Theme toggle
    this.themeToggleHandler = (e: Event) => {
      const target = e.target as HTMLElement;
      if (target.matches('[data-theme-toggle]') || target.closest('[data-theme-toggle]')) {
        e.preventDefault();
        this.themeManager.toggle();
      }
    };
    document.addEventListener('click', this.themeToggleHandler);

    // Language selection
    this.languageChangeHandler = (e: Event) => {
      const target = e.target as HTMLSelectElement;
      if (target.matches('[data-language-select]')) {
        this.i18nManager.setLanguage(target.value);
      }
    };
    document.addEventListener('change', this.languageChangeHandler);

    // Navigation for page switching (without URL change)
    this.navigationHandler = (e: Event) => {
      const target = e.target as HTMLAnchorElement;
      if (target.matches('a[href^="#"]')) {
        e.preventDefault();
        const pageId = target.getAttribute('href')?.substring(1);
        if (pageId) {
          this.showPage(pageId);
        }
      }
    };
    document.addEventListener('click', this.navigationHandler);
  }

  private showPage(pageId: string): void {
    // Анимация исчезновения текущих секций
    const allSections = document.querySelectorAll('.section');
    const heroSection = document.querySelector('.hero');

    // Сначала скрываем все с анимацией
    allSections.forEach(section => {
      (section as HTMLElement).style.opacity = '0';
      setTimeout(() => {
        (section as HTMLElement).style.display = 'none';
      }, 150);
    });

    if (heroSection) {
      (heroSection as HTMLElement).style.opacity = '0';
      setTimeout(() => {
        (heroSection as HTMLElement).style.display = 'none';
      }, 150);
    }

    // Показываем нужную секцию с анимацией
    setTimeout(() => {
      if (pageId === 'about') {
        // Показываем hero секцию для главной страницы
        if (heroSection) {
          (heroSection as HTMLElement).style.display = 'flex';
          setTimeout(() => {
            (heroSection as HTMLElement).style.opacity = '1';
          }, 50);
        }
      } else {
        // Показываем конкретную секцию
        const targetSection = document.getElementById(pageId);
        if (targetSection) {
          targetSection.style.display = 'block';
          setTimeout(() => {
            targetSection.style.opacity = '1';
          }, 50);
        }
      }
    }, 200);

    // Update active navigation
    this.updateActiveNavigation(pageId);
    this.currentPage = pageId;

    // Scroll to top smoothly
    window.scrollTo({ top: 0, behavior: 'smooth' });

    // Запускаем анимации для элементов на новой странице
    setTimeout(() => {
      this.animateElements();
    }, 300);
  }

  private updateActiveNavigation(activePageId: string): void {
    // Remove active class from all nav links
    const navLinks = document.querySelectorAll('.nav-menu a');
    navLinks.forEach(link => {
      link.classList.remove('active');
    });

    // Add active class to current nav link
    const activeLink = document.querySelector(`a[href="#${activePageId}"]`);
    if (activeLink) {
      activeLink.classList.add('active');
    }
  }

  private removeEventListeners(): void {
    if (this.themeToggleHandler) {
      document.removeEventListener('click', this.themeToggleHandler);
    }
    if (this.languageChangeHandler) {
      document.removeEventListener('change', this.languageChangeHandler);
    }
    if (this.navigationHandler) {
      document.removeEventListener('click', this.navigationHandler);
    }
  }

  private animateElements(): void {
    // Intersection Observer for animations
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-in');
        }
      });
    }, { threshold: 0.1 });

    // Observe elements for animation
    setTimeout(() => {
      const elements = document.querySelectorAll('.skill-card, .project-card, .timeline-content');
      elements.forEach(el => observer.observe(el));
    }, 200);
  }

  private showErrorMessage(): void {
    document.body.innerHTML = `
      <div style="
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        text-align: center;
        padding: 2rem;
        color: #ef4444;
        font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      ">
        <h2 style="font-size: 2rem; margin-bottom: 1rem; color: white;">⚠️ Error Loading Portfolio</h2>
        <p style="font-size: 1.1rem; color: rgba(255,255,255,0.9); max-width: 500px;">
          Please check if all XML and XSL files are properly loaded and accessible.
        </p>
        <button onclick="window.location.reload()" style="
          margin-top: 2rem;
          padding: 0.75rem 1.5rem;
          background: white;
          color: #2563eb;
          border: none;
          border-radius: 0.5rem;
          font-weight: 600;
          cursor: pointer;
          transition: transform 0.2s;
        " onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
          🔄 Reload Page
        </button>
      </div>
    `;
  }
}

// Initialize the application
let appInstance: PortfolioApp | null = null;

document.addEventListener('DOMContentLoaded', () => {
  if (!appInstance) {
    appInstance = new PortfolioApp();
    appInstance.init().catch(console.error);
  }
});