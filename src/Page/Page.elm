module Page.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)


type ActivePage
    = Other
    | Home
    | Login
    | Register


frame : Bool -> ActivePage -> Html msg -> Html msg
frame isLoading activePage content =
    div []
        [ viewHeader activePage isLoading
        , content
        ]


viewHeader : ActivePage -> Bool -> Html msg
viewHeader activePage isLoading =
    nav [ class "dt w-100 border-box pa3 ph5-ns" ]
        [ a [ class "dtc v-mid mid-gray link dim w-25", Route.href Route.Home, title "Home" ]
            [ text "Maya" ]
        , div [ class "dtc v-mid w-75 tr" ] <|
            [ navbarLink activePage Route.Home [ text "Home" ]
            , navbarLink activePage Route.Login [ text "Login" ]
            , navbarLink activePage Route.Register [ text "Register" ]
            ]
        ]


navbarLink : ActivePage -> Route -> List (Html msg) -> Html msg
navbarLink activePage route linkContent =
    let
        active =
            case isActive activePage route of
                True ->
                    "black"

                False ->
                    "gray"
    in
        a [ Route.href route, class "link hover-black f6 f5-ns dib mr3 mr4-ns", class active ] linkContent


isActive : ActivePage -> Route -> Bool
isActive activePage route =
    case ( activePage, route ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( Register, Route.Register ) ->
            True

        _ ->
            False
