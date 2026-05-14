import type { media } from "../core/AppTypes.gen";
import { isSafe } from "./tmdb-filter";
import { tmdbFetch, type RawTvShow } from "./tmdb-client";

export async function fetchTvShows(): Promise<media[]> {
  const results = await tmdbFetch<RawTvShow>(
    "https://api.themoviedb.org/3/tv/top_rated?language=en-US&include_adult=false",
  );

  return results
    .filter((s) => isSafe(s.name, s.adult))
    .slice(0, 20)
    .map((s) => ({
      id: `tv-top-${s.id}`,
      title: s.name,
      thumbnail: s.poster_path
        ? `https://image.tmdb.org/t/p/w500${s.poster_path}`
        : "https://picsum.photos/seed/tvshow-placeholder/400/600",
      category: "TVShow" as const,
      description: s.overview,
      year: s.first_air_date ? parseInt(s.first_air_date.slice(0, 4), 10) : 0,
      duration: "N/A",
      rating: Math.round(s.vote_average * 10) / 10,
    }));
}
