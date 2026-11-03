# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Stack

Next.js 16 (App Router, Turbopack) + React 19 + TypeScript (strict) + Tailwind CSS v4. Unit tests: Vitest + Testing Library (jsdom). E2E: Playwright. Formatting: Prettier (with `prettier-plugin-tailwindcss`). Package manager is npm.

Next.js 16 differs from older versions in training data. Check `node_modules/next/dist/docs/` (`01-app/` for App Router) before using Next.js APIs.

## Commands

- `npm run dev` — dev server at http://localhost:3000
- `npm run build` — production build (also catches route and type errors)
- `npm run lint` — ESLint (flat config in `eslint.config.mjs`, `eslint-config-next` + `eslint-config-prettier`)
- `npm run format` / `npm run format:check` — Prettier write / check
- `npm run typecheck` — runs `next typegen` then `tsc --noEmit`. Plain `tsc` fails without typegen because globals like `LayoutProps` / `PageProps` are generated into `.next/types`.
- `npm test` — Vitest once; `npm run test:watch` for watch mode
- Single test file: `npx vitest run src/app/page.test.tsx`; single test by name: `npx vitest run -t "renders the main heading"`
- `npm run test:e2e` — Playwright (`e2e/*.spec.ts`). It builds and serves the app on port 3100 itself, so it doesn't collide with `npm run dev`. Single spec: `npx playwright test e2e/home.spec.ts`

Before declaring a change done, run `npm run format:check && npm run lint && npm run typecheck && npm test && npm run build`, plus `npm run test:e2e` for UI changes — the same steps GitHub Actions runs (`.github/workflows/ci.yml`, on pushes to `main` and on pull requests). Node version is pinned in `.nvmrc` (22).

## Verifying in the running app

While `npm run dev` is running, the dev server exposes `/_next/mcp` (errors, routes, logs, compilation issues). Two ways to use it:

- The `next-devtools` MCP server (`.mcp.json`) wraps it as tools.
- The `next-dev-loop` skill (`.claude/skills/next-dev-loop/`) calls it directly and drives a real browser with `agent-browser` (a devDependency). Use it to confirm UI changes actually work, not just compile.

`get_compilation_issues` / `compile_route` are faster than a full `next build` for checking that edits compile.

## Layout

- `src/app/` — App Router routes (`layout.tsx`, `page.tsx`, `globals.css`). Components are Server Components by default; add `"use client"` only where state/effects/browser APIs are needed.
- `public/` — static assets served from `/`.
- Import alias `@/*` → `src/*` (configured in `tsconfig.json`; Vitest resolves it via `vite-tsconfig-paths`).
- Tailwind v4 is configured CSS-first: `@import "tailwindcss"` and the `@theme` block in `src/app/globals.css`. There is no `tailwind.config.js` and no PostCSS config — CSS is processed by the `@tailwindcss/turbopack` loader registered under `turbopack.rules` in `next.config.ts`. Prettier's Tailwind plugin reads the same stylesheet (`tailwindStylesheet` in `.prettierrc.json`) to sort classes.
- `next.config.ts` enables `cacheComponents` (Cache Components / partial prerendering) and `partialPrefetching`. This changes how dynamic data and caching work in Server Components; read the caching docs under `node_modules/next/dist/docs/01-app/` before fetching data or using request APIs.

## Tests

- Unit tests: colocate as `*.test.ts(x)` under `src/` (Vitest's `include` pattern in `vitest.config.mts`). `vitest.setup.ts` loads `@testing-library/jest-dom` matchers and runs `cleanup()` after each test.
- Vitest renders components directly; it does not run Next.js server features. Cover async Server Components, route handlers and real navigation with Playwright specs in `e2e/` instead.

## Claude Code hooks (`.claude/settings.json`)

- `PostToolUse` on Edit/Write runs Prettier on the edited file (`.claude/hooks/format.sh`), so don't reformat by hand.
- `PreToolUse` on Edit/Write blocks `.env*` (except `.env.example`), `package-lock.json` and `.git/` (`.claude/hooks/protect-files.sh`). Change dependencies with `npm install` / `npm uninstall`.
- `SessionStart` (cloud sessions only) runs `npm install`, puts `node_modules/.bin` on `PATH`, and points `agent-browser` at the container's preinstalled Chromium.

## GitHub

- `.github/workflows/claude.yml` — `@claude` mentions in issues/PRs run Claude Code; needs the `ANTHROPIC_API_KEY` repository secret.
- `.github/dependabot.yml` — weekly grouped updates for npm and GitHub Actions.
