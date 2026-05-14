const BLOCKED_TERMS = [
  "porn",
  "pornhub",
  "xxx",
  "erotic",
  "hentai",
  "nude",
  "nudity",
];

const RE_BLOCKED = new RegExp(
  BLOCKED_TERMS.map((t) => `\\b${t}\\b`).join("|"),
  "i",
);

export function isSafe(title: string, adult?: boolean): boolean {
  if (adult === true) return false;
  return !RE_BLOCKED.test(title);
}
