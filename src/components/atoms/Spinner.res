module Styles = {
  open CssJs
  open CssHelper

  let wrapper = style([
    display(#flex),
    justifyContent(#center),
    alignItems(#center),
    padding2(~v=px(80), ~h=px(0)),
  ])

  let ring = style([
    width(px(48)),
    height(px(48)),
    borderRadius(pct(50.)),
    unsafe("border", "4px solid rgba(255,255,255,0.1)"),
    unsafe("borderTopColor", "#e50914"),
    unsafe("animation", "streamify-spin 0.75s linear infinite"),
  ])
}

@react.component
let make = () =>
  <div className=Styles.wrapper>
    <style>
      {React.string(
        "@keyframes streamify-spin{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}",
      )}
    </style>
    <div className=Styles.ring />
  </div>

