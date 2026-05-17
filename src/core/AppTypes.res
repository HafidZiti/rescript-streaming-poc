@genType
type contentType =
  | Movie
  | TVShow
  | Live
  | Documentary
  | Series

@genType
type media = {
  id: string,
  title: string,
  thumbnail: string,
  category: contentType,
  description: string,
  year: int,
  duration: string,
  rating: float,
}

@genType
type mediaDetail = {
  id: string,
  tmdbType: string,
  title: string,
  tagline: string,
  overview: string,
  backdrop: string,
  poster: string,
  year: int,
  runtime: int,
  rating: float,
  genres: array<string>,
  status: string,
  numberOfSeasons: int,
}
