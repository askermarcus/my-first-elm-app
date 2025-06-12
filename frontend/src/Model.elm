-- filepath: /Users/marcus.asker/my-first-elm-app/frontend/src/Model.elm


module Model exposing (..)

import Dict exposing (Dict)
import Http
import Json.Decode as Decode



-- TYPES


type alias Task =
    { id : String
    , description : String
    , completed : Bool
    , timestamp : String
    , labels : List String
    }


type alias Model =
    { tasks : List Task
    , newTask : String
    , searchTerm : String
    , searchDebounce : Int
    , labels : List Label
    , newLabel : String
    , labelDropdown : Dict String String
    , labelFilters : List String
    }


type alias Label =
    { id : String
    , name : String
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
    | UpdateSearchTerm String
    | DebouncedSearch Int String
    | SearchTasks
    | LabelsFetched (Result Http.Error (List Label))
    | UpdateNewLabel String
    | AddLabel
    | LabelAdded (Result Http.Error Label)
    | SelectLabelDropdown String String
    | ToggleLabelOnTask String String
    | ToggleLabelFilter String
    | NoOp



-- INITIAL STATE


initModel : Model
initModel =
    { tasks = []
    , newTask = ""
    , searchTerm = ""
    , searchDebounce = 0
    , labels = []
    , newLabel = ""
    , labelDropdown = Dict.empty
    , labelFilters = []
    }



-- DECODERS


taskDecoder : Decode.Decoder Task
taskDecoder =
    Decode.map5 Task
        (Decode.field "_id" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "completed" Decode.bool)
        (Decode.field "timestamp" Decode.string)
        (Decode.field "labels" (Decode.list Decode.string))


tasksDecoder : Decode.Decoder (List Task)
tasksDecoder =
    Decode.list taskDecoder


labelDecoder : Decode.Decoder Label
labelDecoder =
    Decode.map2 Label
        (Decode.field "_id" Decode.string)
        (Decode.field "name" Decode.string)


labelsDecoder : Decode.Decoder (List Label)
labelsDecoder =
    Decode.list labelDecoder
