

module Styles = {
  open CssJs
  open CssHelper

  let card = style([
    position(#relative),
    width(pct(100.)),
    borderRadius(px(10)),
    overflow(#hidden),
    cursor(#pointer),
    backgroundColor(hex("131320")),
    transition(~duration=ms(280.), ~timingFunction=#ease, "transform"),
    boxShadow(Shadow.box(~y=px(4), ~blur=px(20), rgba(0, 0, 0, 0.5))),
    hover([
      transform(scale(1.04, 1.04)),
      boxShadow(Shadow.box(~y=px(8), ~blur=px(36), rgba(0, 0, 0, 0.8))),
    ]),
  ])

  let image = style([
    width(pct(100.)),
    height(px(290)),
    objectFit(#cover),
    display(#block),
  ])

  let overlay = style([
    position(#absolute),
    bottom(px(0)),
    left(px(0)),
    right(px(0)),
    padding2(~v=px(14), ~h=px(14)),
    unsafe("background", "linear-gradient(to top, rgba(0,0,0,0.92) 0%, transparent 100%)"),
  ])

  let title = style([
    color(hex("ffffff")),
    fontSize(px(14)),
    fontWeight(#num(700)),
    margin(zero),
    marginBottom(px(4)),
    unsafe("whiteSpace", "nowrap"),
    overflow(#hidden),
    unsafe("textOverflow", "ellipsis"),
  ])

  let meta = style([
    display(#flex),
    alignItems(#center),
    gap(px(6)),
    fontSize(px(12)),
    color(rgba(255, 255, 255, 0.5)),
  ])

  let ratingBadge = style([
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

  let categoryBadge = style([
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


let getBadgeInfo = (category: AppTypes.contentType, t: I18n.t): (string, string) =>
  switch category {
  | Movie       => (t.badgeMovie, "e50914")
  | TVShow      => (t.badgeTvShow, "0071eb")
  | Live        => (t.badgeLive, "00aa44")
  | Documentary => (t.badgeDocumentary, "b8860b")
  | Series      => (t.badgeSeries, "7c3aed")
  }

// Format float rating to one decimal, e.g. 4.8 -> "4.8"
let formatRating = (r: float): string => {
  let rounded = Js.Math.round(r *. 10.) /. 10.
  let whole = rounded->Belt.Float.toInt
  let dec = ((rounded -. whole->Belt.Int.toFloat) *. 10.)->Belt.Float.toInt
  Belt.Int.toString(whole) ++ "." ++ Belt.Int.toString(dec)
}

@genType
@react.component
let make = (~media: AppTypes.media) => {
  let {t} = I18nContext.useI18n()
  let (badgeLabel, colorHex) = getBadgeInfo(media.category, t)

  let categoryBadgeCls = {
    open CssJs
    open CssHelper
    merge([Styles.categoryBadge, style([backgroundColor(hex(colorHex))])])
  }

  <div className=Styles.card>
    <img className=Styles.image src=media.thumbnail alt=media.title />

    <div className=Styles.ratingBadge>
      <span className=Styles.star> {React.string("★")} </span>
      {React.string(formatRating(media.rating))}
    </div>

    <div className=categoryBadgeCls> {React.string(badgeLabel)} </div>

    <div className=Styles.overlay>
      <h3 className=Styles.title> {React.string(media.title)} </h3>
      <div className=Styles.meta>
        <span> {React.int(media.year)} </span>
        <span> {React.string("·")} </span>
        <span> {React.string(media.duration)} </span>
      </div>
    </div>
  </div>
}
