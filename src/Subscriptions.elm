module Subscriptions exposing (subscriptions)

import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..), getPage)
import Session.Model exposing (sessionChangeSubscription)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        , Sub.map SetSession sessionChangeSubscription
        ]


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Error _ ->
            Sub.none

        Home ->
            Sub.none

        Login _ ->
            Sub.none

        Register _ ->
            Sub.none
