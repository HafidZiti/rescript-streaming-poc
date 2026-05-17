module Styles = {
  open CssJs
  open CssHelper

  let page = style([
    backgroundColor(hex("0a0a0f")),
    minHeight(vh(100.)),
    color(hex("ffffff")),
    fontFamily(#custom("inherit")),
  ])

  let backdrop = style([
    position(#relative),
    width(pct(100.)),
    height(vh(58.)),
    overflow(#hidden),
    media(md, [height(vh(46.))]),
    media(sm, [height(vh(36.))]),
  ])

  let backdropImg = style([
    width(pct(100.)),
    height(pct(100.)),
    objectFit(#cover),
    display(#block),
    opacity(0.45),
  ])

  let backdropGradient = style([
    position(#absolute),
    top(px(0)),
    left(px(0)),
    right(px(0)),
    bottom(px(0)),
    // Complex multi-stop gradient — unsafe is justified here
    unsafe(
      "background",
      "linear-gradient(to bottom, rgba(10,10,15,0.25) 0%, rgba(10,10,15,0.65) 55%, rgba(10,10,15,1) 100%)",
    ),
  ])

  // Touch-friendly on mobile: padding enlarges the tap target without
  // affecting visual position; negative margin compensates for layout.
  let backBtn = style([
    position(#absolute),
    top(px(28)),
    left(px(40)),
    color(hex("ffffff")),
    textDecoration(#none),
    unsafe("WebkitTapHighlightColor", "transparent"),
    fontSize(px(14)),
    fontWeight(#num(600)),
    zIndex(10),
    display(#inlineFlex),
    alignItems(#center),
    gap(px(6)),
    opacity(0.75),
    letterSpacing(em(0.03)),
    hover([opacity(1.)]),
    media(md, [left(px(24)), top(px(24))]),
    media(sm, [
      left(px(8)),
      top(px(8)),
      fontSize(px(13)),
      padding2(~v=px(10), ~h=px(10)),
      margin2(~v=px(-10), ~h=px(-10)),
    ]),
  ])

  let content = style([
    maxWidth(px(1100)),
    margin2(~v=px(0), ~h=#auto),
    paddingLeft(px(40)),
    paddingRight(px(40)),
    unsafe("marginTop", "-140px"),
    position(#relative),
    zIndex(5),
    paddingBottom(px(80)),
    media(md, [
      paddingLeft(px(24)),
      paddingRight(px(24)),
      unsafe("marginTop", "-110px"),
    ]),
    media(sm, [
      paddingLeft(px(16)),
      paddingRight(px(16)),
      unsafe("marginTop", "-64px"),
      paddingBottom(px(52)),
    ]),
  ])

  let row = style([
    display(#flex),
    flexDirection(#row),
    gap(px(44)),
    alignItems(#flexStart),
    media(md, [gap(px(28))]),
    media(sm, [
      flexDirection(#column),
      alignItems(#center),
      gap(px(20)),
    ]),
  ])

  let poster = style([
    width(px(210)),
    borderRadius(px(12)),
    flexShrink(0.),
    display(#block),
    boxShadow(Shadow.box(~x=px(0), ~y=px(8), ~blur=px(40), rgba(0, 0, 0, 0.75))),
    media(md, [width(px(170))]),
    media(sm, [
      width(pct(45.)),
      maxWidth(px(180)),
    ]),
  ])

  let info = style([
    display(#flex),
    flexDirection(#column),
    gap(px(18)),
    paddingTop(px(16)),
    minWidth(px(0)),
    media(sm, [
      paddingTop(px(0)),
      width(pct(100.)),
      gap(px(14)),
    ]),
  ])

  let title = style([
    color(hex("ffffff")),
    fontSize(px(38)),
    fontWeight(#num(800)),
    unsafe("lineHeight", "1.15"),
    margin(zero),
    letterSpacing(em(-0.01)),
    media(md, [fontSize(px(30))]),
    media(sm, [fontSize(px(22)), letterSpacing(zero)]),
  ])

  let tagline = style([
    color(rgba(255, 255, 255, 0.55)),
    fontStyle(#italic),
    fontSize(px(17)),
    margin(zero),
    unsafe("lineHeight", "1.5"),
    media(md, [fontSize(px(15))]),
    media(sm, [fontSize(px(14))]),
  ])

  let meta = style([
    display(#flex),
    flexDirection(#row),
    alignItems(#center),
    gap(px(12)),
    color(rgba(255, 255, 255, 0.55)),
    fontSize(px(14)),
    fontWeight(#num(500)),
    flexWrap(#wrap),
    media(sm, [fontSize(px(13)), gap(px(8))]),
  ])

  let metaSep = style([
    color(rgba(255, 255, 255, 0.25)),
  ])

  let rating = style([
    color(hex("f5c518")),
    fontWeight(#num(700)),
    fontSize(px(15)),
    media(sm, [fontSize(px(14))]),
  ])

  let genres = style([
    display(#flex),
    flexDirection(#row),
    flexWrap(#wrap),
    gap(px(8)),
  ])

  let genre = style([
    backgroundColor(rgba(255, 255, 255, 0.08)),
    border(px(1), #solid, rgba(255, 255, 255, 0.15)),
    borderRadius(px(20)),
    paddingTop(px(4)),
    paddingBottom(px(4)),
    paddingLeft(px(12)),
    paddingRight(px(12)),
    fontSize(px(12)),
    fontWeight(#num(600)),
    color(rgba(255, 255, 255, 0.8)),
    letterSpacing(em(0.04)),
  ])

  let overview = style([
    color(rgba(255, 255, 255, 0.75)),
    fontSize(px(15)),
    unsafe("lineHeight", "1.75"),
    margin(zero),
    maxWidth(px(640)),

    media(sm, [
      maxWidth(pct(100.)),
      fontSize(px(14)),
      unsafe("lineHeight", "1.7"),
    ]),
  ])

  let statusBadge = style([
    display(#inlineFlex),
    alignItems(#center),
    backgroundColor(rgba(229, 9, 20, 0.15)),
    border(px(1), #solid, rgba(229, 9, 20, 0.4)),
    borderRadius(px(6)),
    paddingTop(px(4)),
    paddingBottom(px(4)),
    paddingLeft(px(10)),
    paddingRight(px(10)),
    fontSize(px(12)),
    fontWeight(#num(700)),
    color(hex("e50914")),
    letterSpacing(em(0.06)),
    unsafe("textTransform", "uppercase"),
  ])
}

// Always show one decimal (e.g. 8 → "8.0", 7.8 → "7.8")
@val external toFixed: (float, int) => string = "Number.prototype.toFixed.call"
let formatRating = (r: float): string => Js.Float.toFixedWithPrecision(r, ~digits=1)

@genType
@react.component
let make = (~detail: AppTypes.mediaDetail) => {
  let {t} = I18nContext.useI18n()

  let runtimeStr = if detail.numberOfSeasons > 0 {
    Int.toString(detail.numberOfSeasons) ++ " " ++ t.detailSeasons
  } else if detail.runtime > 0 {
    let h = detail.runtime / 60
    let m = mod(detail.runtime, 60)
    if h > 0 {
      Int.toString(h) ++ "h " ++ Int.toString(m) ++ "m"
    } else {
      Int.toString(m) ++ "m"
    }
  } else {
    ""
  }

  <div className=Styles.page>
    <div className=Styles.backdrop>
      <img className=Styles.backdropImg src=detail.backdrop alt="" />
      <div className=Styles.backdropGradient />
      <NextLink href="/" className=Styles.backBtn>
        {React.string(t.backToHome)}
      </NextLink>
    </div>
    <div className=Styles.content>
      <div className=Styles.row>
        <img className=Styles.poster src=detail.poster alt=detail.title />
        <div className=Styles.info>
          <h1 className=Styles.title> {React.string(detail.title)} </h1>
          {detail.tagline != ""
            ? <p className=Styles.tagline> {React.string(detail.tagline)} </p>
            : React.null}
          <div className=Styles.meta>
            {detail.year > 0
              ? <>
                  <span> {React.int(detail.year)} </span>
                  <span className=Styles.metaSep> {React.string("·")} </span>
                </>
              : React.null}
            {runtimeStr != ""
              ? <>
                  <span> {React.string(runtimeStr)} </span>
                  <span className=Styles.metaSep> {React.string("·")} </span>
                </>
              : React.null}
            <span className=Styles.rating>
              {React.string("★ " ++ formatRating(detail.rating))}
            </span>
          </div>
          {Array.length(detail.genres) > 0
            ? <div className=Styles.genres>
                {detail.genres
                  ->Array.map(g =>
                    <span key=g className=Styles.genre> {React.string(g)} </span>
                  )
                  ->React.array}
              </div>
            : React.null}
          {detail.overview != ""
            ? <p className=Styles.overview> {React.string(detail.overview)} </p>
            : React.null}
          {detail.status != ""
            ? <div>
                <span className=Styles.statusBadge> {React.string(detail.status)} </span>
              </div>
            : React.null}
        </div>
      </div>
    </div>
  </div>
}
