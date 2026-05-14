module Styles = {
  open CssJs
  open CssHelper

  let section = style([
    marginBottom(px(48)),
  ])

  let header = style([
    display(#flex),
    alignItems(#center),
    justifyContent(#spaceBetween),
    marginBottom(px(16)),
    padding2(~v=px(0), ~h=px(36)),
  ])

  let headerLeft = style([
    display(#flex),
    alignItems(#center),
    gap(px(10)),
  ])

  let dot = style([
    width(px(8)),
    height(px(8)),
    borderRadius(pct(50.)),
    backgroundColor(hex("e50914")),
    flexShrink(0.),
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

  let row = style([
    display(#flex),
    flexDirection(#row),
    gap(px(16)),
    overflowX(#auto),
    paddingLeft(px(36)),
    paddingRight(px(36)),
    paddingBottom(px(12)),
    unsafe("scrollbarWidth", "thin"),
    unsafe("scrollbarColor", "#444 transparent"),
    selector("::-webkit-scrollbar", [height(px(4))]),
    selector("::-webkit-scrollbar-track", [unsafe("background", "transparent")]),
    selector("::-webkit-scrollbar-thumb", [
      unsafe("background", "#444"),
      unsafe("borderRadius", "2px"),
    ]),
    selector("::-webkit-scrollbar-thumb:hover", [unsafe("background", "#666")]),
  ])

  let cardWrapper = style([
    minWidth(px(200)),
    maxWidth(px(260)),
    flexShrink(0.),
    flexGrow(0.),
    width(pct(30.)),
  ])
}

@react.component
let make = (
  ~title: string,
  ~items: array<AppTypes.media>,
  ~showDot: bool=false,
  ~limit: int=0,
) => {
  let {t} = I18nContext.useI18n()
  let (expanded, setExpanded) = React.useState(() => false)

  let hasMore = limit > 0 && Array.length(items) > limit

  let displayed = if limit > 0 && !expanded {
    items->Array.filterWithIndex((_item, i) => i < limit)
  } else {
    items
  }

  if Array.length(items) == 0 {
    React.null
  } else {
    <div className=Styles.section>
      <div className=Styles.header>
        <div className=Styles.headerLeft>
          {showDot ? <div className=Styles.dot /> : React.null}
          <h2 className=Styles.title> {React.string(title)} </h2>
        </div>
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
