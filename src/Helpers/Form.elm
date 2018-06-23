module Helpers.Form exposing (input, password, textarea, viewErrors)

import Html exposing (Attribute, Html, fieldset, li, text, ul, label)
import Html.Attributes as Attr exposing (class, type_, name)


password : String -> List (Attribute msg) -> List (Html msg) -> Html msg
password name attrs =
    control Html.input name ([ type_ "password" ] ++ attrs)


input : String -> List (Attribute msg) -> List (Html msg) -> Html msg
input name attrs =
    control Html.input name ([ type_ "text" ] ++ attrs)


textarea : String -> List (Attribute msg) -> List (Html msg) -> Html msg
textarea name =
    control Html.textarea name


viewErrors : List ( a, String ) -> Html msg
viewErrors errors =
    errors
        |> List.map (\( _, error ) -> li [ class "dib" ] [ text error ])
        |> ul [ class "ph2 tl f6 red measure" ]


control :
    (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> String
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
control element name attributes children =
    fieldset [ class "ba b--transparent ph0 mh0 f6" ]
        [ label [ class "db fw6 lh-copy tl" ] [ text name ]
        , element
            ([ Attr.name name, class "pa2 input-reset ba bg-transparent w-100" ] ++ attributes)
            children
        ]
