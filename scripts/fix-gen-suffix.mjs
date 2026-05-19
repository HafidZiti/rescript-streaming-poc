/**
 * fix-gen-suffix.mjs
 *
 * gentype 4.5.0 hardcodes ".bs.js" in the import paths it emits inside
 * *.gen.tsx files, ignoring package-specs.suffix from rescript.json.
 * This script patches every generated *.gen.tsx file after the build
 * to replace ".bs.js" with the actual suffix configured in rescript.json.
 */

import { readFileSync, writeFileSync, readdirSync, statSync } from "fs";
import { join, extname } from "path";

const config = JSON.parse(readFileSync("rescript.json", "utf8"));
const specs = Array.isArray(config["package-specs"])
  ? config["package-specs"][0]
  : config["package-specs"];
const suffix = specs?.suffix ?? ".bs.js";

if (suffix === ".bs.js") {
  // Nothing to do — gentype already emits the right suffix.
  process.exit(0);
}

let patched = 0;

// Gen files that export React components or hooks need "use client" so Next.js
// doesn't attempt to evaluate them (and their transitive CJS deps) on the server.
const CLIENT_GEN_MARKER = "/* use-client-gen */";
const USE_CLIENT_BANNER = `"use client";\n// ${CLIENT_GEN_MARKER}\n`;

function needsUseClient(src) {
  // Heuristic: if the gen file exports a React component (make) or a hook, it's client-only.
  return (
    !src.includes('"use client"') &&
    (src.includes("React.ComponentType") || src.includes("useI18n"))
  );
}

function walk(dir) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      walk(full);
    } else if (entry.endsWith(".gen.tsx") || entry.endsWith(".gen.ts")) {
      const src = readFileSync(full, "utf8");
      let fixed = src.replaceAll(".bs.js", suffix);
      if (needsUseClient(fixed)) {
        fixed = USE_CLIENT_BANNER + fixed;
      }
      if (fixed !== src) {
        writeFileSync(full, fixed);
        patched++;
        console.log(`  patched: ${full}`);
      }
    }
  }
}

console.log(`fix-gen-suffix: replacing ".bs.js" → "${suffix}" in *.gen.tsx`);
walk("src");
console.log(
  `fix-gen-suffix: done (${patched} file${patched !== 1 ? "s" : ""} updated)`,
);
