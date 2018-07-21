module ViewTests exposing (viewTests)

import Expect
import Html.Attributes exposing (href, name)
import Model exposing (Model, Page(..), PageState(..))
import Session.Login as Login exposing (initialModel)
import Session.Register as Register exposing (initialModel)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, attribute)
import View exposing (view)


initialModel : Model
initialModel =
    { pageState = Loaded Blank, session = Nothing }


viewTests : Test
viewTests =
    describe "View.view"
        [ test "will render the blank view when initially loaded" <|
            \_ ->
                initialModel
                    |> view
                    |> Query.fromHtml
                    |> Query.has [ text "Loading Toltec!" ]
        , test "will render the home view when page is Home" <|
            \_ ->
                { initialModel | pageState = Loaded Home }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ tag "h1" ]
                    |> Query.has [ text "Toltec" ]
        , test "will render the not found view when currentRoute is NotFound" <|
            \_ ->
                { initialModel | pageState = Loaded NotFound }
                    |> view
                    |> Query.fromHtml
                    |> Query.find [ tag "h1" ]
                    |> Query.has [ text "The page you requested was not found!" ]
        , test "will render the login view when currentRoute is Login" <|
            \_ ->
                { initialModel | pageState = Loaded <| Login Login.initialModel }
                    |> view
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.find [ tag "h1" ]
                            >> Query.has [ text "Sign in" ]
                        , Query.find [ tag "p" ]
                            >> Query.find [ tag "a" ]
                            >> Query.has [ attribute <| href "#/register" ]
                        , Query.find [ attribute <| name "Email" ]
                            >> Query.has [ tag "input" ]
                        , Query.find [ attribute <| name "Password" ]
                            >> Query.has [ tag "input" ]
                        ]
        , test "will render the register view when currentRoute is Register" <|
            \_ ->
                { initialModel | pageState = Loaded (Register <| Register.initialModel) }
                    |> view
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.find [ tag "h1" ]
                            >> Query.has [ text "Sign up" ]
                        , Query.find [ tag "p" ]
                            >> Query.find [ tag "a" ]
                            >> Query.has [ attribute <| href "#/login" ]
                        , Query.find [ attribute <| name "Name" ]
                            >> Query.has [ tag "input" ]
                        , Query.find [ attribute <| name "Email" ]
                            >> Query.has [ tag "input" ]
                        , Query.find [ attribute <| name "Password" ]
                            >> Query.has [ tag "input" ]
                        ]
        ]
