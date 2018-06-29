module Page.Error exposing (PageError, pageError, view)

import Html exposing (Html, div, h1, main_, p, text)
import Page.Page exposing (ActivePage)


type PageError
    = PageError Model


type alias Model =
    { activePage : ActivePage
    , errorMessage : String
    }


pageError : ActivePage -> String -> PageError
pageError activePage errorMessage =
    PageError { activePage = activePage, errorMessage = errorMessage }


view : PageError -> Html msg
view (PageError model) =
    main_ []
        [ h1 [] [ text "Something wrong happened" ]
        , div []
            [ p [] [ text model.errorMessage ] ]
        ]
