type nextError = {message: string}

module Styles = {
  open CssJs
  open CssHelper

  let container = style([
    display(#flex),
    flexDirection(#column),
    alignItems(#center),
    justifyContent(#center),
    minHeight(vh(50.)),
    backgroundColor(hex("141414")),
    color(white),
    gap(px(16)),
    padding(px(24)),
  ])

  let title = style([
    fontSize(px(22)),
    fontWeight(bold),
    margin(px(0)),
  ])

  let msg = style([
    opacity(0.6),
    fontSize(px(14)),
    maxWidth(px(400)),
    textAlign(#center),
    margin(px(0)),
  ])

  let retryBtn = style([
    marginTop(px(8)),
    padding2(~v=px(10), ~h=px(24)),
    backgroundColor(hex("e50914")),
    color(white),
    border(px(0), #solid, transparent),
    borderRadius(px(6)),
    fontSize(px(14)),
    cursor(#pointer),
  ])
}

@genType
@react.component
let make = (~error: nextError, ~reset: unit => unit) => {
  let {t} = I18nContext.useI18n()
  let message = error.message === "" ? t.errorFallback : error.message

  <div className=Styles.container>
    <h2 className=Styles.title> {React.string(t.errorTitle)} </h2>
    <p className=Styles.msg> {React.string(message)} </p>
    <button
      className=Styles.retryBtn
      onClick={_ => reset()}
      type_="button">
      {React.string("Retry")}
    </button>
  </div>
}
