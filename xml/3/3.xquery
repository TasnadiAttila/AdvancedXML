xquery version "3.1";

import schema default element namespace "" at "3.xsd";
import module namespace char = "http://example.com/characters" at "../characters.xquery";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

let $all-characters := char:get-characters(1)

let $grouped := 
  for $character in $all-characters?*
  let $culture := normalize-space($character?culture)
  where $culture != ""
  group by $c := $culture
  return 
    <culture>
      <name>{ $c }</name>
      <count>{ count($character) }</count>
    </culture>

let $sorted := 
  for $c in $grouped
  order by xs:integer($c/count)
  return $c

return
<cultures>
  { $sorted }
</cultures>
