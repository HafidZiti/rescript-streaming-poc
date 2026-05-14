

let getStr = (dict: Js.Dict.t<Js.Json.t>, key: string): string =>
  dict
  ->Js.Dict.get(key)
  ->Option.flatMap(v => v->Js.Json.decodeString)
  ->Option.getOr("")

let getFloat = (dict: Js.Dict.t<Js.Json.t>, key: string): float =>
  dict
  ->Js.Dict.get(key)
  ->Option.flatMap(v => v->Js.Json.decodeNumber)
  ->Option.getOr(0.)

let getInt = (dict: Js.Dict.t<Js.Json.t>, key: string): int =>
  getFloat(dict, key)->Belt.Float.toInt

let decodeMedia = (json: Js.Json.t): option<AppTypes.media> =>
  switch Js.Json.decodeObject(json) {
  | Some(d) =>
    Some({
      id: getStr(d, "id"),
      title: getStr(d, "title"),
      thumbnail: getStr(d, "thumbnail"),
      category: AppTypes.Movie,
      description: getStr(d, "description"),
      year: getInt(d, "year"),
      duration: getStr(d, "duration"),
      rating: getFloat(d, "rating"),
    })
  | None => None
  }

let decodeArray = (json: Js.Json.t): array<AppTypes.media> =>
  switch Js.Json.decodeArray(json) {
  | Some(arr) => arr->Array.filterMap(decodeMedia)
  | None => []
  }
