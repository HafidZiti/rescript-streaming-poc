import ClientLayout from "./ClientLayout";
import {
  fetchTrending,
  fetchSeries,
  fetchDocumentaries,
  fetchTvShows,
  fetchPopularMovies,
} from "../lib/TmdbFetchers.gen";

export default async function Home() {
  const [
    trendingItems,
    seriesItems,
    docsItems,
    tvShowItems,
    popularMoviesItems,
  ] = await Promise.all([
    fetchTrending(),
    fetchSeries(),
    fetchDocumentaries(),
    fetchTvShows(),
    fetchPopularMovies(),
  ]);

  return (
    <ClientLayout
      trendingItems={trendingItems}
      seriesItems={seriesItems}
      docsItems={docsItems}
      tvShowItems={tvShowItems}
      popularMoviesItems={popularMoviesItems}
    />
  );
}
