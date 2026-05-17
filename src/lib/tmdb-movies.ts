import type { media } from "../core/AppTypes.gen";
import { isSafe } from "./tmdb-filter";
import { tmdbFetch, type RawMovie } from "./tmdb-client";

export async function fetchPopularMovies(): Promise<media[]> {
  const results = await tmdbFetch<RawMovie>(
    "https://api.themoviedb.org/3/movie/popular?language=en-US&include_adult=false",
  );

  return results
    .filter((m) => isSafe(m.title, m.adult))
    .slice(0, 20)
    .map((m) => ({
      id: `movie:${m.id}`,
      title: m.title,
      thumbnail: m.poster_path
        ? `https://image.tmdb.org/t/p/w500${m.poster_path}`
        : "https://picsum.photos/seed/movie-placeholder/400/600",
      category: "Movie" as const,
      description: m.overview,
      year: m.release_date ? parseInt(m.release_date.slice(0, 4), 10) : 0,
      duration: "N/A",
      rating: Math.round(m.vote_average * 10) / 10,
    }));
}
