"use client";

import { make as I18nProvider } from "../contexts/I18nContext.gen";
import { make as MediaGrid } from "../components/zones/MediaGrid.gen";
import type { media } from "../core/AppTypes.gen";

type Props = {
  trendingItems: media[];
  seriesItems: media[];
  docsItems: media[];
  tvShowItems: media[];
  popularMoviesItems: media[];
};

export default function ClientLayout({
  trendingItems,
  seriesItems,
  docsItems,
  tvShowItems,
  popularMoviesItems,
}: Props) {
  return (
    <I18nProvider>
      <MediaGrid
        trendingItems={trendingItems}
        seriesItems={seriesItems}
        docsItems={docsItems}
        tvShowItems={tvShowItems}
        popularMoviesItems={popularMoviesItems}
      />
    </I18nProvider>
  );
}
