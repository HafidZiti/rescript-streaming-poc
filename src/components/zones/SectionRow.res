module Styles = {
  open CssJs
  open CssHelper

  let noResults = style([
    textAlign(#center),
    padding2(~v=px(64), ~h=px(0)),
    color(rgba(255, 255, 255, 0.5)),
    fontSize(px(16)),
  ])
}

@genType
@react.component
let make = (
  ~titleKey: string,
  ~items: array<AppTypes.media>,
  ~showDot: bool=false,
  ~limit: int=0,
) => {
  let {t} = I18nContext.useI18n()
  if Array.length(items) === 0 && titleKey === "searchResults" {
    <p className=Styles.noResults> {React.string(t.noResults)} </p>
  } else {
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
}
