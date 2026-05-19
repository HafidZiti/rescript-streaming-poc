// Flat record — add new keys here; the compiler will enforce every locale has them.
@genType
type t = {
  // Content-type badge labels
  badgeMovie: string,
  badgeTvShow: string,
  badgeLive: string,
  badgeDocumentary: string,
  badgeSeries: string,
  // Section headings
  popularMovies: string,
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
  trendingNow: string,
  searchResults: string,
  backToHome: string,
  detailRuntime: string,
  detailSeasons: string,
  // Error boundary
  errorTitle: string,
  errorFallback: string,
  errorRetry: string,
}

let en: t = {
  badgeMovie: "Movie",
  badgeTvShow: "TV Show",
  badgeLive: "● Live",
  badgeDocumentary: "Documentary",
  badgeSeries: "Series",
  popularMovies: "Popular Movies",
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
  trendingNow: "Trending Now",
  searchResults: "Search Results",
  backToHome: "← Back",
  detailRuntime: "Runtime",
  detailSeasons: "seasons",
  errorTitle: "Oops, something went wrong",
  errorFallback: "An unexpected error occurred.",
  errorRetry: "Retry",
}

let fr: t = {
  badgeMovie: "Film",
  badgeTvShow: "Série TV",
  badgeLive: "● Direct",
  badgeDocumentary: "Documentaire",
  badgeSeries: "Série",
  popularMovies: "Films populaires",
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
  trendingNow: "Tendances du moment",
  searchResults: "Résultats de recherche",
  backToHome: "← Retour",
  detailRuntime: "Durée",
  detailSeasons: "saisons",
  errorTitle: "Oops, quelque chose s'est mal passé",
  errorFallback: "Une erreur inattendue est survenue.",
  errorRetry: "Réessayer",
}

let useTranslation = (locale: string): t =>
  switch locale {
  | "fr" => fr
  | _ => en
  }
