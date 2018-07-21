module Tests exposing (..)

import Login.UpdateTests exposing (loginUpdateTests)
import Register.UpdateTests exposing (registerUpdateTests)
import RouteTests exposing (routeTests)
import Test exposing (..)
import UpdateTests exposing (updateTests)
import ViewTests exposing (viewTests)


all : Test
all =
    describe "Toltec Test Suite"
        [ routeTests
        , updateTests
        , viewTests
        , loginUpdateTests
        , registerUpdateTests
        ]
