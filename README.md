# Portfolio Website

🚀 **Live Demo**: [https://portfolio-dmytropalahin.vercel.app](https://portfolio-dmytropalahin.vercel.app)

Multilingual portfolio website built with PHP, XSLT, and modern CSS.

## Features

- 🌍 **Multilingual support** (EN, FR, UA, RU) with smooth language switching
- 🎨 **Modern dark theme** with Apple-style design and glassmorphism effects
- 📱 **Fully responsive** and accessible design (WCAG compliant)
- ⚡ **Fast XSLT transformations** for dynamic content rendering
- 🔍 **SEO optimized** with RDFa markup and proper meta tags
- 🚀 **Smooth animations** and transitions with CSS3
- 💫 **Interactive elements** with hover effects and micro-animations

## Technology Stack

- **Backend**: PHP 8.3+ with XSLT transformations
- **Frontend**: Modern CSS with CSS Grid/Flexbox and CSS Variables
- **Data Storage**: XML with TMX-like structure for translations
- **Deployment**: Vercel Serverless Functions with PHP runtime
- **Build Tools**: Composer for PHP dependencies

## Quick Start Commands

| Stage | Commands | Description |
|-------|----------|-------------|
| **Development** | `npm install` | Install all dependencies |
| | `npm run dev` | Start development server |
| | Open `http://localhost:8080` | View your site locally |
| **Production** | `npm install` | Install dependencies |
| | `vercel login` | Login to Vercel account |
| | `npm run deploy` | Deploy to production |
| **Preview Deploy** | `npm run deploy-preview` | Deploy preview version |
| | `npm run clean-all` | Clean build files |

## XML/XSD Validation & Build Commands

| Make Command | Description | Terminal Equivalent |
|--------------|-------------|---------------------|
| `make validate` | Validate XML against XSD schema | `xmllint --noout --schema data/content.xsd data/content.xml` |
| `make schema-check` | Validate XSD schema itself | `xmllint --noout data/content.xsd` |
| `make full-check` | Full validation + build process | `make validate && make build` |
| `make stats` | Show translation statistics | - |
| `make build` | Generate HTML from XML+XSLT | - |
| `make serve` | Start local development server | `php -S localhost:8080 -t public` |
| `make prepare-validation` | Prepare for W3C validation | `./scripts/prepare-validation.sh` |
| `make clean` | Clean build directory | `rm -rf dist/` |
| `make help` | Show all available commands | - |

## Local Development Setup

### Prerequisites

- **PHP 8.2+** installed on your system
- **Node.js 18+** and npm
- **Git** for version control

### Step-by-Step Installation

1. **Clone the repository**:

   ```bash
   git clone <your-repo-url>
   cd portfolio-classic
   ```

2. **Install dependencies**:

   ```bash
   npm install
   ```

3. **Start the development server**:

   ```bash
   npm run dev
   ```

   This starts a PHP built-in server on `http://localhost:8080`

4. **Open in browser**:

   ```bash
   open http://localhost:8080
   ```

### Available Scripts

| Script | Command | Description |
|--------|---------|-------------|
| `dev` | `npm run dev` | Start development server on port 8080 |
| `start` | `npm run start` | Alternative command to start development server |
| `deploy` | `npm run deploy` | Deploy to Vercel production |
| `deploy-preview` | `npm run deploy-preview` | Deploy preview version to Vercel |
| `clean` | `npm run clean` | Remove dist folder |
| `clean-all` | `npm run clean-all` | Remove node_modules, dist, and package-lock.json |

## Deployment to Vercel

### Vercel Prerequisites

- [Vercel account](https://vercel.com) (free tier available)
- [Vercel CLI](https://vercel.com/cli) (installed via npm)

### Deployment Steps

1. **Install Vercel CLI** (if not already installed):

   ```bash
   npm install
   ```

2. **Login to your Vercel account**:

   ```bash
   vercel login
   ```

   Follow the prompts to authenticate with your Vercel account.

3. **Deploy preview version** (optional):

   ```bash
   npm run deploy-preview
   ```

   This creates a preview deployment for testing.

4. **Deploy to production**:

   ```bash
   npm run deploy
   ```

   This deploys your site to the production domain.

### Vercel Configuration

The project includes these configuration files:

- **`vercel.json`** - Vercel deployment configuration
- **`composer.json`** - PHP dependencies and autoloader
- **`.vercelignore`** - Files to exclude from deployment

## Project Structure

```tree
├── api/
│   └── index.php          # Vercel serverless function entry point
├── data/
│   ├── content.xml        # Multilingual content (TMX-like structure)
│   ├── content.xsd        # XML schema validation
│   └── meta.ttl           # RDF metadata
├── public/
│   ├── index.php          # Local development entry point
│   └── assets/
│       ├── css/
│       │   └── style.css  # Main stylesheet
│       └── img/
│           └── animations/ # Animation assets
├── src/
│   ├── Controller.php     # Main application controller
│   ├── LanguageDetector.php # Language detection logic
│   └── ContentProvider.php  # Content management
├── xslt/
│   └── page.xsl          # XSLT template for HTML generation
├── vercel.json           # Vercel configuration
├── composer.json         # PHP dependencies
└── package.json          # Node.js dependencies
```

## Troubleshooting

### Common Issues

1. **Port 8080 already in use**:

   ```bash
   # Find process using port 8080
   lsof -i :8080
   
   # Kill the process
   kill -9 <PID>
   ```

2. **PHP not found**:

   ```bash
   # Check PHP installation
   php --version
   
   # Install PHP (macOS with Homebrew)
   brew install php
   ```

3. **Vercel deployment fails**:

   ```bash
   # Check Vercel status
   vercel --debug
   
   # Re-login to Vercel
   vercel logout
   vercel login
   ```

### Development Tips

- **Hot reload**: The PHP built-in server automatically serves updated files
- **Language testing**: Add `?lang=en|fr|ru|ua` to URL to test different languages
- **XML validation**: Use `make validate` to validate content.xml against XSD schema
- **Translation stats**: Use `make stats` to check translation completeness
- **Full workflow**: Use `make full-check` for complete validation + build process
- **CSS changes**: Refresh browser to see CSS updates immediately

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

---

Built with ❤️ using PHP, XSLT, and modern web technologies
