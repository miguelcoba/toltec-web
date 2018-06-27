module Page.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)
import Session.Model exposing (Session)


type ActivePage
    = Other
    | Home
    | Login
    | Register


frame : Bool -> Maybe Session -> ActivePage -> Html msg -> Html msg
frame isLoading session activePage content =
    div []
        [ viewHeader session activePage isLoading
        , content
        ]


viewHeader : Maybe Session -> ActivePage -> Bool -> Html msg
viewHeader session activePage isLoading =
    nav [ class "dt w-100 border-box pa3 ph5-ns" ]
        [ a [ class "dtc v-mid mid-gray link dim w-25", Route.href Route.Home, title "Home" ]
            [ text "Toltec" ]
        , div [ class "dtc v-mid w-75 tr" ] <|
            navbarLink activePage Route.Home [ text "Home" ]
                :: viewNavBar session activePage
        ]


viewNavBar : Maybe Session -> ActivePage -> List (Html msg)
viewNavBar session activePage =
    let
        linkTo =
            navbarLink activePage
    in
        case session of
            Nothing ->
                [ linkTo Route.Login [ text "Login" ]
                , linkTo Route.Register [ text "Register" ]
                ]

            Just session ->
                [ linkTo Route.Logout [ text "Logout" ]
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
