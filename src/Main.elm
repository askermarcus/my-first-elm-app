module Main exposing (..)
import Browser
import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)

type alias Task = 
    {
        id : Int,
        description : String,
        completed : Bool
    }
type alias Model = {
    tasks: List Task
    , newTask : String
    }      

initModel : Model
initModel = 
    { tasks = []
    , newTask = ""
    }

type Msg
    = UpdateNewTask String
    | AddTask
    | ToggleTask Int
    | DeleteTask Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateNewTask newTask ->
            { model | newTask = newTask }

        AddTask ->
            let
                newTask =
                    { id = List.length model.tasks + 1
                    , description = model.newTask
                    , completed = False
                    }
            in
            { model
                | tasks = model.tasks ++ [ newTask ]
                , newTask = ""
            }

        ToggleTask id ->
            { model
                | tasks =
                    List.map
                        (\task ->
                            if task.id == id then
                                { task | completed = not task.completed }
                            else
                                task
                        )
                        model.tasks
            }

        DeleteTask id ->
            { model
                | tasks = List.filter (\task -> task.id /= id) model.tasks
            }

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
        , button [ onClick (ToggleTask task.id) ] [ text (if task.completed then "Undo" else "Complete")]
        , button [ onClick (DeleteTask task.id) ] [ text "Delete" ]
        ]

main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , update = update
        , view = view
        }