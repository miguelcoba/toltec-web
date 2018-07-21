module Register.UpdateTests exposing (registerUpdateTests)

import Dict
import Expect
import Http
import Navigation exposing (Location)
import Session.AuthToken as AuthToken exposing (AuthToken(..))
import Session.Model exposing (Session)
import Session.Register as Register exposing (Model, update, Msg(..), Field(..))
import Set
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
    { errors = [], name = "", email = "", password = "" }


nameError : String
nameError =
    """
    "name": ["can't be blank."]
    """


emailError : String
emailError =
    """
    "email": ["can't be blank."]
    """


passwordError : String
passwordError =
    """
    "password": ["can't be blank."]
    """


nameEmailPasswordError : String
nameEmailPasswordError =
    nameError ++ ", " ++ emailError ++ ", " ++ passwordError


httpResponse : String -> Http.Error
httpResponse error =
    let
        body =
            "{\"errors\": {" ++ error ++ "}}"
    in
        Http.Response "" { code = 200, message = "" } (Dict.empty) body
            |> Http.BadStatus


session : Session
session =
    { user = User "" (Just ""), token = (AuthToken "") }


registerUpdateTests : Test
registerUpdateTests =
    describe "Register.update"
        [ test "SetName sets the name in the Register model" <|
            \_ ->
                initialModel
                    |> update (SetName "some name")
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .name >> Expect.equal "some name"
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SetEmail sets the email in the Register model" <|
            \_ ->
                initialModel
                    |> update (SetEmail "some@email")
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .email >> Expect.equal "some@email"
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SetPassword sets the password in the Register model" <|
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
                { initialModel | name = "some name", email = "some@email", password = "password" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equal []
                        , Tuple.second >> Expect.notEqual Cmd.none
                        ]
        , test "SubmitForm validates that name is not empty" <|
            \_ ->
                { initialModel | name = "", email = "some@email", password = "password" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Name => "name can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SubmitForm validates that email is not empty" <|
            \_ ->
                { initialModel | name = "some name", email = "", password = "password" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Email => "email can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "SubmitForm validates that password is not empty" <|
            \_ ->
                { initialModel | name = "some name", email = "some@email", password = "" }
                    |> update SubmitForm
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Password => "password can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "RegisterCompleted (Err error) collects name error" <|
            \_ ->
                initialModel
                    |> update (RegisterCompleted <| Err <| httpResponse nameError)
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Form => "name can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "RegisterCompleted (Err error) collects email error" <|
            \_ ->
                initialModel
                    |> update (RegisterCompleted <| Err <| httpResponse emailError)
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Form => "email can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "RegisterCompleted (Err error) collects password error" <|
            \_ ->
                initialModel
                    |> update (RegisterCompleted <| Err <| httpResponse passwordError)
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first >> .errors >> Expect.equalLists [ (Form => "password can't be blank.") ]
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "RegisterCompleted (Err error) collects all errors" <|
            \_ ->
                initialModel
                    |> update (RegisterCompleted <| Err <| httpResponse nameEmailPasswordError)
                    |> Tuple.first
                    |> Expect.all
                        [ Tuple.first
                            >> .errors
                            >> List.map Tuple.second
                            >> Set.fromList
                            >> Expect.equalSets (Set.fromList [ "name can't be blank.", "email can't be blank.", "password can't be blank." ])
                        , Tuple.second >> Expect.equal Cmd.none
                        ]
        , test "RegisterCompleted (Ok session) has no errors" <|
            \_ ->
                initialModel
                    |> update (RegisterCompleted <| Ok session)
                    |> Tuple.first
                    |> Tuple.first
                    |> .errors
                    |> Expect.equal []
        ]
