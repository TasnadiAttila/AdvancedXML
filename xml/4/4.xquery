xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html";
declare option output:indent "yes";

let $books := json-doc("https://anapioficeandfire.com/api/books")

let $result :=
<html>
  <head>
    <title>Books from Ice and Fire API</title>
    <style>
      {"body {
        font-family: Arial, sans-serif;
      }
      table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        font-size: 18px;  /* Betűméret növelése */
      }
      th, td {
        padding: 12px;
        border: 1px solid #ddd;
        text-align: left;
      }
      th {
        background-color: #f2f2f2;
        font-size: 20px;  /* Fejléc nagyobb betűmérettel */
      }
      tr:nth-child(even) {
        background-color: #f9f9f9;
      }"}
    </style>
  </head>
  <body>
    <h1 style="text-align: center;">Books List</h1>
    <table>
      <tr>
        <th>Title</th>
        <th>Pages</th>
        <th>Release Date</th>
        <th>Author</th>
      </tr>
      {
        for $book in $books?*
        return
          <tr>
            <td>{ $book?name }</td>
            <td>{ $book?numberOfPages }</td>
            <td>{ $book?released }</td>
            <td>{ $book?authors }</td>
          </tr>
      }
    </table>
  </body>
</html>

return $result
