module Random exposing (..)
import Html exposing (..)
moguls : List { name : String }
moguls =
    [ { name = "Jeff Bezos" }
    , { name = "Elon Musk" }
    , { name = "Sergey Brin" }
    , { name = "Larry Page" }
    , { name = "Steve Jobs" }
    , { name = "Bill Gates" }
    ]
addMrToAnyString =
    (++) "Mr. "
printMogul mogul =
    li [] [ text (addMrToAnyString mogul.name)
          ]
mogulsFormatted =
    div [] [ h1 [] [ text "Moguls" ]
           , ol [] (List.map printMogul moguls)
           ]
main : Html msg
main =
    mogulsFormatted