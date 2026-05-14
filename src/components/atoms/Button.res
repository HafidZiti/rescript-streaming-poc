module Styles = {
  open CssJs
  open CssHelper

  let btn = style([
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
let make = (~label: string, ~onClick: unit => unit) =>
  <button className=Styles.btn onClick={_ => onClick()}>
    {React.string(label)}
  </button>
