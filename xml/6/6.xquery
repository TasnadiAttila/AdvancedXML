(: Ez a lekérdezés az házanként megadja a felesküdött tagok számát :)

xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare variable $base-url := "https://www.anapioficeandfire.com/api/houses";

declare function local:getHouses($page as xs:integer) as array(*) {
  let $url := concat($base-url, "?page=", $page)
  let $response := json-doc($url)
  return 
    if (count($response?*) > 0) 
    then 
      array:join(($response, local:getHouses($page + 1))) 
    else 
      array {}
};

declare function local:build-house-relationships($houses as array(*)) as item() {
  for $house in array:flatten($houses)  
  let $house-name := $house/houseName
  let $alliances := $house/alliances
  let $enemies := $house/enemies
  return
    <house>
      <name>{ $house-name }</name>
      <alliances>{ $alliances }</alliances>
      <enemies>{ $enemies }</enemies>
    </house>
};

let $houses := local:getHouses(1)
return local:build-house-relationships($houses)
