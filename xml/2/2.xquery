(: Ez a lekérdezés a egy karakter nevét, nemét, az őt játszó színészt és a tvSeries mezőbe, hogy melyik évadban volt json formátumban:)

xquery version "3.1";

import module namespace char = "http://example.com/characters" at "../characters.xquery";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $all-characters := char:get-characters(1)

let $filtered-characters := 
  array {
    for $char in $all-characters?*
    let $playedBy := string-join($char?playedBy, ", ")
    where normalize-space($char?name) != "" and normalize-space($playedBy) != ""
    group by $name := $char?name
    return 
      map {
        "name": $name,
        "gender": head($char?gender),
        "playedBy": array { $char?playedBy },
        "tvSeries": array { $char?tvSeries }
      }
  }

let $result :=
  map {
    "characters": $filtered-characters
  }

return $result
