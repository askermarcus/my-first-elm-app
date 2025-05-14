module FizzBuzz exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

ourList = 
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    , 11, 12, 13, 14, 15
    , 16, 17, 18, 19, 20
    ]

fizzBuzzCheck fizz buzz fizzBuzz num =
    if modBy 15 num == 0 then
         Debug.toString fizzBuzz ++ ", "
     else if  modBy 5 num == 0 then
         Debug.toString buzz ++ ", "
     else if  modBy 3 num == 0 then
         Debug.toString fizz ++ ", " 
     else 
         (Debug.toString num) ++ ", "

main = 
    List.map (fizzBuzzCheck "fizz" "buzz" "fizzBuzz") ourList
    |> String.concat
    |> text