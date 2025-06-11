-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/View.elm


module View exposing (view)

import Dict
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



-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/View.elm


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
            , div
                [ class "mb-4 flex" ]
                [ input
                    [ placeholder "Create new label"
                    , value model.newLabel
                    , onInput UpdateNewLabel
                    , onKeyDown (keyToMsg AddLabel)
                    , class "border border-gray-300 rounded-lg p-2 flex-1"
                    ]
                    []
                , button
                    [ onClick AddLabel
                    , class "bg-green-500 text-white px-3 py-2 rounded-lg ml-2 hover:bg-green-600"
                    ]
                    [ text "Add Label" ]
                ]
            , input
                [ placeholder "Search todos..."
                , value model.searchTerm
                , onInput UpdateSearchTerm
                , class "mb-4 px-3 py-2 border rounded w-full"
                ]
                []
            , button
                [ onClick AddTask
                , class "bg-blue-500 text-white px-4 py-2 rounded-lg w-full mb-4 hover:bg-blue-600"
                ]
                [ text "Add Task" ]
            , ul [ class "space-y-2 list-none" ]
                (List.map (viewTask model) model.tasks)
            ]
        ]


viewTask : Model -> Task -> Html Msg
viewTask model task =
    li [ class "flex flex-col p-3 border border-gray-300 rounded-lg space-y-2" ]
        [ div [ class "flex justify-between items-center" ]
            [ div [ class "text-sm font-medium text-gray-800 max-w-[50%]" ]
                [ text task.description ]
            , div [ class "space-x-2" ]
                [-- ...your buttons here... ]
                ]
            , div [ class "flex items-center space-x-2" ]
                [ select
                    [ onInput (SelectLabelDropdown task.id)
                    , class "border rounded px-2 py-1"
                    ]
                    (option [ value "" ] [ text "Add label..." ]
                        :: List.map
                            (\label ->
                                option
                                    [ value label.id
                                    , selected (Maybe.withDefault "" (Dict.get task.id model.labelDropdown) == label.id)
                                    ]
                                    [ text label.name ]
                            )
                            model.labels
                    )
                , button
                    [ onClick (AttachLabelToTask task.id)
                    , class "bg-blue-500 text-white px-2 py-1 rounded hover:bg-blue-600"
                    ]
                    [ text "Attach" ]
                ]
            , div [ class "text-xs text-gray-500" ]
                [ text
                    ("Labels: "
                        ++ String.join ", "
                            (List.filterMap
                                (\labelId ->
                                    List.filter (\l -> l.id == labelId) model.labels
                                        |> List.head
                                        |> Maybe.map .name
                                )
                                task.labels
                            )
                    )
                ]
            , div [ class "text-xs text-gray-500 text-right" ]
                [ text ("Created at: " ++ formatTimeStamp task.timestamp) ]
            ]
        ]


keyToMsg : Msg -> Int -> Msg
keyToMsg msg keyCode =
    if keyCode == 13 then
        -- 13 is the Enter key
        msg

    else
        NoOp
