(: Ez a lekérdezés megadja egy karakter nevét, és szüleinek nevét :)

xquery version "3.1";

import module namespace char = "http://example.com/characters" at "../characters.xquery";
import schema default element namespace "" at "9.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare function local:get-character-name($url as xs:string) as xs:string {
  let $response := json-doc($url)
  return $response?name
};

let $all-characters := char:get-characters(1)

return
  <characters>
    {
      for $character in $all-characters?*
      where 
        normalize-space($character?name) ne "" and
        normalize-space($character?mother) ne "" and
        normalize-space($character?father) ne ""
      return
        <character>
          <name>{$character?name}</name>
          <mother>{local:get-character-name($character?mother)}</mother>
          <father>{local:get-character-name($character?father)}</father>
        </character>
    }
  </characters>
