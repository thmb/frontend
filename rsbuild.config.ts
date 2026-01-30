import { defineConfig } from '@rsbuild/core';
import { pluginReact } from '@rsbuild/plugin-react';

export default defineConfig({
  plugins: [pluginReact()],
  html: {
    title: 'Raio Energia',
    meta: {
      viewport: 'width=device-width, initial-scale=1.0',
    },
  },
  source: {
    entry: {
      index: './src/main.tsx',
    },
  },
  server: {
    port: 3000,
  },
});
