module namespace char = "http://example.com/characters";

declare function char:get-characters($page as xs:integer) as array(*) {
  let $url := concat("https://anapioficeandfire.com/api/characters?page=", $page)
  let $response := json-doc($url)
  return
    if (count($response?*) > 0) 
    then 
      array:join(($response, char:get-characters($page + 1))) 
    else 
      array {}
};
