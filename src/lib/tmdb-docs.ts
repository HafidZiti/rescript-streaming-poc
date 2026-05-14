import type { media } from "../core/AppTypes.gen";
import { isSafe } from "./tmdb-filter";
import { tmdbFetch, type RawMovie } from "./tmdb-client";

export async function fetchDocumentaries(): Promise<media[]> {
  const results = await tmdbFetch<RawMovie>(
    "https://api.themoviedb.org/3/discover/movie?with_genres=99&language=en-US&sort_by=popularity.desc&include_adult=false&without_keywords=4344,155477",
  );

  return results
    .filter((m) => isSafe(m.title, m.adult))
    .slice(0, 20)
    .map((m) => ({
      id: `doc-${m.id}`,
      title: m.title,
      thumbnail: m.poster_path
        ? `https://image.tmdb.org/t/p/w500${m.poster_path}`
        : "https://picsum.photos/seed/doc-placeholder/400/600",
      category: "Documentary" as const,
      description: m.overview,
      year: m.release_date ? parseInt(m.release_date.slice(0, 4), 10) : 0,
      duration: "N/A",
      rating: Math.round(m.vote_average * 10) / 10,
    }));
}
