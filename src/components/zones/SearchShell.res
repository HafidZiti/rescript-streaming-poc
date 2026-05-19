type router
@module("next/navigation") external useRouter: unit => router = "useRouter"
@send external push: (router, string) => unit = "push"
@val external encodeURIComponent: string => string = "encodeURIComponent"

module Styles = {
  open CssJs
  open CssHelper

  let container = style([
    backgroundColor(hex("0a0a0f")),
    minHeight(vh(100.)),
  ])
}

@genType
@react.component
let make = (~initialQuery: string="", ~children: React.element) => {
  let router = useRouter()

  let handleSearch = (q: string) => {
    let query = String.trim(q)
    if query == "" {
      push(router, "/")
    } else {
      push(router, "/?q=" ++ encodeURIComponent(query))
    }
  }

  <div className=Styles.container>
    <HeroSection onSearch=handleSearch initialQuery />
    {children}
  </div>
}
