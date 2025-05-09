module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Encode as Encode
import Http

type alias Task =
    { id : String
    , description : String
    , completed : Bool
    }

type alias Model =
    { tasks : List Task
    , newTask : String
    }

initModel : Model
initModel = 
    { tasks = []
    , newTask = ""
    }

taskDecoder : Decode.Decoder Task
taskDecoder =
    Decode.map3 Task
        (Decode.field "_id" Decode.string) -- Decode `_id` as a string
        (Decode.field "description" Decode.string)
        (Decode.field "completed" Decode.bool)

tasksDecoder : Decode.Decoder (List Task)
tasksDecoder =
    Decode.list taskDecoder

fetchTasksRequest : Cmd Msg
fetchTasksRequest =
    Http.get
        { url = "http://localhost:3000/tasks"
        , expect = Http.expectJson TasksFetched tasksDecoder
        }

addTaskRequest : String -> Cmd Msg
addTaskRequest description =
    Http.post
        { url = "http://localhost:3000/tasks"
        , body = Http.jsonBody (Encode.object [ ( "description", Encode.string description ), ( "completed", Encode.bool False ) ])
        , expect = Http.expectJson TaskAdded taskDecoder
        }

toggleTaskRequest : Task -> Cmd Msg
toggleTaskRequest task =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:3000/tasks/" ++ task.id
        , body = Http.jsonBody (Encode.object [ ( "completed", Encode.bool (not task.completed) ) ])
        , expect = Http.expectJson TaskToggled taskDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

deleteTaskRequest : String -> Cmd Msg
deleteTaskRequest id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:3000/tasks/" ++ id
        , body = Http.emptyBody
        , expect = Http.expectString (TaskDeleted id)
        , timeout = Nothing
        , tracker = Nothing
        }

type Msg
    = FetchTasks
    | TasksFetched (Result Http.Error (List Task))
    | UpdateNewTask String
    | AddTask
    | TaskAdded (Result Http.Error Task)
    | ToggleTask String
    | TaskToggled (Result Http.Error Task)
    | DeleteTask String
    | TaskDeleted String (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchTasks ->
            (model, fetchTasksRequest)
        
        TasksFetched (Ok tasks) ->
            ( { model | tasks = tasks }, Cmd.none )
        
        TasksFetched (Err error) ->
            let
                _ = Debug.log "Error fetching tasks" error
            in
            (model, Cmd.none)

        UpdateNewTask newTask ->
            ( { model | newTask = newTask }, Cmd.none )

        AddTask ->
            ( { model | newTask = "" }
            , addTaskRequest model.newTask
            )

        TaskAdded (Ok task) ->
            ( { model | tasks = model.tasks ++ [ task ] }, Cmd.none )

        TaskAdded (Err error) ->
            let
                _ = Debug.log "Error adding task" error
            in
            (model, Cmd.none)

        ToggleTask id ->
            let
                taskToToggle =
                    List.filter (\task -> task.id == id) model.tasks
                        |> List.head
            in
            case taskToToggle of
                Just task ->
                    (model, toggleTaskRequest task)

                Nothing ->
                    (model, Cmd.none)

        TaskToggled (Ok updatedTask) ->
            ( { model
                | tasks =
                    List.map
                        (\task ->
                            if task.id == updatedTask.id then
                                updatedTask
                            else
                                task
                        )
                        model.tasks
              }
            , Cmd.none
            )

        TaskToggled (Err error) ->
            let
                _ = Debug.log "Error toggling task" error
            in
            (model, Cmd.none)

        DeleteTask id ->
            (model, deleteTaskRequest id)

        TaskDeleted id (Ok _) ->
            ( { model
                | tasks = List.filter (\task -> task.id /= id) model.tasks
              }
            , Cmd.none
            )

        TaskDeleted id (Err error) ->
            let
                _ = Debug.log ("Error deleting task with id: " ++ id) error
            in
            (model, Cmd.none)


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

main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (initModel, fetchTasksRequest)
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }