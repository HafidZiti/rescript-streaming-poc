@genType
@react.component
let make = (
  ~titleKey: string,
  ~items: array<AppTypes.media>,
  ~showDot: bool=false,
  ~limit: int=0,
) => {
  let {t} = I18nContext.useI18n()
  let title = switch titleKey {
  | "trendingNow" => t.trendingNow
  | "popularMovies" => t.popularMovies
  | "sectionSeries" => t.sectionSeries
  | "sectionDocumentaries" => t.sectionDocumentaries
  | "sectionTvShows" => t.sectionTvShows
  | "searchResults" => t.searchResults
  | _ => titleKey
  }
  <ContentRow title items showDot limit />
}
