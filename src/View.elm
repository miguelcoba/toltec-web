module View exposing (..)

import Html exposing (..)
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..))
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Page as Page exposing (ActivePage)
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

            Login subModel ->
                Login.view subModel
                    |> frame Page.Login
                    |> Html.map LoginMsg

            Register subModel ->
                Register.view subModel
                    |> frame Page.Register
                    |> Html.map RegisterMsg
