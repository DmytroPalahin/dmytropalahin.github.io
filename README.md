# Portfolio Web Application

This project is a modern and interactive portfolio web application that showcases various projects with support for multiple languages and theme selection. The application is built using XML, XSLT, and TypeScript, adhering to web semantics best practices.

## Features

- **Multi-language Support**: The portfolio supports English, French, Ukrainian, and Russian languages.
- **Theme Selection**: Users can toggle between light and dark themes for a personalized experience.
- **Responsive Design**: The application is designed to be responsive and user-friendly across different devices.

## Project Structure

```tree
portfolio-webapp
├── src
│   ├── data
│   │   ├── portfolio.xml        # XML data structure for the portfolio
│   │   ├── portfolio.dtd        # DTD defining the structure of the XML
│   │   └── translations         # Language translations
│   │       ├── en.xml          # English translations
│   │       ├── fr.xml          # French translations
│   │       ├── ua.xml          # Ukrainian translations
│   │       └── ru.xml          # Russian translations
│   ├── styles
│   │   ├── portfolio.xsl        # Main XSLT stylesheet for transforming XML to HTML
│   │   ├── themes               # Theme-specific XSLT transformations
│   │   │   ├── light.xsl       # Light theme transformations
│   │   │   └── dark.xsl        # Dark theme transformations
│   │   └── css
│   │       ├── main.css         # Main CSS styles
│   │       └── themes.css       # CSS styles for themes
│   ├── scripts
│   │   ├── app.ts               # Entry point for the TypeScript application
│   │   ├── themeToggle.ts       # Functionality for toggling themes
│   │   └── languageSwitch.ts    # Functionality for switching languages
│   └── assets
│       └── images               # Images used in the portfolio
├── dist                         # Compiled output directory
├── package.json                 # npm configuration file
├── tsconfig.json                # TypeScript configuration file
├── webpack.config.js            # Webpack configuration file
└── README.md                    # Project documentation
```

## Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd portfolio-webapp
   ```

2. **Production-ready**:

    2.1. Install Dependencies and Build the Application:

    ```bash
    npm install
    ```

    2.2 Compile and optimize the code for production:

    ```bash
    npm run build
    ```

    2.3. Start the application (typically using a static server):

    ```bash
    npm start
    ```

3. **Development**:

    3.1. Install Dependencies:

    ```bash
    npm install
    ```

    3.2. Compile TypeScript:

    ```bash
    npm run compile
    ```

    3.3. Start Development Server:

    ```bash
    npm run dev
    ```

4. **Useful commands**:

    4.1 Erase existent build files:

    ```bash
    npm run clean
    ```

    4.2 Kill the development server if it is running on port 3000:

    ```bash
    kill -9 $(lsof -ti:3000)

    ```

## Usage

- Navigate through the portfolio to view projects.
- Use the language switcher to change the displayed language.
- Toggle between light and dark themes using the theme switcher.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
