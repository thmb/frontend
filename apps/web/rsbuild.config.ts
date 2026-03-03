import path from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig } from "@rsbuild/core";
import { pluginReact } from "@rsbuild/plugin-react";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default defineConfig({
  plugins: [pluginReact()],
  html: {
    title: "THMB Web Blueprint",
    meta: {
      viewport: "width=device-width, initial-scale=1.0"
    }
  },
  resolve: {
    alias: {
      "react-native": "react-native-web",
      "@thmb/components": path.resolve(__dirname, "../../packages/components")
    }
  },
  source: {
    entry: {
      index: "./main.tsx"
    }
  },
  server: {
    port: 3000
  }
});
