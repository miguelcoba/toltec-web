module Helpers.Decode exposing (optionalError, optionalFieldError)

import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, optional)


optionalError : String -> Decoder (String -> a) -> Decoder a
optionalError fieldName =
    optional fieldName string ""


optionalFieldError : String -> Decoder (List String -> a) -> Decoder a
optionalFieldError fieldName =
    let
        errorToString errorMessage =
            String.join " " [ fieldName, errorMessage ]
    in
        optional fieldName (Decode.list (Decode.map errorToString string)) []
