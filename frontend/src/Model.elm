-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/Model.elm


module Model exposing (..)

import Http
import Json.Decode as Decode



-- TYPES


type alias Task =
    { id : String
    , description : String
    , completed : Bool
    , timestamp : String
    }


type alias Model =
    { tasks : List Task
    , newTask : String
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
    | NoOp



-- INITIAL STATE


initModel : Model
initModel =
    { tasks = []
    , newTask = ""
    }



-- DECODERS


taskDecoder : Decode.Decoder Task
taskDecoder =
    Decode.map4 Task
        (Decode.field "_id" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "completed" Decode.bool)
        (Decode.field "timestamp" Decode.string)


tasksDecoder : Decode.Decoder (List Task)
tasksDecoder =
    Decode.list taskDecoder
