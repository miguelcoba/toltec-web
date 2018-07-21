module RouteTests exposing (routeTests)

import Expect
import Navigation exposing (Location)
import Route exposing (Route(..), fromLocation)
import Test exposing (..)


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


routeTests : Test
routeTests =
    describe "Route.fromLocation"
        [ test "will go to the Root route when hash is empty" <|
            \_ ->
                testLocation
                    |> fromLocation
                    |> Expect.equal (Just Root)
        , test "will go to the Home route when hash is '#/'" <|
            \_ ->
                { testLocation | hash = "#/" }
                    |> fromLocation
                    |> Expect.equal (Just Home)
        , test "will go to the Login route when hash is '#/login'" <|
            \_ ->
                { testLocation | hash = "#/login" }
                    |> fromLocation
                    |> Expect.equal (Just Login)
        , test "will go to the Logout route when hash is '#/logout'" <|
            \_ ->
                { testLocation | hash = "#/logout" }
                    |> fromLocation
                    |> Expect.equal (Just Logout)
        , test "will go to the Register route when hash is '#/register'" <|
            \_ ->
                { testLocation | hash = "#/register" }
                    |> fromLocation
                    |> Expect.equal (Just Register)
        , test "will go to the Nothing route when hash is other" <|
            \_ ->
                { testLocation | hash = "#/nonexistingroute" }
                    |> fromLocation
                    |> Expect.equal Nothing
        ]
