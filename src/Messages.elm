module Messages exposing (Msg(..))

import Route exposing (Route)
import Session.Login as Login
import Session.Model exposing (Session)
import Session.Register as Register


type Msg
    = SetRoute (Maybe Route)
    | SetSession (Maybe Session)
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
