# FRONTEND

A lean and fast frontend application built with React, TypeScript, Mantine, and Rsbuild.

## 🚀 Tech Stack

- **React 19** - Modern React with latest features
- **TypeScript** - Type-safe development
- **Mantine 8** - Comprehensive UI component library
- **Rsbuild** - Fast Rspack-powered build tool

## 📁 Project Structure

```
src/
├── hooks/     # Custom React hooks
├── pages/     # Page components
├── services/  # API services and data fetching
├── utils/     # Utility functions
├── App.tsx    # Main application component
└── main.tsx   # Application entry point
```

## � Deployment

### GitHub Pages (Automated)
This project includes a GitHub Action workflow that automatically:
- ✅ **Builds the static site** on every push to `main`
- ✅ **Runs TypeScript type checking** to ensure quality
- ✅ **Deploys to GitHub Pages** using the official actions
- ✅ **No special branch needed** - deploys directly from `main`

The site will be available at: `https://raioenergia.github.io/site/`

### Manual Deployment
You can also build and deploy manually:

```bash
npm run build        # Generates static files in dist/
# Upload dist/ contents to any static hosting service
```

## �🛠 NPM Scripts

```bash
# Development
npm run dev          # Start development server on localhost:3000

# Building
npm run build        # Build for production
npm run build:prod   # Build with production optimizations
npm run preview      # Preview production build

# Quality Assurance
npm run type-check   # TypeScript type checking
```

## 🏃‍♂️ Getting Started

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Build for production:
   ```bash
   npm run build
   ```

## 🎯 Features

- ⚡ **Lightning Fast** - Powered by Rspack for ultra-fast builds
- 🎨 **Modern UI** - Beautiful components with Mantine
- 📱 **Responsive** - Mobile-first design approach
- 🔧 **Type Safe** - Full TypeScript support
- 🚀 **Production Ready** - Optimized static builds

## 📦 Build Output

The build generates static files in the `dist/` folder, ready for deployment to any static hosting service.

---

Built with ❤️ for Raio Energia
