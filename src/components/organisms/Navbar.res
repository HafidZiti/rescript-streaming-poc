module Styles = {
  open CssJs
  open CssHelper

  let nav = style([
    display(#flex),
    alignItems(#center),
    justifyContent(#spaceBetween),
    padding2(~v=px(16), ~h=px(36)),
    backgroundColor(rgba(10, 10, 15, 0.80)),
    unsafe("position", "sticky"),
    top(px(0)),
    zIndex(100),
    unsafe("backdropFilter", "blur(16px)"),
    unsafe("WebkitBackdropFilter", "blur(16px)"),
    borderBottom(px(1), #solid, rgba(255, 255, 255, 0.06)),
  ])
}

@react.component
let make = () =>
  <nav className=Styles.nav>
    <Logo />
    <LocaleSwitcher />
  </nav>
