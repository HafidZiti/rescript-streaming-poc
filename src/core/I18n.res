// Flat record — add new keys here; the compiler will enforce every locale has them.
type t = {
  // Content-type badge labels
  badgeMovie: string,
  badgeTvShow: string,
  badgeLive: string,
  badgeDocumentary: string,
  badgeSeries: string,
  // Section headings
  sectionMovies: string,
  sectionTvShows: string,
  sectionSeries: string,
  sectionDocumentaries: string,
  sectionLive: string,
  // Hero
  heroTitle: string,
  searchPlaceholder: string,
  searchBtn: string,
  // Shared UI
  tagline: string,
  seeAll: string,
  noContent: string,
}

let en: t = {
  badgeMovie: "Movie",
  badgeTvShow: "TV Show",
  badgeLive: "● Live",
  badgeDocumentary: "Documentary",
  badgeSeries: "Series",
  sectionMovies: "Movies",
  sectionTvShows: "TV Shows",
  sectionSeries: "Series",
  sectionDocumentaries: "Documentaries",
  sectionLive: "Live",
  heroTitle: "Search your next great adventure.",
  searchPlaceholder: "Search for Movies, Series, Documentaries…",
  searchBtn: "Search",
  tagline: "Movies, Series & Live",
  seeAll: "See all",
  noContent: "No content available.",
}

let fr: t = {
  badgeMovie: "Film",
  badgeTvShow: "Série TV",
  badgeLive: "● Direct",
  badgeDocumentary: "Documentaire",
  badgeSeries: "Série",
  sectionMovies: "Films",
  sectionTvShows: "Séries TV",
  sectionSeries: "Séries",
  sectionDocumentaries: "Documentaires",
  sectionLive: "Direct",
  heroTitle: "Partez à la recherche de votre prochaine aventure.",
  searchPlaceholder: "Rechercher films, séries, documentaires…",
  searchBtn: "Rechercher",
  tagline: "Films, Séries & Direct",
  seeAll: "Voir tout",
  noContent: "Aucun contenu disponible.",
}

let useTranslation = (locale: string): t =>
  switch locale {
  | "fr" => fr
  | _ => en
  }
