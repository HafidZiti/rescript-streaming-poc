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
