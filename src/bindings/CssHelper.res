// bs-css exports px/rgba/hex etc. with open polymorphic return types ([> #px(int)]) which
// ReScript 11 cannot narrow to closed types. Obj.magic is safe here: all poly-variant
// constructors are identity-coercible at runtime in JS.

let px = (n: int) => Obj.magic(#px(n))
let pct = (n: float) => Obj.magic(#percent(n))
let vh = (n: float) => Obj.magic(#vh(n))
let em = (n: float) => Obj.magic(#em(n))
let rem = (n: float) => Obj.magic(#rem(n))
let ms = (n: float) => Obj.magic(#ms(n))
let rgba = (r: int, g: int, b: int, a: float) => Obj.magic(#rgba((r, g, b, #num(a))))
let hex = (s: string) => Obj.magic(#hex(s))
let scale = (x: float, y: float) => Obj.magic(#scale((x, y)))
let zero = Obj.magic(#zero)
let bgUrl = (src: string) => Obj.magic(#url(src))

// Responsive breakpoints (desktop-first, max-width)
let md = "(max-width: 900px)"
let sm = "(max-width: 640px)"

