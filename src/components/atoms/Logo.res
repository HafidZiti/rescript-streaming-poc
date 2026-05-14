module Styles = {
  open CssJs
  open CssHelper

  let wrapper = style([
    display(#flex),
    alignItems(#center),
    gap(px(12)),
    cursor(#default),
  ])

  let icon = style([
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

  let text = style([
    fontSize(px(20)),
    fontWeight(#bold),
    color(hex("ffffff")),
    letterSpacing(px(1)),
  ])
}

@react.component
let make = () =>
  <div className=Styles.wrapper>
    <div className=Styles.icon> {React.string("S")} </div>
    <span className=Styles.text> {React.string("Streamify")} </span>
  </div>
