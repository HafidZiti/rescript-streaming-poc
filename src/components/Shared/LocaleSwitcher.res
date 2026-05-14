
type lang = {code: string, flag: string, label: string}

let langs: array<lang> = [
  {code: "en", flag: "🇬🇧", label: "English"},
  {code: "fr", flag: "🇫🇷", label: "Français"},
]


module Styles = {
  open CssJs
  open CssHelper

  let wrapper = style([
    position(#relative),
    display(#inlineFlex),
    unsafe("userSelect", "none"),
  ])

  let trigger = style([
    display(#flex),
    alignItems(#center),
    gap(px(8)),
    padding2(~v=px(8), ~h=px(14)),
    backgroundColor(rgba(255, 255, 255, 0.08)),
    unsafe("backdropFilter", "blur(8px)"),
    border(px(1), #solid, rgba(255, 255, 255, 0.18)),
    borderRadius(px(8)),
    color(hex("ffffff")),
    fontSize(px(14)),
    fontWeight(#num(600)),
    cursor(#pointer),
    unsafe("outline", "none"),
    transition(~duration=ms(160.), ~timingFunction=#ease, "border-color"),
    hover([borderColor(hex("e50914"))]),
    focus([borderColor(hex("e50914"))]),
  ])

  let flag = style([
    fontSize(px(18)),
    unsafe("lineHeight", "1"),
  ])

  let caret = style([
    fontSize(px(10)),
    color(rgba(255, 255, 255, 0.5)),
    marginLeft(px(2)),
  ])

  let panel = style([
    position(#absolute),
    top(px(-50)),
    right(px(0)),
    unsafe("transform", "translateY(calc(100% + 6px))"),
    backgroundColor(hex("1a1a2e")),
    border(px(1), #solid, rgba(255, 255, 255, 0.12)),
    borderRadius(px(10)),
    overflow(#hidden),
    boxShadow(Shadow.box(~y=px(8), ~blur=px(24), rgba(0, 0, 0, 0.6))),
    zIndex(200),
    minWidth(px(160)),
  ])

  let option = style([
    display(#flex),
    alignItems(#center),
    gap(px(10)),
    padding2(~v=px(12), ~h=px(16)),
    cursor(#pointer),
    fontSize(px(14)),
    color(hex("ffffff")),
    transition(~duration=ms(120.), ~timingFunction=#ease, "background-color"),
    hover([backgroundColor(rgba(255, 255, 255, 0.08))]),
  ])

  let optionActive = style([
    backgroundColor(rgba(229, 9, 20, 0.15)),
  ])
}

@react.component
let make = () => {
  let {locale, setLocale} = I18nContext.useI18n()
  let (open_, setOpen) = React.useState(() => false)

  let current = langs->Array.find(l => l.code == locale)->Option.getOr({
    code: "en",
    flag: "🇬🇧",
    label: "English",
  })

  <div className=Styles.wrapper>
    <button
      className=Styles.trigger
      onClick={_ => setOpen(o => !o)}>
      <span className=Styles.flag> {React.string(current.flag)} </span>
      <span> {React.string(current.label)} </span>
      <span className=Styles.caret>
        {React.string(open_ ? "▲" : "▼")}
      </span>
    </button>

    {open_
      ? <div className=Styles.panel>
          {langs
            ->Array.map(lang => {
              let isActive = lang.code == locale
              let cls = {
                open CssJs
                if isActive {
                  merge([Styles.option, Styles.optionActive])
                } else {
                  Styles.option
                }
              }
              <div
                key=lang.code
                className=cls
                onClick={_ => {
                  setLocale(lang.code)
                  setOpen(_ => false)
                }}>
                <span className=Styles.flag> {React.string(lang.flag)} </span>
                <span> {React.string(lang.label)} </span>
              </div>
            })
            ->React.array}
        </div>
      : React.null}
  </div>
}
