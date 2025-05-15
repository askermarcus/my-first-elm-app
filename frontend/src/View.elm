
module View exposing (view)

import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)

-- VIEW FUNCTIONS

view : Model -> Html Msg
view model =
    div []
        [ input 
            [ placeholder "Add a new task"
            , value model.newTask
            , onInput UpdateNewTask
            ]
            []
        , button [ onClick AddTask ] [ text "Add Task" ]
        , ul []
            (List.map viewTask model.tasks)
        ]

viewTask : Task -> Html Msg
viewTask task = 
    li []
        [ text task.description
        , button [ onClick (ToggleTask task.id) ] [ text (if task.completed then "Undo" else "Complete") ]
        , button [ onClick (DeleteTask task.id) ] [ text "Delete" ]
        ]