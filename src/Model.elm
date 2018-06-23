module Model exposing (Model, initialModel, Page(..), PageState(..), getPage)

import Json.Decode as Decode exposing (Value)
import Session.Login as Login
import Session.Register as Register
import Session.Model as Session exposing (Session)


type Page
    = Blank
    | NotFound
    | Home
    | Login Login.Model
    | Register Register.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { session : Maybe Session
    , pageState : PageState
    }


initialModel : Value -> Model
initialModel val =
    { session = Nothing
    , pageState = Loaded Blank
    }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
