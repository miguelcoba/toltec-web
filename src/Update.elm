module Update exposing (update, init)

import Json.Decode as Decode exposing (Value)
import Model exposing (Model, initialModel, Page(..), PageState(..), getPage)
import Messages exposing (Msg(..))
import Navigation exposing (Location)
import Route exposing (Route)
import Util exposing ((=>))


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    updateRoute (Route.fromLocation location) (initialModel val)


updateRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
updateRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded NotFound } => Cmd.none

        Just Route.Home ->
            { model | pageState = Loaded Home } => Cmd.none

        Just Route.Root ->
            model => Route.modifyUrl Route.Home

        Just Route.Login ->
            { model | pageState = Loaded Login } => Cmd.none

        Just Route.Logout ->
            model => Cmd.none

        Just Route.Register ->
            { model | pageState = Loaded Register } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            updateRoute route model
