type contextValue = {
  locale: string,
  setLocale: string => unit,
  t: I18n.t,
}

let context: React.Context.t<contextValue> = React.createContext({
  locale: "en",
  setLocale: _l => (),
  t: I18n.en,
})

module ContextProvider = {
  let make = React.Context.provider(context)
}

@genType
@react.component
let make = (~children: React.element) => {
  let (locale, setLocale') = React.useState(() => "en")
  // Wrap the raw setState dispatch so callers pass a plain string
  let setLocale = (l: string) => setLocale'(_ => l)
  let t = I18n.useTranslation(locale)
  let value: contextValue = {locale, setLocale, t}
  <ContextProvider value> children </ContextProvider>
}

@genType
let useI18n = () => React.useContext(context)
