module Styles = {
  open CssJs
  open CssHelper

  let bar = style([
    display(#flex),
    width(pct(100.)),
    borderRadius(px(50)),
    overflow(#hidden),
    boxShadow(Shadow.box(~y=px(4), ~blur=px(32), rgba(0, 0, 0, 0.6))),
  ])

  let input = style([
    flexGrow(1.),
    padding2(~v=px(18), ~h=px(28)),
    backgroundColor(rgba(65, 64, 64, 0.1)),
    unsafe("backdropFilter", "blur(8px)"),
    unsafe("border", "none"),
    color(hex("ffffff")),
    fontSize(px(15)),
    unsafe("outline", "none"),
    selector("::placeholder", [color(rgba(255, 255, 255, 0.6))]),
  ])
}

@react.component
let make = (~placeholder: string, ~btnLabel: string, ~onSearch: string => unit) => {
  let (query, setQuery) = React.useState(() => "")
  let handleSearch = () => onSearch(query)

  <div className=Styles.bar>
    <input
      className=Styles.input
      type_="text"
      placeholder
      value=query
      onChange={e => setQuery(_ => ReactEvent.Form.target(e)["value"])}
      onKeyDown={e => {
        if ReactEvent.Keyboard.key(e) == "Enter" {
          handleSearch()
        }
      }}
    />
    <Button label=btnLabel onClick=handleSearch />
  </div>
}
