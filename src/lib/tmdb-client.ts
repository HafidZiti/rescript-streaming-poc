export type RawMovie = {
  id: number;
  title: string;
  poster_path: string | null;
  overview: string;
  release_date: string;
  vote_average: number;
  adult?: boolean;
};

export type RawTvShow = {
  id: number;
  name: string;
  poster_path: string | null;
  overview: string;
  first_air_date: string;
  vote_average: number;
  adult?: boolean;
};

type TmdbResponse<T> = { results: T[] };

export async function tmdbFetch<T>(url: string): Promise<T[]> {
  const token = process.env.TMDB_READ_ACCESS_TOKEN;
  if (!token) return [];

  try {
    const res = await fetch(url, {
      headers: {
        Authorization: `Bearer ${token}`,
        accept: "application/json",
      },
      next: { revalidate: 3600 },
    });
    if (!res.ok) return [];

    const data: TmdbResponse<T> = await res.json();
    return data.results;
  } catch {
    return [];
  }
}
