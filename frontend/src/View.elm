-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/View.elm


module View exposing (view)

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Decode
import Model exposing (..)


onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
    on "keydown" (Decode.map tagger (Decode.field "keyCode" Decode.int))


formatTimeStamp : String -> String
formatTimeStamp timestamp =
    String.slice 0 10 timestamp


view : Model -> Html Msg
view model =
    div [ class "flex min-h-screen bg-gray-100" ]
        [ div [ class "flex-1 p-8" ]
            [ h2 [ class "text-xl font-bold mb-4" ] [ text "Todos" ]
            , ul [ class "space-y-4" ]
                (List.map (viewTask model) model.tasks)
            ]
        , div [ class "w-96 bg-white p-8 shadow-lg flex flex-col gap-6 sticky top-0 z-10 self-start" ]
            [ h2 [ class "text-lg font-bold" ] [ text "Add Todo" ]
            , input
                [ placeholder "New todo..."
                , value model.newTask
                , onInput UpdateNewTask
                , onKeyDown (keyToMsg AddTask)
                , class "border border-gray-300 rounded-lg p-2 w-full"
                ]
                []
            , button
                [ onClick AddTask
                , class "bg-blue-500 text-white px-4 py-2 rounded-lg w-full hover:bg-blue-600"
                ]
                [ text "Add Task" ]
            , h2 [ class "text-lg font-bold mt-8" ] [ text "Add Label" ]
            , div [ class "flex gap-2" ]
                [ input
                    [ placeholder "New label..."
                    , value model.newLabel
                    , onInput UpdateNewLabel
                    , onKeyDown (keyToMsg AddLabel)
                    , class "border border-gray-300 rounded-lg p-2 flex-1"
                    ]
                    []
                , button
                    [ onClick AddLabel
                    , class "bg-green-500 text-white px-3 py-2 rounded-lg hover:bg-green-600"
                    ]
                    [ text "Add Label" ]
                ]
            , h2 [ class "text-lg font-bold mt-8" ] [ text "All Labels" ]
            , div [ class "flex flex-wrap gap-2" ]
                (List.map (\label -> viewLabelChip (\_ -> False) label "") model.labels)
            ]
        ]


viewTask : Model -> Task -> Html Msg
viewTask model task =
    li [ class "bg-white p-4 rounded-lg shadow flex flex-col gap-2" ]
        [ div [ class "flex justify-between items-center" ]
            [ div [ class "font-medium text-gray-800" ] [ text task.description ]
            , div [ class "flex gap-2" ]
                [ button
                    [ onClick (ToggleTask task.id)
                    , class
                        ("px-2 py-1 rounded "
                            ++ (if task.completed then
                                    "bg-green-500 text-white"

                                else
                                    "bg-gray-300"
                               )
                        )
                    ]
                    [ text
                        (if task.completed then
                            "Undo"

                         else
                            "Complete"
                        )
                    ]
                , button
                    [ onClick (DeleteTask task.id)
                    , class "bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"
                    ]
                    [ text "Delete" ]
                ]
            ]
        , div [ class "flex flex-wrap gap-2" ]
            (List.map
                (\label ->
                    viewLabelChip (\labelId -> List.member labelId task.labels) label task.id
                )
                model.labels
            )
        , div [ class "text-xs text-gray-500 text-right" ]
            [ text ("Created at: " ++ formatTimeStamp task.timestamp) ]
        ]


viewLabelChip : (String -> Bool) -> Label -> (String -> Html Msg)
viewLabelChip isAssigned label =
    \taskId ->
        let
            assigned =
                isAssigned label.id
        in
        button
            [ onClick (ToggleLabelOnTask taskId label.id)
            , class
                ("px-2 py-1 rounded-full border "
                    ++ (if assigned then
                            "bg-blue-500 text-white border-blue-500"

                        else
                            "bg-gray-100 text-gray-700 border-gray-300"
                       )
                )
            ]
            [ text label.name ]


keyToMsg : Msg -> Int -> Msg
keyToMsg msg keyCode =
    if keyCode == 13 then
        -- 13 is the Enter key
        msg

    else
        NoOp
