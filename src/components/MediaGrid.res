module Styles = {
  open CssJs
  open CssHelper

  let container = style([
    backgroundColor(hex("0a0a0f")),
    minHeight(vh(100.)),
  ])

  let sections = style([
    paddingTop(px(16)),
    paddingBottom(px(48)),
  ])

  let emptyState = style([
    display(#flex),
    justifyContent(#center),
    alignItems(#center),
    padding2(~v=px(80), ~h=px(0)),
    color(rgba(255, 255, 255, 0.4)),
    fontSize(px(18)),
  ])
}


let byCategory = (movies, cat) =>
  movies->Array.filter(m => m.AppTypes.category == cat)

@genType
@react.component
let make = (~movies: array<AppTypes.media>) => {
  let {t} = I18nContext.useI18n()
  let (activeQuery, setActiveQuery) = React.useState(() => "")

  let handleSearch = (q: string) =>
    setActiveQuery(_ => String.toLowerCase(String.trim(q)))

  let filtered = if activeQuery == "" {
    movies
  } else {
    movies->Array.filter(m =>
      String.includes(String.toLowerCase(m.title), activeQuery) ||
      String.includes(String.toLowerCase(m.description), activeQuery)
    )
  }

  let sections = if Array.length(filtered) == 0 && activeQuery != "" {
    <div className=Styles.emptyState> {React.string(t.noContent)} </div>
  } else {
    <>
      <MediaSection category=AppTypes.Movie       items={byCategory(filtered, AppTypes.Movie)} />
      <MediaSection category=AppTypes.TVShow      items={byCategory(filtered, AppTypes.TVShow)} />
      <MediaSection category=AppTypes.Series      items={byCategory(filtered, AppTypes.Series)} />
      <MediaSection category=AppTypes.Documentary items={byCategory(filtered, AppTypes.Documentary)} />
      <MediaSection category=AppTypes.Live        items={byCategory(filtered, AppTypes.Live)} />
    </>
  }

  <div className=Styles.container>
    <Navbar />
    <HeroSection onSearch=handleSearch />
    <div className=Styles.sections>
      {sections}
    </div>
  </div>
}
