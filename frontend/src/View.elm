-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/View.elm
module View exposing (view)

import Html exposing (Html, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput, on)
import Model exposing (..)
import Json.Decode as Decode

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
    on "keydown" (Decode.map tagger (Decode.field "keyCode" Decode.int))

view : Model -> Html Msg
view model =
    div [ class "flex justify-center items-center min-h-screen bg-gray-100" ]
        [ div [ class "bg-white p-6 rounded-lg shadow-md w-full max-w-md" ]
            [ h1 [ class "text-2xl font-bold text-center mb-4" ] [ text "My Todos" ]
            , input 
                [ placeholder "Add a new task"
                , value model.newTask
                , onInput UpdateNewTask
                , onKeyDown (keyToMsg AddTask)
                , class "border border-gray-300 rounded-lg p-2 w-full mb-4"
                ]
                []
            , button 
                [ onClick AddTask
                , class "bg-blue-500 text-white px-4 py-2 rounded-lg w-full mb-4 hover:bg-blue-600"
                ] 
                [ text "Add Task" ]
            , ul [ class "space-y-2 list-none" ]
                (List.map viewTask model.tasks)
            ]
        ]

viewTask : Task -> Html Msg
viewTask task = 
    li [ class "flex justify-between items-center p-3 border border-gray-300 rounded-lg" ]
        [ text task.description
        , div [ class "space-x-2" ]
            [ button 
                [ onClick (ToggleTask task.id)
                , class "text-sm text-white px-3 py-1 rounded-lg"
                , class (if task.completed then "bg-green-500 hover:bg-green-600" else "bg-gray-500 hover:bg-gray-600")
                ] 
                [ text (if task.completed then "Undo" else "Complete") ]
            , button 
                [ onClick (DeleteTask task.id)
                , class "bg-red-500 text-white text-sm px-3 py-1 rounded-lg hover:bg-red-600"
                ] 
                [ text "Delete" ]
            ]
        ]

keyToMsg : Msg -> Int -> Msg
keyToMsg msg keyCode =
    if keyCode == 13 then -- 13 is the Enter key
        msg
    else
        NoOp