module Messages exposing (Msg(..))

import Route exposing (Route)


type Msg
    = SetRoute (Maybe Route)
