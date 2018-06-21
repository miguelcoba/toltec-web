module Main exposing (main)

import Json.Decode as Decode exposing (Value)
import Navigation
import Model exposing (Model)
import Messages exposing (Msg(..))
import Route exposing (Route)
import Subscriptions exposing (subscriptions)
import Update exposing (update, init)
import View exposing (view)


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
