@val external fetchApi: string => Promise.t<'res> = "fetch"
@send external toJson: 'res => Promise.t<Js.Json.t> = "json"
@val external encodeURIComponent: string => string = "encodeURIComponent"

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

@genType
@react.component
let make = (
  ~trendingItems: array<AppTypes.media>,
  ~seriesItems: array<AppTypes.media>,
  ~docsItems: array<AppTypes.media>,
  ~tvShowItems: array<AppTypes.media>,
  ~popularMoviesItems: array<AppTypes.media>,
) => {
  let {t} = I18nContext.useI18n()
  let (activeQuery, setActiveQuery) = React.useState(() => "")
  let (searchItems, setSearchItems) = React.useState(() => [])
  let (loading, setLoading) = React.useState(() => false)

  let handleSearch = (q: string) => {
    let query = String.toLowerCase(String.trim(q))
    setActiveQuery(_ => query)
    if query != "" {
      setLoading(_ => true)
      setSearchItems(_ => [])
      let url = "/api/search?q=" ++ encodeURIComponent(query)
      let _ = fetchApi(url)
        ->Promise.then(res => res->toJson)
        ->Promise.then(data => {
          setSearchItems(_ => Obj.magic(data))
          setLoading(_ => false)
          Promise.resolve()
        })
        ->Promise.catch(_ => {
          setLoading(_ => false)
          Promise.resolve()
        })
    }
  }

  let mainContent = if activeQuery != "" {
    if loading {
      <Spinner />
    } else if Array.length(searchItems) == 0 {
      <div className=Styles.emptyState> {React.string(t.noContent)} </div>
    } else {
      <ContentRow title=t.searchResults items=searchItems />
    }
  } else {
    <>
      <ContentRow title=t.popularMovies        items=popularMoviesItems limit=6 />
      <ContentRow title=t.sectionTvShows       items=tvShowItems        limit=6 />
      <ContentRow title=t.sectionSeries        items=seriesItems        limit=6 />
      <ContentRow title=t.sectionDocumentaries items=docsItems          limit=6 />
    </>
  }

  <div className=Styles.container>
    <Navbar />
    <HeroSection onSearch=handleSearch />
    {activeQuery == ""
      ? <ContentRow title=t.trendingNow items=trendingItems showDot=true />
      : React.null}
    <div className=Styles.sections>
      {mainContent}
    </div>
  </div>
}
