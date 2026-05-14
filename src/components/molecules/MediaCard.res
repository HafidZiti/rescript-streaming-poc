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
}

@genType
@react.component
let make = (~media: AppTypes.media) =>
  <div className=Styles.card>
    <img className=Styles.image src=media.thumbnail alt=media.title />
    <RatingBadge rating=media.rating />
    <CategoryBadge category=media.category />
    <div className=Styles.overlay>
      <h3 className=Styles.title> {React.string(media.title)} </h3>
      <div className=Styles.meta>
        <span> {React.int(media.year)} </span>
        <span> {React.string("·")} </span>
        <span> {React.string(media.duration)} </span>
      </div>
    </div>
  </div>
