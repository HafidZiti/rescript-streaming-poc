@module("next/link") @react.component
external make: (
  ~href: string,
  ~prefetch: bool=?,
  ~className: string=?,
  ~children: React.element,
) => React.element = "default"
