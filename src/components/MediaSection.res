let limit = 6

module Styles = {
  @@warning("-44")
  open CssJs
  open CssHelper

  let section = style([
    marginBottom(px(48)),
  ])

  let sectionHeader = style([
    display(#flex),
    alignItems(#center),
    justifyContent(#spaceBetween),
    marginBottom(px(16)),
    padding2(~v=px(0), ~h=px(36)),
  ])

  let title = style([
    color(hex("ffffff")),
    fontSize(px(18)),
    fontWeight(#num(700)),
    margin(zero),
    letterSpacing(px(1)),
  ])

  let seeAllBtn = style([
    backgroundColor(#transparent),
    borderStyle(#none),
    color(hex("e50914")),
    fontSize(px(13)),
    fontWeight(#num(600)),
    letterSpacing(px(1)),
    cursor(#pointer),
    transition(~duration=ms(150.), ~timingFunction=#ease, "color"),
    hover([color(hex("ff4444"))]),
  ])

  // Horizontal scroll strip — no visible scrollbar on webkit
  let row = style([
    display(#flex),
    flexDirection(#row),
    gap(px(16)),
    overflowX(#auto),
    paddingLeft(px(36)),
    paddingRight(px(36)),
    paddingBottom(px(12)),
  ])

  // Fixed-width wrapper so cards don't squish inside the flex row
  let cardWrapper = style([
    minWidth(px(200)),
    maxWidth(px(260)),
    flexShrink(0.),
    flexGrow(0.),
    width(pct(30.)),
  ])
}

@react.component
let make = (~category: AppTypes.contentType, ~items: array<AppTypes.media>) => {
  let {t} = I18nContext.useI18n()
  let (expanded, setExpanded) = React.useState(() => false)

  let title = switch category {
  | Movie       => t.sectionMovies
  | TVShow      => t.sectionTvShows
  | Series      => t.sectionSeries
  | Documentary => t.sectionDocumentaries
  | Live        => t.sectionLive
  }

  let hasMore = Array.length(items) > limit

  let displayed = if expanded {
    items
  } else {
    items->Array.filterWithIndex((_item, i) => i < limit)
  }

  if Array.length(items) == 0 {
    React.null
  } else {
    <div className=Styles.section>
      <div className=Styles.sectionHeader>
        <h2 className=Styles.title> {React.string(title)} </h2>
        {hasMore && !expanded
          ? <button
              className=Styles.seeAllBtn
              onClick={_ => setExpanded(_ => true)}>
              {React.string(t.seeAll)}
            </button>
          : React.null}
      </div>
      <div className=Styles.row>
        {displayed
          ->Array.map(item =>
            <div key=item.id className=Styles.cardWrapper>
              <MediaCard media=item />
            </div>
          )
          ->React.array}
      </div>
    </div>
  }
}
