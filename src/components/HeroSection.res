module Styles = {
  @@warning("-44")
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

  let searchBar = style([
    display(#flex),
    width(pct(100.)),
    borderRadius(px(50)),
    overflow(#hidden),
    boxShadow(Shadow.box(~y=px(4), ~blur=px(32), rgba(0, 0, 0, 0.6))),
  ])

  let searchInput = style([
    flexGrow(1.),
    padding2(~v=px(18), ~h=px(28)),
    backgroundColor(rgba(65, 64, 64, 0.1)),
    unsafe("backdropFilter", "blur(8px)"),
    unsafe("border", "none"),
    color(hex("ffffff")),
    fontSize(px(15)),
    unsafe("outline", "none"),
    selector("::placeholder", [color(rgba(255, 255, 255, 0.6))]),
  ])

  let searchBtn = style([
    padding2(~v=px(18), ~h=px(32)),
    backgroundColor(hex("e50914")),
    unsafe("border", "none"),
    color(hex("ffffff")),
    fontSize(px(15)),
    fontWeight(#bold),
    cursor(#pointer),
    unsafe("whiteSpace", "nowrap"),
    transition(~duration=ms(180.), ~timingFunction=#ease, "background-color"),
    hover([backgroundColor(hex("cc0812"))]),
  ])
}

@react.component
let make = (~onSearch: string => unit) => {
  let {t} = I18nContext.useI18n()
  let (query, setQuery) = React.useState(() => "")

  let handleSearch = () => onSearch(query)

  <div className=Styles.hero>
    <div className=Styles.overlay />
    <div className=Styles.content>
      <h1 className=Styles.title> {React.string(t.heroTitle)} </h1>
      <div className=Styles.searchBar>
        <input
          className=Styles.searchInput
          type_="text"
          placeholder=t.searchPlaceholder
          value=query
          onChange={e => setQuery(_ => ReactEvent.Form.target(e)["value"])}
          onKeyDown={e => {
            if ReactEvent.Keyboard.key(e) == "Enter" {
              handleSearch()
            }
          }}
        />
        <button className=Styles.searchBtn onClick={_ => handleSearch()}>
          {React.string(t.searchBtn)}
        </button>
      </div>
    </div>
  </div>
}
