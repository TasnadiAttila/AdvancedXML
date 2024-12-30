xquery version "3.1";


declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";


declare function local:get-characters($page as xs:integer) as array(*) {
  let $url := concat("https://anapioficeandfire.com/api/characters?page=", $page)
  let $response := json-doc($url)
  return 
    if (count($response?*) > 0) 
    then 
      array:join(($response, local:get-characters($page + 1))) 
    else 
      array {}
};

let $all-characters := local:get-characters(1)

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
