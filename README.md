# THMB Frontend Blueprint

Lean monorepo starter for React web and React Native mobile apps with shared packages.

## Stack

- Web: React 19 + Rsbuild
- Mobile: Expo (managed workflow) + React Native
- Shared UI: `react-native` components rendered on web via `react-native-web`
- Tests: Jest + Testing Library (`@testing-library/react` and `@testing-library/react-native`)
- Package management: npm workspaces

## Structure

```txt
apps/
  web/                  # React + Rsbuild app
    tests/              # Web tests
  mobile/               # Expo app
    tests/              # Mobile tests
packages/
  components/           # Shared cross-platform UI components
  services/             # API layer
  stores/               # State layer
  types/                # Shared TS types
  utils/                # Pure utility functions
assets/                 # Shared static assets (images/fonts)
```

## Quick start

```bash
npm install
cp .envrc.example .envrc
direnv allow
npm run dev:web
npm run dev:mobile
```

## Scripts

```bash
npm run dev:web
npm run dev:mobile
npm run build
npm run lint
npm run check
npm run test
```

## Notes

- Keep business logic in `packages/services` and `packages/stores`.
- Keep `packages/components` presentation-only and reusable.
- This template is intentionally simple for single-developer maintenance.
