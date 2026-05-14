module Styles = {
  open CssJs
  open CssHelper

  let hero = style([
    position(#relative),
    width(pct(100.)),
    height(px(520)),
    display(#flex),
    alignItems(#center),
    justifyContent(#center),
    overflow(#hidden),
    unsafe("background", "url('/background-img.webp') center/cover no-repeat"),
  ])

  let overlay = style([
    position(#absolute),
    top(px(0)),
    left(px(0)),
    right(px(0)),
    bottom(px(0)),
    unsafe(
      "background",
      "linear-gradient(to bottom, rgba(0,0,0,0.25) 0%, rgba(10,10,15,0.97) 100%)",
    ),
  ])

  let content = style([
    position(#relative),
    zIndex(10),
    display(#flex),
    flexDirection(#column),
    alignItems(#center),
    unsafe("textAlign", "center"),
    padding2(~v=px(0), ~h=px(24)),
    width(pct(100.)),
    maxWidth(px(740)),
  ])

  let title = style([
    color(hex("ffffff")),
    fontSize(px(44)),
    fontWeight(#bold),
    margin(zero),
    marginBottom(px(36)),
    unsafe("lineHeight", "1.15"),
    unsafe("textShadow", "0 2px 24px rgba(0,0,0,0.7)"),
  ])
}

@react.component
let make = (~onSearch: string => unit) => {
  let {t} = I18nContext.useI18n()

  <div className=Styles.hero>
    <div className=Styles.overlay />
    <div className=Styles.content>
      <h1 className=Styles.title> {React.string(t.heroTitle)} </h1>
      <SearchBar
        placeholder=t.searchPlaceholder
        btnLabel=t.searchBtn
        onSearch
      />
    </div>
  </div>
}
