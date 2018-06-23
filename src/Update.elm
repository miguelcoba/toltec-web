module Update exposing (update, init)

import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model, initialModel, Page(..), PageState(..), getPage)
import Navigation exposing (Location)
import Route exposing (Route)
import Session.Login as Login
import Session.Register as Register
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
            { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none

        Just Route.Logout ->
            model => Cmd.none

        Just Route.Register ->
            { model | pageState = Loaded (Register Register.initialModel) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( SetRoute route, _ ) ->
            updateRoute route model

        ( LoginMsg subMsg, Login subModel ) ->
            let
                ( ( pageModel, cmd ), msgFromPage ) =
                    Login.update subMsg subModel

                newModel =
                    case msgFromPage of
                        Login.NoOp ->
                            model

                        Login.SetSession session ->
                            { model | session = Just session }
            in
                { newModel | pageState = Loaded (Login pageModel) }
                    => Cmd.map LoginMsg cmd

        ( RegisterMsg subMsg, Register subModel ) ->
            let
                ( ( pageModel, cmd ), msgFromPage ) =
                    Register.update subMsg subModel

                newModel =
                    case msgFromPage of
                        Register.NoOp ->
                            model

                        Register.SetSession session ->
                            { model | session = Just session }
            in
                { newModel | pageState = Loaded (Register pageModel) }
                    => Cmd.map RegisterMsg cmd

        ( _, NotFound ) ->
            -- Disregard incoming messages when we're on the
            -- NotFound page.
            model => Cmd.none

        ( _, _ ) ->
            -- Disregard incoming messages that arrived for the wrong page
            model => Cmd.none
