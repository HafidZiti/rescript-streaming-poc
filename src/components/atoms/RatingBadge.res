module Styles = {
  open CssJs
  open CssHelper

  let badge = style([
    position(#absolute),
    top(px(10)),
    left(px(10)),
    display(#flex),
    alignItems(#center),
    gap(px(4)),
    backgroundColor(rgba(0, 0, 0, 0.72)),
    unsafe("backdropFilter", "blur(4px)"),
    borderRadius(px(6)),
    padding2(~v=px(4), ~h=px(8)),
    fontSize(px(12)),
    fontWeight(#bold),
    color(hex("ffffff")),
    zIndex(10),
  ])

  let star = style([
    color(hex("fbbf24")),
  ])
}

// Format float rating to one decimal, e.g. 4.8 -> "4.8"
let format = (r: float): string => {
  let rounded = Js.Math.round(r *. 10.) /. 10.
  let whole = rounded->Belt.Float.toInt
  let dec = ((rounded -. whole->Belt.Int.toFloat) *. 10.)->Belt.Float.toInt
  Belt.Int.toString(whole) ++ "." ++ Belt.Int.toString(dec)
}

@react.component
let make = (~rating: float) =>
  <div className=Styles.badge>
    <span className=Styles.star> {React.string("★")} </span>
    {React.string(format(rating))}
  </div>
