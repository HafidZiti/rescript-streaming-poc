# Streamify — Streaming Platform POC

A proof-of-concept streaming catalog built with **ReScript 11** + **Next.js 16** (App Router). The goal was to validate a fully typed, functional-first frontend stack where the UI logic lives entirely in ReScript and interops seamlessly with Next.js via GenType.

## Stack

| Layer       | Technology                                                       |
| ----------- | ---------------------------------------------------------------- |
| Language    | ReScript 11.1.4 (`-open RescriptCore`)                           |
| Framework   | Next.js 16 — App Router, SSR                                     |
| Styling     | `bs-css-emotion` 7.1.1 — type-safe CSS-in-JS                     |
| Type bridge | GenType 4.5.0 — generates `.gen.tsx` from `@genType` annotations |
| i18n        | Pure ReScript — flat translation records, EN/FR                  |
| React       | `@rescript/react` 0.12.0, JSX v4                                 |

## Architecture

The component tree follows **Atomic Design** (atoms → molecules → organisms → zones).

```
src/
├── app/                        # Next.js entry points (TypeScript)
│   ├── layout.tsx              # Root layout + EmotionRegistry (SSR style injection)
│   ├── page.tsx                # Client root — mounts I18nProvider + MediaGrid
│   └── EmotionRegistry.tsx
├── bindings/
│   └── CssHelper.res           # Obj.magic wrappers for bs-css poly-variant types
├── components/
│   ├── atoms/                  # Primitive, stateless UI elements
│   │   ├── Button.res          # Red CTA button
│   │   ├── CategoryBadge.res   # Colored category pill (top-right of card)
│   │   ├── Logo.res            # "S" icon + "Streamify" wordmark
│   │   └── RatingBadge.res     # ★ rating pill (top-left of card)
│   ├── molecules/              # Compositions of atoms with a single responsibility
│   │   ├── LocaleSwitcher.res  # Flag dropdown — trigger + panel
│   │   ├── MediaCard.res       # Poster + RatingBadge + CategoryBadge + overlay
│   │   └── SearchBar.res       # Input + Button, manages query state internally
│   ├── organisms/              # Autonomous page sections
│   │   ├── HeroSection.res     # Background image + title + SearchBar
│   │   ├── MediaSection.res    # Category heading + horizontal scroll row of MediaCards
│   │   └── Navbar.res          # Sticky nav — Logo + LocaleSwitcher
│   └── zones/                  # Page-level layout templates
│       └── MediaGrid.res       # Composes all organisms; owns search + filter state
├── contexts/
│   └── I18nContext.res         # React context + useI18n hook (@genType provider)
└── core/
    ├── AppTypes.res            # contentType variant + media record
    ├── I18n.res                # Translation dictionaries (EN/FR)
    └── MockData.res            # Sample catalog data
```

## Key design decisions

**GenType suffix patching** — GenType 4.5.0 hardcodes `.bs.js` in generated import paths regardless of `rescript.json` config. `scripts/fix-gen-suffix.mjs` rewrites the suffix to `.res.js` post-build and is wired into `yarn rescript` and `yarn build`.

**`bs-css` poly-variant bridging** — ReScript 11 no longer auto-narrows open polymorphic variants (`[> #px(int)]`) to closed types. `CssHelper.res` wraps every unit/color helper with `Obj.magic`, which is safe since all poly-variant constructors are identity-coercible at runtime in JS.

**SSR style injection** — `EmotionRegistry.tsx` uses Next.js `useServerInsertedHTML` to flush `@emotion/css` cache into the server-rendered HTML, eliminating FOUC.

**i18n in ReScript** — No third-party i18n library. Translations are plain ReScript records (`I18n.t`), the compiler enforces that every locale covers every key, and the context is exposed to TypeScript via `@genType`.

## Getting started

```bash
# Install dependencies
yarn install

# Compile ReScript + patch GenType imports
yarn rescript

# Start dev server
yarn dev
```

> Open [http://localhost:3000](http://localhost:3000)

When editing `.res` files, run the compiler in watch mode in a separate terminal:

```bash
yarn rescript:watch
```

Then in another terminal:

```bash
yarn dev
```

## Build

```bash
yarn build   # rescript → fix-gen-suffix → next build
yarn start
```

## Scripts

| Script                | Description                             |
| --------------------- | --------------------------------------- |
| `yarn rescript`       | Compile ReScript + patch GenType suffix |
| `yarn rescript:watch` | Compile in watch mode                   |
| `yarn rescript:clean` | Clean build artifacts                   |
| `yarn dev`            | Next.js dev server                      |
| `yarn build`          | Production build (full pipeline)        |
| `yarn lint`           | ESLint                                  |
