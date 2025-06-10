module Main exposing (main)

import Browser
import Model exposing (Model, Msg, initModel)
import Update exposing (fetchTasksRequest, update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initModel, fetchTasksRequest "" )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
