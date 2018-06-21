module Subscriptions exposing (subscriptions)

import Model exposing (Model, Page(..), PageState(..), getPage)
import Messages exposing (Msg(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        ]


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Home ->
            Sub.none

        Login ->
            Sub.none

        Register ->
            Sub.none
