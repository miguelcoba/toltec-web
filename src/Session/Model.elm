module Session.Model exposing (Session, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Encode as Encode exposing (Value)
import Session.AuthToken as AuthToken exposing (AuthToken, decoder)
import User.Model as User exposing (User, decoder)
import Util exposing ((=>))


type alias Session =
    { user : User
    , token : AuthToken
    }


decoder : Decoder Session
decoder =
    decode Session
        |> required "user" User.decoder
        |> required "token" AuthToken.decoder


encode : Session -> Value
encode session =
    Encode.object
        [ "user" => User.encode session.user
        , "token" => AuthToken.encode session.token
        ]
