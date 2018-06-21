module View exposing (..)

import Html exposing (..)
import Model exposing (Model, Page(..), PageState(..))
import Messages exposing (Msg(..))
import Page.Page as Page exposing (ActivePage)
import Page.Home as Home
import Page.NotFound as NotFound
import Session.Login as Login
import Session.Register as Register


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage True page

        TransitioningFrom page ->
            viewPage False page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            Page.frame isLoading
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame Page.Other

            Blank ->
                Html.text "Loading Maya!"

            Home ->
                Home.view
                    |> frame Page.Home

            Login ->
                Login.view
                    |> frame Page.Login

            Register ->
                Register.view
                    |> frame Page.Register
