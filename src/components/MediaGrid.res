module Styles = {
  @@warning("-44")
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
}


let byCategory = (movies, cat) =>
  movies->Array.filter(m => m.AppTypes.category == cat)

@genType
@react.component
let make = (~movies: array<AppTypes.media>) =>
  <div className=Styles.container>
    <Navbar />
    <HeroSection />
    <div className=Styles.sections>
      <MediaSection category=AppTypes.Movie       items={byCategory(movies, AppTypes.Movie)} />
      <MediaSection category=AppTypes.TVShow      items={byCategory(movies, AppTypes.TVShow)} />
      <MediaSection category=AppTypes.Series      items={byCategory(movies, AppTypes.Series)} />
      <MediaSection category=AppTypes.Documentary items={byCategory(movies, AppTypes.Documentary)} />
      <MediaSection category=AppTypes.Live        items={byCategory(movies, AppTypes.Live)} />
    </div>
  </div>
