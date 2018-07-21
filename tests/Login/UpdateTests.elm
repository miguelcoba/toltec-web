module Login.UpdateTests exposing (loginUpdateTests)

import Dict
import Expect
import Http
import Navigation exposing (Location)
import Session.AuthToken as AuthToken exposing (AuthToken(..))
import Session.Login as Login exposing (Model, update, Msg(..), Field(..))
import Session.Model exposing (Session)
import Test exposing (..)
import User.Model exposing (User)
import Util exposing ((=>))


testLocation : Location
testLocation =
    { hash = ""
    , host = "example.com"
    , hostname = "example.com"
    , href = ""
    , origin = ""
    , password = ""
    , pathname = ""
    , port_ = ""
    , protocol = "http"
    , search = ""
    , username = ""
    }


initialModel : Model
initialModel =
    { errors = [], email = "", password = "" }


httpResponse : Http.Error
httpResponse =
    let
        body =
            """
            {"errors": {"error": "User or email invalid"}}
            """
    in
        Http.Response "" { code = 200, message = "" } (Dict.empty) body
            |> Http.BadStatus


session : Session
session =
    { user = User "" (Just ""), token = (AuthToken "") }


loginUpdateTests : Test
loginUpdateTests =
    describe "Login.update"
        [ test "SetEmail sets the email in the Login model" <|
            \_ ->
                initialModel
                    |> update (SetEmail "some@email")
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .email >> Expect.equal "some@email"
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SetPassword sets the password in the Login model" <|
            \_ ->
                initialModel
                    |> update (SetPassword "some password")
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .password >> Expect.equal "some password"
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SubmitForm sends the data to the api" <|
            \_ ->
                { initialModel | email = "some@email", password = "password" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equal []
                        , Tuple.second >> Expect.notEqual Cmd.none
                        ]
        , test "SubmitForm validates that email is not empty" <|
            \_ ->
                { initialModel | email = "", password = "password" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Email => "email can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SubmitForm validates that password is not empty" <|
            \_ ->
                { initialModel | email = "some@email", password = "" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Password => "password can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "LoginCompleted (Err error) collects all errors" <|
            \_ ->
                initialModel
                    |> update (LoginCompleted <| Err <| httpResponse)
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Form => "User or email invalid") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "LoginCompleted (Ok session) has no errors" <|
            \_ ->
                initialModel
                    |> update (LoginCompleted <| Ok session)
                    |> Tuple.first
                    |> Tuple.first
                    |> .errors
                    |> Expect.equal []
        ]
