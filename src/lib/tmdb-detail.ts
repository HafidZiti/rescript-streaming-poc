import type { mediaDetail } from "../core/AppTypes.gen";

type TmdbGenre = { id: number; name: string };

type TmdbMovieDetail = {
  id: number;
  title: string;
  tagline: string;
  overview: string;
  backdrop_path: string | null;
  poster_path: string | null;
  release_date: string;
  runtime: number | null;
  genres: TmdbGenre[];
  vote_average: number;
  status: string;
};

type TmdbTvDetail = {
  id: number;
  name: string;
  tagline: string;
  overview: string;
  backdrop_path: string | null;
  poster_path: string | null;
  first_air_date: string;
  episode_run_time: number[];
  genres: TmdbGenre[];
  vote_average: number;
  status: string;
  number_of_seasons: number;
};

const TMDB_IMG = "https://image.tmdb.org/t/p";
const FALLBACK_BACKDROP = "https://picsum.photos/seed/detail-bg/1280/720";
const FALLBACK_POSTER = "https://picsum.photos/seed/detail-poster/400/600";

async function tmdbDetailFetch<T>(path: string): Promise<T | null> {
  const token = process.env.TMDB_READ_ACCESS_TOKEN;
  if (!token) return null;

  try {
    const res = await fetch(`https://api.themoviedb.org/3${path}`, {
      headers: {
        Authorization: `Bearer ${token}`,
        accept: "application/json",
      },
      next: { revalidate: 3600 },
    });
    if (!res.ok) return null;
    return res.json() as Promise<T>;
  } catch {
    return null;
  }
}

export async function fetchMediaDetail(
  type: "movie" | "tv",
  id: string,
): Promise<mediaDetail | null> {
  if (type === "movie") {
    const data = await tmdbDetailFetch<TmdbMovieDetail>(
      `/movie/${id}?language=en-US`,
    );
    if (!data) return null;

    return {
      id: `movie:${data.id}`,
      tmdbType: "movie",
      title: data.title,
      tagline: data.tagline ?? "",
      overview: data.overview,
      backdrop: data.backdrop_path
        ? `${TMDB_IMG}/w1280${data.backdrop_path}`
        : FALLBACK_BACKDROP,
      poster: data.poster_path
        ? `${TMDB_IMG}/w500${data.poster_path}`
        : FALLBACK_POSTER,
      year: data.release_date ? parseInt(data.release_date.slice(0, 4), 10) : 0,
      runtime: data.runtime ?? 0,
      rating: Math.round(data.vote_average * 10) / 10,
      genres: data.genres.map((g) => g.name),
      status: data.status,
      numberOfSeasons: 0,
    };
  } else {
    const data = await tmdbDetailFetch<TmdbTvDetail>(
      `/tv/${id}?language=en-US`,
    );
    if (!data) return null;

    return {
      id: `tv:${data.id}`,
      tmdbType: "tv",
      title: data.name,
      tagline: data.tagline ?? "",
      overview: data.overview,
      backdrop: data.backdrop_path
        ? `${TMDB_IMG}/w1280${data.backdrop_path}`
        : FALLBACK_BACKDROP,
      poster: data.poster_path
        ? `${TMDB_IMG}/w500${data.poster_path}`
        : FALLBACK_POSTER,
      year: data.first_air_date
        ? parseInt(data.first_air_date.slice(0, 4), 10)
        : 0,
      runtime: data.episode_run_time[0] ?? 0,
      rating: Math.round(data.vote_average * 10) / 10,
      genres: data.genres.map((g) => g.name),
      status: data.status,
      numberOfSeasons: data.number_of_seasons,
    };
  }
}
