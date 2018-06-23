module Main exposing (main)

import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Navigation
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
