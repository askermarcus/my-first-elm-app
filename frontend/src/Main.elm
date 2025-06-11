module Main exposing (main)

import Browser
import Model exposing (Model, Msg, initModel)
import Update exposing (fetchLabelsRequest, fetchTasksRequest, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initModel, Cmd.batch [ fetchTasksRequest "", fetchLabelsRequest ] )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
