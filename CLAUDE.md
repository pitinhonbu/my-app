# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Stack

Next.js 16 (App Router, Turbopack) + React 19 + TypeScript (strict) + Tailwind CSS v4. Tests use Vitest + Testing Library (jsdom). Package manager is npm.

Next.js 16 differs from older versions in training data. Check `node_modules/next/dist/docs/` (`01-app/` for App Router) before using Next.js APIs.

## Commands

- `npm run dev` — dev server at http://localhost:3000
- `npm run build` — production build (also catches route and type errors)
- `npm run lint` — ESLint (flat config in `eslint.config.mjs`, `eslint-config-next`)
- `npm run typecheck` — runs `next typegen` then `tsc --noEmit`. Plain `tsc` fails without typegen because globals like `LayoutProps` / `PageProps` are generated into `.next/types`.
- `npm test` — Vitest once; `npm run test:watch` for watch mode
- Single test file: `npx vitest run src/app/page.test.tsx`; single test by name: `npx vitest run -t "renders the main heading"`

Before declaring a change done, run `npm run lint && npm run typecheck && npm test && npm run build`.

## Layout

- `src/app/` — App Router routes (`layout.tsx`, `page.tsx`, `globals.css`). Components are Server Components by default; add `"use client"` only where state/effects/browser APIs are needed.
- `public/` — static assets served from `/`.
- Import alias `@/*` → `src/*` (configured in `tsconfig.json`; Vitest resolves it via `vite-tsconfig-paths`).
- Tailwind v4 is configured CSS-first: `@import "tailwindcss"` and the `@theme` block in `src/app/globals.css`. There is no `tailwind.config.js` and no PostCSS config — CSS is processed by the `@tailwindcss/turbopack` loader registered under `turbopack.rules` in `next.config.ts`.
- `next.config.ts` enables `cacheComponents` (Cache Components / partial prerendering) and `partialPrefetching`. This changes how dynamic data and caching work in Server Components; read the caching docs under `node_modules/next/dist/docs/01-app/` before fetching data or using request APIs.

## Tests

- Colocate tests as `*.test.ts(x)` under `src/` (that is Vitest's `include` pattern in `vitest.config.mts`).
- `vitest.setup.ts` loads `@testing-library/jest-dom` matchers and runs `cleanup()` after each test.
- Vitest renders components directly; it does not run Next.js server features. Async Server Components and route handlers are not covered by this setup.

## Cloud sessions

`.claude/hooks/session-start.sh` runs `npm install` at session start in Claude Code on the web, so dependencies are ready in fresh containers.
