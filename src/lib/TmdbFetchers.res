// ISR fetch binding (Next.js extended fetch with revalidate)
type nextCacheOpts = {revalidate: int}
type isrInit = {headers: Dict.t<string>, next: nextCacheOpts}

// No-store fetch for search (real-time, not cached)
type noStoreInit = {headers: Dict.t<string>, cache: string}

type response
@get external ok: response => bool = "ok"
@send external responseJson: response => promise<JSON.t> = "json"
@val external fetchIsr: (string, isrInit) => promise<response> = "fetch"
@val external fetchNoStore: (string, noStoreInit) => promise<response> = "fetch"
@val external tmdbToken: Nullable.t<string> = "process.env.TMDB_READ_ACCESS_TOKEN"
@val external encodeURIComponent: string => string = "encodeURIComponent"

// ─── Content safety ───────────────────────────────────────────────────────────

type regExp
@new external makeRegExp: (string, string) => regExp = "RegExp"
@send external testRe: (regExp, string) => bool = "test"

let blockedRe = makeRegExp(
  "\\bporn\\b|\\bpornhub\\b|\\bxxx\\b|\\berotic\\b|\\bhentai\\b|\\bnude\\b|\\bnudity\\b",
  "i",
)

let isSafe = (title: string, adult: option<bool>): bool =>
  switch adult {
  | Some(true) => false
  | _ => !testRe(blockedRe, title)
  }

// ─── JSON field readers ───────────────────────────────────────────────────────

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

let getBool = (obj: Dict.t<JSON.t>, key: string): option<bool> =>
  obj->Dict.get(key)->Option.flatMap(v =>
    switch v {
    | JSON.Boolean(b) => Some(b)
    | _ => None
    }
  )

// ─── Shared mappers ───────────────────────────────────────────────────────────

let tmdbImg = "https://image.tmdb.org/t/p/w500"

let parseYear = (dateStr: string): int =>
  dateStr->String.split("-")->Array.at(0)->Option.flatMap(s => Int.fromString(s))->Option.getOr(0)

let thumbUrl = (path: option<string>, fallback: string): string =>
  path->Option.map(p => `${tmdbImg}${p}`)->Option.getOr(fallback)

let round1dp = (f: float): float => Js.Math.round(f *. 10.) /. 10.

// Take at most n items (applied after filterMap so we cap on safe results only)
let take20 = (arr: array<'a>): array<'a> =>
  arr->Array.filterWithIndex((_item, i) => i < 20)

// ─── Item decoders ────────────────────────────────────────────────────────────

// Decodes a TMDB movie shape. Returns None on missing required fields or unsafe content.
let parseMovieItem = (json: JSON.t, category: AppTypes.contentType, fallback: string): option<AppTypes.media> =>
  switch json {
  | JSON.Object(obj) =>
    switch (getInt(obj, "id"), getStr(obj, "title"), getFloat(obj, "vote_average")) {
    | (Some(id), Some(title), Some(rating)) when isSafe(title, getBool(obj, "adult")) =>
      Some({
        id: `movie:${Int.toString(id)}`,
        title,
        thumbnail: thumbUrl(getStr(obj, "poster_path"), fallback),
        category,
        description: getStr(obj, "overview")->Option.getOr(""),
        year: parseYear(getStr(obj, "release_date")->Option.getOr("")),
        duration: "N/A",
        rating: round1dp(rating),
      })
    | _ => None
    }
  | _ => None
  }

// Decodes a TMDB TV show shape.
let parseTvItem = (json: JSON.t, category: AppTypes.contentType, fallback: string): option<AppTypes.media> =>
  switch json {
  | JSON.Object(obj) =>
    switch (getInt(obj, "id"), getStr(obj, "name"), getFloat(obj, "vote_average")) {
    | (Some(id), Some(name), Some(rating)) when isSafe(name, getBool(obj, "adult")) =>
      Some({
        id: `tv:${Int.toString(id)}`,
        title: name,
        thumbnail: thumbUrl(getStr(obj, "poster_path"), fallback),
        category,
        description: getStr(obj, "overview")->Option.getOr(""),
        year: parseYear(getStr(obj, "first_air_date")->Option.getOr("")),
        duration: "N/A",
        rating: round1dp(rating),
      })
    | _ => None
    }
  | _ => None
  }

// Decodes a /search/multi result item. Persons have no media_type "movie"/"tv" → None.
let parseSearchItem = (json: JSON.t): option<AppTypes.media> =>
  switch json {
  | JSON.Object(obj) =>
    switch getStr(obj, "media_type") {
    | Some("movie") =>
      switch (getInt(obj, "id"), getStr(obj, "title"), getFloat(obj, "vote_average")) {
      | (Some(id), Some(title), Some(rating)) when isSafe(title, getBool(obj, "adult")) =>
        Some({
          id: `movie:${Int.toString(id)}`,
          title,
          thumbnail: thumbUrl(getStr(obj, "poster_path"), "https://picsum.photos/seed/search/400/600"),
          category: AppTypes.Movie,
          description: getStr(obj, "overview")->Option.getOr(""),
          year: parseYear(getStr(obj, "release_date")->Option.getOr("")),
          duration: "N/A",
          rating: round1dp(rating),
        })
      | _ => None
      }
    | Some("tv") =>
      switch (getInt(obj, "id"), getStr(obj, "name"), getFloat(obj, "vote_average")) {
      | (Some(id), Some(name), Some(rating)) when isSafe(name, getBool(obj, "adult")) =>
        Some({
          id: `tv:${Int.toString(id)}`,
          title: name,
          thumbnail: thumbUrl(getStr(obj, "poster_path"), "https://picsum.photos/seed/search/400/600"),
          category: AppTypes.TVShow,
          description: getStr(obj, "overview")->Option.getOr(""),
          year: parseYear(getStr(obj, "first_air_date")->Option.getOr("")),
          duration: "N/A",
          rating: round1dp(rating),
        })
      | _ => None
      }
    | _ => None
    }
  | _ => None
  }

// ─── Network layer ────────────────────────────────────────────────────────────

// Fetches a TMDB list endpoint and extracts the `results` array.
let fetchListItems = async (url: string): array<JSON.t> =>
  switch Nullable.toOption(tmdbToken) {
  | None => []
  | Some(token) =>
    try {
      let res = await fetchIsr(url, {
        headers: Dict.fromArray([
          ("Authorization", `Bearer ${token}`),
          ("accept", "application/json"),
        ]),
        next: {revalidate: 3600},
      })
      if ok(res) {
        switch await responseJson(res) {
        | JSON.Object(obj) =>
          switch obj->Dict.get("results") {
          | Some(JSON.Array(arr)) => arr
          | _ => []
          }
        | _ => []
        }
      } else {
        []
      }
    } catch {
    | _ => []
    }
  }

// ─── Public API ───────────────────────────────────────────────────────────────

@genType
let fetchTrending = async (): array<AppTypes.media> =>
  (await fetchListItems(
    "https://api.themoviedb.org/3/trending/movie/day?language=en-US&include_adult=false",
  ))
  ->Array.filterMap(json => parseMovieItem(json, AppTypes.Movie, "https://picsum.photos/seed/placeholder/400/600"))
  ->take20

@genType
let fetchPopularMovies = async (): array<AppTypes.media> =>
  (await fetchListItems(
    "https://api.themoviedb.org/3/movie/popular?language=en-US&include_adult=false",
  ))
  ->Array.filterMap(json => parseMovieItem(json, AppTypes.Movie, "https://picsum.photos/seed/movie-placeholder/400/600"))
  ->take20

@genType
let fetchDocumentaries = async (): array<AppTypes.media> =>
  (await fetchListItems(
    "https://api.themoviedb.org/3/discover/movie?with_genres=99&language=en-US&sort_by=popularity.desc&include_adult=false&without_keywords=4344,155477",
  ))
  ->Array.filterMap(json => parseMovieItem(json, AppTypes.Documentary, "https://picsum.photos/seed/doc-placeholder/400/600"))
  ->take20

@genType
let fetchSeries = async (): array<AppTypes.media> =>
  (await fetchListItems(
    "https://api.themoviedb.org/3/trending/tv/day?language=en-US&include_adult=false",
  ))
  ->Array.filterMap(json => parseTvItem(json, AppTypes.Series, "https://picsum.photos/seed/tv-placeholder/400/600"))
  ->take20

@genType
let fetchTvShows = async (): array<AppTypes.media> =>
  (await fetchListItems(
    "https://api.themoviedb.org/3/tv/top_rated?language=en-US&include_adult=false",
  ))
  ->Array.filterMap(json => parseTvItem(json, AppTypes.TVShow, "https://picsum.photos/seed/tvshow-placeholder/400/600"))
  ->take20

@genType
let searchTmdb = async (query: string): array<AppTypes.media> => {
  if String.trim(query) == "" {
    []
  } else {
    switch Nullable.toOption(tmdbToken) {
    | None => []
    | Some(token) =>
      try {
        let url = `https://api.themoviedb.org/3/search/multi?query=${encodeURIComponent(query)}&include_adult=false&language=en-US`
        let res = await fetchNoStore(url, {
          headers: Dict.fromArray([
            ("Authorization", `Bearer ${token}`),
            ("accept", "application/json"),
          ]),
          cache: "no-store",
        })
        if ok(res) {
          switch await responseJson(res) {
          | JSON.Object(obj) =>
            switch obj->Dict.get("results") {
            | Some(JSON.Array(arr)) => arr->Array.filterMap(parseSearchItem)->take20
            | _ => []
            }
          | _ => []
          }
        } else {
          []
        }
      } catch {
      | _ => []
      }
    }
  }
}
