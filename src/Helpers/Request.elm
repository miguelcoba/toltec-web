module Helpers.Request exposing (apiUrl, withAuthorization)

import HttpBuilder exposing (RequestBuilder, withHeader)
import Session.AuthToken exposing (AuthToken(..))
import Session.Model exposing (Session)


apiUrl : String -> String
apiUrl str =
    "http://localhost:4000/api" ++ str


withAuthorization : Maybe Session -> RequestBuilder a -> RequestBuilder a
withAuthorization session builder =
    case session of
        Just s ->
            let
                (AuthToken token) =
                    s.token
            in
                builder
                    |> withHeader "authorization" ("Bearer " ++ token)

        Nothing ->
            builder
