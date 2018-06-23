module Subscriptions exposing (subscriptions)

import Messages exposing (Msg(..))
import Model exposing (Model, Page(..), PageState(..), getPage)


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

        Login _ ->
            Sub.none

        Register _ ->
            Sub.none
