module User.Model exposing (User, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Extra exposing (maybe)
import Util exposing ((=>))


type alias User =
    { email : String
    , name : Maybe String
    }


decoder : Decoder User
decoder =
    decode User
        |> required "email" Decode.string
        |> required "name" (Decode.nullable Decode.string)


encode : User -> Value
encode user =
    Encode.object
        [ "email" => Encode.string user.email
        , "name" => (Extra.maybe Encode.string) user.name
        ]
