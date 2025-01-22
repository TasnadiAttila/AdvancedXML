(: Ez a lekérdezés a karakter nevét adja meg és hogy melyik könyvben szerepel :)

xquery version "3.1";

import schema default element namespace "" at "5.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
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

declare function local:get-books($page as xs:integer) as array(*) {
  let $url := concat("https://anapioficeandfire.com/api/books?page=", $page)
  let $response := json-doc($url)
  return 
    if (count($response?*) > 0) 
    then 
      array:join(($response, local:get-books($page + 1))) 
    else 
      array {}
};

let $characters := local:get-characters(1)
let $books := local:get-books(1)

let $character-books := 
  for $character in $characters?*
  let $char-name := $character?name
  where normalize-space($char-name) != ""
  let $books-list := 
    for $book-uri in $character?books?*
    let $book := 
      for $b in $books?* 
      where $b?url = $book-uri
      return $b?name
    return $book
  return 
    <character>
      <charactername>{ $char-name }</charactername>
      <books>
        {
          string-join($books-list, ", ")
        }
      </books>
    </character>

let $result :=
  <characterlist>
    {
      $character-books
    }
  </characterlist>

return $result
