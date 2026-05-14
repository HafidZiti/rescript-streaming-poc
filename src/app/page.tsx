import ClientLayout from "./ClientLayout";
import { fetchTrending } from "../lib/tmdb-trending";
import { fetchSeries } from "../lib/tmdb-series";
import { fetchDocumentaries } from "../lib/tmdb-docs";
import { fetchTvShows } from "../lib/tmdb-tvshows";
import { fetchPopularMovies } from "../lib/tmdb-movies";

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
