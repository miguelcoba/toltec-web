module View exposing (..)

import Html exposing (..)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..))
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Page as Page exposing (ActivePage)
import Session.Login as Login
import Session.Model exposing (Session)
import Session.Register as Register


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage True model.session page

        TransitioningFrom page ->
            viewPage False model.session page


viewPage : Bool -> Maybe Session -> Page -> Html Msg
viewPage isLoading session page =
    let
        frame =
            Page.frame isLoading session
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame Page.Other

            Blank ->
                Html.text "Loading Toltec!"

            Home ->
                Home.view
                    |> frame Page.Home

            Login subModel ->
                Login.view subModel
                    |> frame Page.Login
                    |> Html.map LoginMsg

            Register subModel ->
                Register.view subModel
                    |> frame Page.Register
                    |> Html.map RegisterMsg
