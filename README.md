# Streamify — Streaming Platform POC

A proof-of-concept streaming catalog built with **ReScript 11** + **Next.js 16** (App Router). The goal was to validate a fully typed, functional-first frontend stack where the UI logic lives entirely in ReScript and interops seamlessly with Next.js via GenType.

## Stack

| Layer | Technology |
|---|---|
| Language | ReScript 11.1.4 (`-open RescriptCore`) |
| Framework | Next.js 16 — App Router, SSR |
| Styling | `bs-css-emotion` 7.1.1 — type-safe CSS-in-JS |
| Type bridge | GenType 4.5.0 — generates `.gen.tsx` from `@genType` annotations |
| i18n | Pure ReScript — flat translation records, EN/FR |
| React | `@rescript/react` 0.12.0, JSX v4 |

## Architecture

```
src/
├── app/                  # Next.js entry points (TypeScript)
│   ├── layout.tsx        # Root layout + EmotionRegistry (SSR style injection)
│   ├── page.tsx          # Client root — mounts I18nProvider + MediaGrid
│   └── EmotionRegistry.tsx
├── bindings/
│   └── CssHelper.res     # Obj.magic wrappers for bs-css poly-variant types
├── components/
│   ├── Shared/
│   │   └── LocaleSwitcher.res
│   ├── HeroSection.res
│   ├── MediaCard.res
│   ├── MediaGrid.res     # Search state + catalog filtering
│   ├── MediaSection.res  # Per-category horizontal scroll row
│   └── Navbar.res
├── contexts/
│   └── I18nContext.res   # React context + useI18n hook (@genType provider)
└── core/
    ├── AppTypes.res       # contentType variant + media record
    ├── I18n.res           # Translation dictionaries
    └── MockData.res       # Sample catalog data
```

## Key design decisions

**GenType suffix patching** — GenType 4.5.0 hardcodes `.bs.js` in generated import paths regardless of `rescript.json` config. `scripts/fix-gen-suffix.mjs` rewrites the suffix to `.res.js` post-build and is wired into `npm run rescript` and `npm run build`.

**`bs-css` poly-variant bridging** — ReScript 11 no longer auto-narrows open polymorphic variants (`[> #px(int)]`) to closed types. `CssHelper.res` wraps every unit/color helper with `Obj.magic`, which is safe since all poly-variant constructors are identity-coercible at runtime in JS.

**SSR style injection** — `EmotionRegistry.tsx` uses Next.js `useServerInsertedHTML` to flush `@emotion/css` cache into the server-rendered HTML, eliminating FOUC.

**i18n in ReScript** — No third-party i18n library. Translations are plain ReScript records (`I18n.t`), the compiler enforces that every locale covers every key, and the context is exposed to TypeScript via `@genType`.

## Getting started

```bash
# Install dependencies
npm install

# Compile ReScript + patch GenType imports
npm run rescript

# Start dev server
npm run dev
```

> Open [http://localhost:3000](http://localhost:3000)

When editing `.res` files, run the compiler in watch mode in a separate terminal:

```bash
npm run rescript:watch
```

Then in another terminal:

```bash
npm run dev
```

## Build

```bash
npm run build   # rescript → fix-gen-suffix → next build
npm run start
```

## Scripts

| Script | Description |
|---|---|
| `npm run rescript` | Compile ReScript + patch GenType suffix |
| `npm run rescript:watch` | Compile in watch mode |
| `npm run rescript:clean` | Clean build artifacts |
| `npm run dev` | Next.js dev server |
| `npm run build` | Production build (full pipeline) |
| `npm run lint` | ESLint |
