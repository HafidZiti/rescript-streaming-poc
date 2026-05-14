"use client";

import { make as I18nProvider } from "../contexts/I18nContext.gen";
import { make as MediaGrid } from "../components/MediaGrid.gen";
import { mockMovies } from "../core/MockData.gen";

export default function Home() {
  return (
    <I18nProvider>
      <MediaGrid movies={mockMovies} />
    </I18nProvider>
  );
}
