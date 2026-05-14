module Styles = {
  open CssJs
  open CssHelper

  let nav = style([
    display(#flex),
    alignItems(#center),
    justifyContent(#spaceBetween),
    padding2(~v=px(16), ~h=px(36)),
    backgroundColor(rgba(10, 10, 15, 0.80)),
    unsafe("position", "sticky"),
    top(px(0)),
    zIndex(100),
    unsafe("backdropFilter", "blur(16px)"),
    unsafe("WebkitBackdropFilter", "blur(16px)"),
    borderBottom(px(1), #solid, rgba(255, 255, 255, 0.06)),
  ])

  let logo = style([
    display(#flex),
    alignItems(#center),
    gap(px(12)),
    cursor(#default),
  ])

  let logoIcon = style([
    width(px(36)),
    height(px(36)),
    borderRadius(pct(50.)),
    backgroundColor(hex("e50914")),
    display(#flex),
    alignItems(#center),
    justifyContent(#center),
    fontSize(px(16)),
    fontWeight(#bold),
    color(hex("ffffff")),
    unsafe("lineHeight", "1"),
    unsafe("userSelect", "none"),
  ])

  let logoText = style([
    fontSize(px(20)),
    fontWeight(#bold),
    color(hex("ffffff")),
    letterSpacing(px(1)),
  ])
}

@react.component
let make = () =>
  <nav className=Styles.nav>
    <div className=Styles.logo>
      <div className=Styles.logoIcon> {React.string("S")} </div>
      <span className=Styles.logoText> {React.string("Streamify")} </span>
    </div>
    <LocaleSwitcher />
  </nav>
