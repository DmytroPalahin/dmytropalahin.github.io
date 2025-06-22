export class ThemeManager {
  private currentTheme: 'light' | 'dark' = 'light';
  private readonly THEME_KEY = 'portfolio-theme';
  private isInitialized: boolean = false;

  constructor() {
    this.loadSavedTheme();
  }

  init(): void {
    if (this.isInitialized) {
      return;
    }

    this.applyTheme(this.currentTheme);
    this.updateThemeIcon();
    this.isInitialized = true;
  }

  toggle(): void {
    this.currentTheme = this.currentTheme === 'light' ? 'dark' : 'light';
    this.applyTheme(this.currentTheme);
    this.saveTheme();
    this.updateThemeIcon();
  }

  private applyTheme(theme: 'light' | 'dark'): void {
    const root = document.documentElement;
    const wrapper = document.querySelector('.portfolio-wrapper');

    if (wrapper) {
      wrapper.setAttribute('data-theme', theme);
    }

    // Apply CSS custom properties
    if (theme === 'dark') {
      root.style.setProperty('--bg-primary', '#0f0f23');
      root.style.setProperty('--bg-secondary', '#1a1a2e');
      root.style.setProperty('--text-primary', '#e4e4e7');
      root.style.setProperty('--text-secondary', '#a1a1aa');
      root.style.setProperty('--accent-color', '#3b82f6');
      root.style.setProperty('--border-color', '#374151');
    } else {
      root.style.setProperty('--bg-primary', '#ffffff');
      root.style.setProperty('--bg-secondary', '#f8fafc');
      root.style.setProperty('--text-primary', '#1f2937');
      root.style.setProperty('--text-secondary', '#6b7280');
      root.style.setProperty('--accent-color', '#2563eb');
      root.style.setProperty('--border-color', '#e5e7eb');
    }
  }

  private updateThemeIcon(): void {
    const themeIcon = document.querySelector('.theme-icon');
    if (themeIcon) {
      themeIcon.textContent = this.currentTheme === 'light' ? '🌙' : '☀️';
    }
  }

  private saveTheme(): void {
    localStorage.setItem(this.THEME_KEY, this.currentTheme);
  }

  private loadSavedTheme(): void {
    const saved = localStorage.getItem(this.THEME_KEY) as 'light' | 'dark';
    if (saved) {
      this.currentTheme = saved;
    }
  }
}