"use client";

import { useServerInsertedHTML } from "next/navigation";
import { cache } from "@emotion/css";

export default function EmotionRegistry({
  children,
}: {
  children: React.ReactNode;
}) {
  useServerInsertedHTML(() => {
    const names = Object.keys(cache.inserted);
    let styles = "";
    for (const name of names) {
      const style = cache.inserted[name];
      if (typeof style === "string") {
        styles += style;
      }
    }
    if (!styles) return null;
    return (
      <style data-emotion="css" dangerouslySetInnerHTML={{ __html: styles }} />
    );
  });

  return <>{children}</>;
}
