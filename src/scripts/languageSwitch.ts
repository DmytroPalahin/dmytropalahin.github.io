export class I18nManager {
  private currentLanguage: string = 'en';
  private translations: Map<string, any> = new Map();
  private readonly LANG_KEY = 'portfolio-language';
  private isInitialized: boolean = false;

  constructor() {
    this.loadSavedLanguage();
  }

  async init(): Promise<void> {
    if (this.isInitialized) {
      return;
    }

    await this.loadAllTranslations();
    this.applyTranslations();
    this.updateLanguageSelect();
    this.isInitialized = true;
  }

  async setLanguage(lang: string): Promise<void> {
    if (this.translations.has(lang)) {
      this.currentLanguage = lang;
      this.applyTranslations();
      this.saveLanguage();
      this.updateLanguageSelect();
    }
  }

  private async loadAllTranslations(): Promise<void> {
    const languages = ['en', 'ua', 'ru', 'fr'];

    for (const lang of languages) {
      try {
        const response = await fetch(`src/i18n/${lang}.xml`);
        const xmlText = await response.text();
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlText, 'text/xml');

        const translations = this.parseTranslations(xmlDoc);
        this.translations.set(lang, translations);
      } catch (error) {
        console.error(`Failed to load translations for ${lang}:`, error);
      }
    }
  }

  private parseTranslations(xmlDoc: Document): any {
    const result: any = {};

    const parseNode = (node: Element, target: any) => {
      for (const child of Array.from(node.children)) {
        if (child.children.length > 0) {
          target[child.tagName] = {};
          parseNode(child, target[child.tagName]);
        } else {
          target[child.tagName] = child.textContent || '';
        }
      }
    };

    const root = xmlDoc.querySelector('translations');
    if (root) {
      parseNode(root, result);
    }

    return result;
  }

  private applyTranslations(): void {
    const elements = document.querySelectorAll('[data-i18n]');
    const currentTranslations = this.translations.get(this.currentLanguage);

    if (!currentTranslations) return;

    elements.forEach(element => {
      const key = element.getAttribute('data-i18n');
      if (key) {
        const translation = this.getTranslation(key, currentTranslations);
        if (translation) {
          element.textContent = translation;
        }
      }
    });
  }

  private getTranslation(key: string, translations: any): string | null {
    const keys = key.split('.');
    let current = translations;

    for (const k of keys) {
      if (current && typeof current === 'object' && k in current) {
        current = current[k];
      } else {
        return null;
      }
    }

    return typeof current === 'string' ? current : null;
  }

  private updateLanguageSelect(): void {
    const select = document.querySelector('[data-language-select]') as HTMLSelectElement;
    if (select) {
      select.value = this.currentLanguage;
    }
  }

  private saveLanguage(): void {
    localStorage.setItem(this.LANG_KEY, this.currentLanguage);
  }

  private loadSavedLanguage(): void {
    const saved = localStorage.getItem(this.LANG_KEY);
    if (saved) {
      this.currentLanguage = saved;
    }
  }
}