(: Ez a lekérdezés a házak nevét, régióját, és mondásaikat kéri le xml formátumban :)

xquery version "3.1";

import schema default element namespace "" at "1.xsd";

let $houses := json-doc("https://anapioficeandfire.com/api/houses")
let $result :=
<houses>
  {
    for $house in $houses?*
    return
      <house>
        <name>{ $house?name }</name>
        <region>{ $house?region }</region>
        <words>{ $house?words }</words>
      </house>
  }
</houses>
return $result

