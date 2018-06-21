module Model exposing (Model, initialModel, Page(..), PageState(..), getPage)

import Json.Decode as Decode exposing (Value)


type Page
    = Blank
    | NotFound
    | Home
    | Login
    | Register


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState
    }


initialModel : Value -> Model
initialModel val =
    { pageState = Loaded Blank
    }


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page
