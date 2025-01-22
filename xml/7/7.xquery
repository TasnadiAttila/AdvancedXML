(: Ez a lekérdezést a karakter nevét és a címét adja vissza :)

xquery version "3.1";

import schema default element namespace "" at "7.xsd";

import module namespace char = "http://example.com/characters" at "../characters.xquery";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

let $all-characters := char:get-characters(1)

return
<characters>
  {
    for $char in $all-characters?*
    let $titles := $char?titles
    where $char?name and exists(
      for $t in $titles?*
      return if (normalize-space($t)) then true() else ()
    )
    return
      <character>
        <name>{ $char?name }</name>
        <titles>
          {
            for $title in $titles?*
            where normalize-space($title)
            return <title>{ $title }</title>
          }
        </titles>
      </character>
  }
</characters>
