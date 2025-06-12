module Update exposing
    ( addTaskRequest
    , deleteTaskRequest
    , fetchLabelsRequest
    , fetchTasksRequest
    , toggleTaskRequest
    , update
    )

import Dict exposing (..)
import Http
import Json.Encode as Encode
import Model exposing (..)
import Process
import Task


fetchTasksRequest : String -> List String -> Cmd Msg
fetchTasksRequest searchTerm labelFilters =
    let
        baseUrl =
            if String.isEmpty searchTerm then
                "http://localhost:3000/tasks"

            else
                "http://localhost:3000/tasks?search=" ++ searchTerm

        url =
            if List.isEmpty labelFilters then
                baseUrl

            else
                let
                    labelParam =
                        String.join "," labelFilters

                    sep =
                        if String.contains "?" baseUrl then
                            "&"

                        else
                            "?"
                in
                baseUrl ++ sep ++ "labels=" ++ labelParam
    in
    Http.get
        { url = url
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


fetchLabelsRequest : Cmd Msg
fetchLabelsRequest =
    Http.get
        { url = "http://localhost:3000/labels"
        , expect = Http.expectJson LabelsFetched labelsDecoder
        }


addLabelRequest : String -> Cmd Msg
addLabelRequest name =
    Http.post
        { url = "http://localhost:3000/labels"
        , body = Http.jsonBody (Encode.object [ ( "name", Encode.string name ) ])
        , expect = Http.expectJson LabelAdded labelDecoder
        }


patchTaskLabelsRequest : String -> List String -> Cmd Msg
patchTaskLabelsRequest taskId labelIds =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:3000/tasks/" ++ taskId
        , body = Http.jsonBody (Encode.object [ ( "labels", Encode.list Encode.string labelIds ) ])
        , expect = Http.expectJson TaskToggled taskDecoder -- or your update msg
        , timeout = Nothing
        , tracker = Nothing
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateSearchTerm term ->
            let
                nextDebounce =
                    model.searchDebounce + 1
            in
            ( { model | searchTerm = term, searchDebounce = nextDebounce }
            , Process.sleep 500 |> Task.perform (\_ -> DebouncedSearch nextDebounce term)
            )

        DebouncedSearch debounce term ->
            if debounce == model.searchDebounce then
                ( model, fetchTasksRequest term model.labelFilters )

            else
                ( model, Cmd.none )

        FetchTasks ->
            ( model, fetchTasksRequest model.searchTerm model.labelFilters )

        TasksFetched (Ok tasks) ->
            ( { model | tasks = tasks }, Cmd.none )

        TasksFetched (Err error) ->
            let
                _ =
                    Debug.log "Error fetching tasks" error
            in
            ( model, Cmd.none )

        UpdateNewTask newTask ->
            ( { model | newTask = newTask }, Cmd.none )

        LabelsFetched (Ok labels) ->
            ( { model | labels = labels }, Cmd.none )

        LabelsFetched (Err error) ->
            let
                _ =
                    Debug.log "Error fetching label" error
            in
            ( model, Cmd.none )

        AddLabel ->
            ( { model | newLabel = "" }
            , addLabelRequest model.newLabel
            )

        LabelAdded (Ok label) ->
            let
                _ =
                    Debug.log "Error adding label" label
            in
            ( model, fetchLabelsRequest )

        LabelAdded (Err error) ->
            let
                _ =
                    Debug.log "Error adding label" error
            in
            ( model, Cmd.none )

        UpdateNewLabel newLabel ->
            ( { model | newLabel = newLabel }, Cmd.none )

        AddTask ->
            ( { model | newTask = "" }
            , addTaskRequest model.newTask
            )

        TaskAdded (Ok task) ->
            ( { model | tasks = model.tasks ++ [ task ] }, Cmd.none )

        TaskAdded (Err error) ->
            let
                _ =
                    Debug.log "Error adding task" error
            in
            ( model, Cmd.none )

        ToggleTask id ->
            let
                taskToToggle =
                    List.filter (\task -> task.id == id) model.tasks
                        |> List.head
            in
            case taskToToggle of
                Just task ->
                    ( model, toggleTaskRequest task )

                Nothing ->
                    ( model, Cmd.none )

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
                _ =
                    Debug.log "Error toggling task" error
            in
            ( model, Cmd.none )

        DeleteTask id ->
            ( model, deleteTaskRequest id )

        TaskDeleted id (Ok _) ->
            ( { model
                | tasks = List.filter (\task -> task.id /= id) model.tasks
              }
            , Cmd.none
            )

        TaskDeleted id (Err error) ->
            let
                _ =
                    Debug.log ("Error deleting task with id: " ++ id) error
            in
            ( model, Cmd.none )

        SearchTasks ->
            ( model, fetchTasksRequest model.searchTerm model.labelFilters )

        SelectLabelDropdown taskId labelId ->
            ( { model | labelDropdown = Dict.insert taskId labelId model.labelDropdown }
            , Cmd.none
            )

        ToggleLabelOnTask taskId labelId ->
            let
                maybeTask =
                    List.filter (\t -> t.id == taskId) model.tasks |> List.head

                updatedLabels =
                    case maybeTask of
                        Just task ->
                            if List.member labelId task.labels then
                                List.filter ((/=) labelId) task.labels

                            else
                                labelId :: task.labels

                        Nothing ->
                            []
            in
            ( model, patchTaskLabelsRequest taskId updatedLabels )

        ToggleLabelFilter labelId ->
            let
                newFilters =
                    if List.member labelId model.labelFilters then
                        List.filter ((/=) labelId) model.labelFilters

                    else
                        labelId :: model.labelFilters
            in
            ( { model | labelFilters = newFilters }
            , fetchTasksRequest model.searchTerm newFilters
            )

        NoOp ->
            ( model, Cmd.none )
