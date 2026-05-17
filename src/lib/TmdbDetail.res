// Next.js extends the global fetch with `next: { revalidate }` for ISR.
// Binding it as a distinct type means forgetting the cache option is a compile error.
type nextCacheOpts = {revalidate: int}

type fetchInit = {
  headers: Dict.t<string>,
  next: nextCacheOpts,
}

type response

@get external ok: response => bool = "ok"
@send external responseJson: response => promise<JSON.t> = "json"
@val external fetch: (string, fetchInit) => promise<response> = "fetch"

@val external tmdbToken: Nullable.t<string> = "process.env.TMDB_READ_ACCESS_TOKEN"

// Intermediate types — private to this module, never exposed to the view layer.
// Optional TMDB fields are modelled as option<'a> rather than nullable.

type tmdbMovie = {
  id: int,
  title: string,
  tagline: option<string>,
  overview: string,
  backdropPath: option<string>,
  posterPath: option<string>,
  releaseDate: string,
  runtime: option<int>,
  genres: array<string>,
  voteAverage: float,
  status: string,
}

type tmdbTv = {
  id: int,
  name: string,
  tagline: option<string>,
  overview: string,
  backdropPath: option<string>,
  posterPath: option<string>,
  firstAirDate: string,
  episodeRunTime: array<int>,
  genres: array<string>,
  voteAverage: float,
  status: string,
  numberOfSeasons: int,
}

// Field readers — return None for both missing keys and type mismatches (incl. null).
// The caller decides whether a field is required (tuple switch) or optional (getOr/map).

let getStr = (obj: Dict.t<JSON.t>, key: string): option<string> =>
  obj->Dict.get(key)->Option.flatMap(v =>
    switch v {
    | JSON.String(s) => Some(s)
    | _ => None
    }
  )

let getInt = (obj: Dict.t<JSON.t>, key: string): option<int> =>
  obj->Dict.get(key)->Option.flatMap(v =>
    switch v {
    | JSON.Number(n) => Some(Float.toInt(n))
    | _ => None
    }
  )

let getFloat = (obj: Dict.t<JSON.t>, key: string): option<float> =>
  obj->Dict.get(key)->Option.flatMap(v =>
    switch v {
    | JSON.Number(n) => Some(n)
    | _ => None
    }
  )

// A malformed genre object is silently dropped rather than failing the whole decode.
let getGenreNames = (obj: Dict.t<JSON.t>, key: string): array<string> =>
  obj
  ->Dict.get(key)
  ->Option.flatMap(v =>
    switch v {
    | JSON.Array(arr) => Some(arr)
    | _ => None
    }
  )
  ->Option.map(arr =>
    arr->Array.filterMap(item =>
      switch item {
      | JSON.Object(genre) => getStr(genre, "name")
      | _ => None
      }
    )
  )
  ->Option.getOr([])

// episode_run_time can be an empty array for currently-airing shows.
let getIntArray = (obj: Dict.t<JSON.t>, key: string): array<int> =>
  obj
  ->Dict.get(key)
  ->Option.flatMap(v =>
    switch v {
    | JSON.Array(arr) => Some(arr)
    | _ => None
    }
  )
  ->Option.map(arr =>
    arr->Array.filterMap(item =>
      switch item {
      | JSON.Number(n) => Some(Float.toInt(n))
      | _ => None
      }
    )
  )
  ->Option.getOr([])

// Required fields are matched as a tuple: one None anywhere collapses to None.
// This prevents partial records — there's no "best-effort" decode.
let decodeMovie = (json: JSON.t): option<tmdbMovie> =>
  switch json {
  | JSON.Object(obj) =>
    switch (
      getInt(obj, "id"),
      getStr(obj, "title"),
      getStr(obj, "overview"),
      getStr(obj, "release_date"),
      getFloat(obj, "vote_average"),
      getStr(obj, "status"),
    ) {
    | (Some(id), Some(title), Some(overview), Some(releaseDate), Some(voteAverage), Some(status)) =>
      Some({
        id,
        title,
        tagline: getStr(obj, "tagline"),
        overview,
        backdropPath: getStr(obj, "backdrop_path"),
        posterPath: getStr(obj, "poster_path"),
        releaseDate,
        runtime: getInt(obj, "runtime"),
        genres: getGenreNames(obj, "genres"),
        voteAverage,
        status,
      })
    | _ => None
    }
  | _ => None
  }

let decodeTv = (json: JSON.t): option<tmdbTv> =>
  switch json {
  | JSON.Object(obj) =>
    switch (
      getInt(obj, "id"),
      getStr(obj, "name"),
      getStr(obj, "overview"),
      getStr(obj, "first_air_date"),
      getFloat(obj, "vote_average"),
      getStr(obj, "status"),
      getInt(obj, "number_of_seasons"),
    ) {
    | (Some(id), Some(name), Some(overview), Some(firstAirDate), Some(voteAverage), Some(status), Some(numberOfSeasons)) =>
      Some({
        id,
        name,
        tagline: getStr(obj, "tagline"),
        overview,
        backdropPath: getStr(obj, "backdrop_path"),
        posterPath: getStr(obj, "poster_path"),
        firstAirDate,
        episodeRunTime: getIntArray(obj, "episode_run_time"),
        genres: getGenreNames(obj, "genres"),
        voteAverage,
        status,
        numberOfSeasons,
      })
    | _ => None
    }
  | _ => None
  }

let tmdbImg = "https://image.tmdb.org/t/p"
let fallbackBackdrop = "https://picsum.photos/seed/detail-bg/1280/720"
let fallbackPoster = "https://picsum.photos/seed/detail-poster/400/600"

let parseYear = (dateStr: string): int =>
  dateStr->String.split("-")->Array.at(0)->Option.flatMap(s => Int.fromString(s))->Option.getOr(0)

let imgUrl = (size: string, path: option<string>, fallback: string): string =>
  path->Option.map(p => `${tmdbImg}${size}${p}`)->Option.getOr(fallback)

let round1dp = (f: float): float => Js.Math.round(f *. 10.) /. 10.

let tmdbFetch = async (path: string): option<JSON.t> =>
  switch Nullable.toOption(tmdbToken) {
  | None => None
  | Some(token) =>
    try {
      let res = await fetch(`https://api.themoviedb.org/3${path}`, {
        headers: Dict.fromArray([
          ("Authorization", `Bearer ${token}`),
          ("accept", "application/json"),
        ]),
        next: {revalidate: 3600},
      })
      if ok(res) {
        Some(await responseJson(res))
      } else {
        None
      }
    } catch {
    | _ => None
    }
  }

// Returns None on any failure (auth, network, schema mismatch) — page.tsx calls notFound().
@genType
let fetchMediaDetail = async (mediaType: string, id: string): option<AppTypes.mediaDetail> =>
  switch mediaType {
  | "movie" =>
    let raw = await tmdbFetch(`/movie/${id}?language=en-US`)
    raw->Option.flatMap(decodeMovie)->Option.map((m): AppTypes.mediaDetail => {
      id: `movie:${Int.toString(m.id)}`,
      tmdbType: "movie",
      title: m.title,
      tagline: m.tagline->Option.getOr(""),
      overview: m.overview,
      backdrop: imgUrl("/w1280", m.backdropPath, fallbackBackdrop),
      poster: imgUrl("/w500", m.posterPath, fallbackPoster),
      year: parseYear(m.releaseDate),
      runtime: m.runtime->Option.getOr(0),
      rating: round1dp(m.voteAverage),
      genres: m.genres,
      status: m.status,
      numberOfSeasons: 0,
    })

  | "tv" =>
    let raw = await tmdbFetch(`/tv/${id}?language=en-US`)
    raw->Option.flatMap(decodeTv)->Option.map((t): AppTypes.mediaDetail => {
      id: `tv:${Int.toString(t.id)}`,
      tmdbType: "tv",
      title: t.name,
      tagline: t.tagline->Option.getOr(""),
      overview: t.overview,
      backdrop: imgUrl("/w1280", t.backdropPath, fallbackBackdrop),
      poster: imgUrl("/w500", t.posterPath, fallbackPoster),
      year: parseYear(t.firstAirDate),
      runtime: t.episodeRunTime->Array.at(0)->Option.getOr(0),
      rating: round1dp(t.voteAverage),
      genres: t.genres,
      status: t.status,
      numberOfSeasons: t.numberOfSeasons,
    })

  | _ => None
  }
