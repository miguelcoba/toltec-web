module Session.Login exposing (ExternalMsg(..), Model, Msg(..), Field(..), initialModel, update, view)

import Helpers.Decode exposing (optionalError, optionalFieldError)
import Helpers.Form as Form
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode)
import Route exposing (Route)
import Session.Model exposing (Session, storeSession)
import Session.Request exposing (login)
import Util exposing ((=>))
import Validate exposing (Validator, ifBlank, validate)


-- MESSAGES --


type Msg
    = SubmitForm
    | SetEmail String
    | SetPassword String
    | LoginCompleted (Result Http.Error Session)


type ExternalMsg
    = NoOp
    | SetSession Session



-- MODEL --


type alias Model =
    { errors : List Error
    , email : String
    , password : String
    }


initialModel : Model
initialModel =
    { errors = []
    , email = ""
    , password = ""
    }



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "mt4 mt6-l pa4" ]
        [ h1 [] [ text "Sign in" ]
        , p [ class "f7" ]
            [ a [ Route.href Route.Register ]
                [ text "Need an account?" ]
            ]
        , div [ class "measure center" ]
            [ Form.viewErrors model.errors
            , viewForm
            ]
        ]


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input "Email" [ onInput SetEmail ] []
        , Form.password "Password" [ onInput SetPassword ] []
        , button [ class "b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6" ] [ text "Sign in" ]
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    { model | errors = [] }
                        => Http.send LoginCompleted (login model)
                        => NoOp

                errors ->
                    { model | errors = errors }
                        => Cmd.none
                        => NoOp

        SetEmail email ->
            { model | email = email }
                => Cmd.none
                => NoOp

        SetPassword password ->
            { model | password = password }
                => Cmd.none
                => NoOp

        LoginCompleted (Err error) ->
            let
                errorMessages =
                    case error of
                        Http.BadStatus response ->
                            response.body
                                |> decodeString (field "errors" errorsDecoder)
                                |> Result.withDefault []

                        _ ->
                            [ "Unable to perform login" ]
            in
                { model | errors = List.map (\errorMessage -> Form => errorMessage) errorMessages }
                    => Cmd.none
                    => NoOp

        LoginCompleted (Ok session) ->
            model
                => Cmd.batch [ storeSession session, Route.modifyUrl Route.Home ]
                => SetSession session



-- VALIDATION --


type Field
    = Form
    | Email
    | Password


type alias Error =
    ( Field, String )


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ ifBlank .email (Email => "email can't be blank.")
        , ifBlank .password (Password => "password can't be blank.")
        ]



-- DECODERS --


errorsDecoder : Decoder (List String)
errorsDecoder =
    decode (\email password error -> error :: List.concat [ email, password ])
        |> optionalFieldError "email"
        |> optionalFieldError "password"
        |> optionalError "error"
