(: Ez a lekérdezés megadja egy ház nevét, alapítás évét és székhelyét :)

xquery version "3.1";

import schema default element namespace "" at "8.xsd";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
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

let $houses := local:getHouses(1)

return
    <houses>
        {
            for $house in $houses?*
                where $house?founded and normalize-space($house?founded) ne ""
            return
                <house>
                    <name>{$house?name}</name>
                    <founded>{$house?founded}</founded>
                    <seats>
                        {
                            for $seat in $house?seats
                                where normalize-space(string-join($seat, " ")) ne ""
                            return
                                <seat>{$seat}</seat>
                        }
                    </seats>
                
                </house>
        }
    </houses>
