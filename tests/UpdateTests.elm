module UpdateTests exposing (updateTests)

import Expect
import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..))
import Navigation exposing (Location)
import Route exposing (Route(..), fromLocation)
import Test exposing (..)
import Update exposing (update)


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
    { pageState = Loaded Blank, session = Nothing }


updateTests : Test
updateTests =
    describe "Update.update"
        [ test "will go to the Home page when hash is '#/'" <|
            \_ ->
                let
                    location =
                        { testLocation | hash = "#/" }
                in
                    initialModel
                        |> update (Route.fromLocation >> SetRoute <| location)
                        |> Tuple.first
                        |> .pageState
                        |> Expect.equal (Loaded Model.Home)
        , test "will go to the NotFound route when hash is other" <|
            \_ ->
                let
                    location =
                        { testLocation | hash = "#/unexistingroute" }
                in
                    initialModel
                        |> update (Route.fromLocation >> SetRoute <| location)
                        |> Tuple.first
                        |> .pageState
                        |> Expect.equal (Loaded Model.NotFound)
        ]
