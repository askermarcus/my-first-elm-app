-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/Model.elm
module Model exposing (..)

import Json.Decode as Decode
import Http

-- TYPES

type alias Task =
    { id : String
    , description : String
    , completed : Bool
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
    Decode.map3 Task
        (Decode.field "_id" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "completed" Decode.bool)

tasksDecoder : Decode.Decoder (List Task)
tasksDecoder =
    Decode.list taskDecoder