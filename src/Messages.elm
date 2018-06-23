module Messages exposing (Msg(..))

import Route exposing (Route)
import Session.Login as Login
import Session.Register as Register


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
