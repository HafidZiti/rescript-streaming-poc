module Styles = {
  open CssJs
  open CssHelper

  let badge = style([
    position(#absolute),
    top(px(10)),
    right(px(10)),
    borderRadius(px(4)),
    padding2(~v=px(3), ~h=px(8)),
    fontSize(px(10)),
    fontWeight(#bold),
    color(hex("ffffff")),
    textTransform(#uppercase),
    letterSpacing(px(1)),
    zIndex(10),
  ])
}

let colorOf = (category: AppTypes.contentType, t: I18n.t): (string, string) =>
  switch category {
  | Movie       => (t.badgeMovie, "e50914")
  | TVShow      => (t.badgeTvShow, "0071eb")
  | Live        => (t.badgeLive, "00aa44")
  | Documentary => (t.badgeDocumentary, "b8860b")
  | Series      => (t.badgeSeries, "7c3aed")
  }

@react.component
let make = (~category: AppTypes.contentType) => {
  let {t} = I18nContext.useI18n()
  let (label, colorHex) = colorOf(category, t)
  let cls = {
    open CssJs
    open CssHelper
    merge([Styles.badge, style([backgroundColor(hex(colorHex))])])
  }
  <div className=cls> {React.string(label)} </div>
}
