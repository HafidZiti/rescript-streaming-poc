import type { media } from "../core/AppTypes.gen";
import { isSafe } from "./tmdb-filter";

type RawSearchResult = {
  id: number;
  media_type: "movie" | "tv" | "person";
  title?: string;
  name?: string;
  poster_path: string | null;
  overview: string;
  release_date?: string;
  first_air_date?: string;
  vote_average: number;
  adult?: boolean;
};

type TmdbSearchResponse = { results: RawSearchResult[] };

export async function searchTmdb(query: string): Promise<media[]> {
  const token = process.env.TMDB_READ_ACCESS_TOKEN;
  if (!token || !query.trim()) return [];

  try {
    const url = `https://api.themoviedb.org/3/search/multi?query=${encodeURIComponent(query)}&include_adult=false&language=en-US`;
    const res = await fetch(url, {
      headers: {
        Authorization: `Bearer ${token}`,
        accept: "application/json",
      },
      cache: "no-store",
    });
    if (!res.ok) return [];

    const data: TmdbSearchResponse = await res.json();

    return data.results
      .filter((r) => r.media_type !== "person")
      .filter((r) => isSafe(r.title ?? r.name ?? "", r.adult))
      .slice(0, 20)
      .map((r) => {
        const isMovie = r.media_type === "movie";
        const title = isMovie ? (r.title ?? "") : (r.name ?? "");
        const date = isMovie ? r.release_date : r.first_air_date;
        return {
          id: `${r.media_type}:${r.id}`,
          title,
          thumbnail: r.poster_path
            ? `https://image.tmdb.org/t/p/w500${r.poster_path}`
            : "https://picsum.photos/seed/search/400/600",
          category: (isMovie ? "Movie" : "TVShow") as media["category"],
          description: r.overview,
          year: date ? parseInt(date.slice(0, 4), 10) : 0,
          duration: "N/A",
          rating: Math.round(r.vote_average * 10) / 10,
        };
      });
  } catch {
    return [];
  }
}
