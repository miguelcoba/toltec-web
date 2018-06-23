module Session.Register exposing (ExternalMsg(..), Model, Msg, initialModel, update, view)

import Helpers.Decode exposing (optionalError, optionalFieldError)
import Helpers.Form as Form
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode)
import Route exposing (Route)
import Session.Model exposing (Session)
import Session.Request exposing (register)
import Util exposing ((=>))
import Validate exposing (Validator, ifBlank, validate)


-- MESSAGES --


type Msg
    = SubmitForm
    | SetName String
    | SetEmail String
    | SetPassword String
    | RegisterCompleted (Result Http.Error Session)


type ExternalMsg
    = NoOp
    | SetSession Session



-- MODEL --


type alias Model =
    { errors : List Error
    , name : String
    , email : String
    , password : String
    }


initialModel : Model
initialModel =
    { errors = []
    , name = ""
    , email = ""
    , password = ""
    }



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "mt4 mt6-l pa4" ]
        [ h1 [] [ text "Sign up" ]
        , p [ class "f7" ]
            [ a [ Route.href Route.Login ]
                [ text "Have an account?" ]
            ]
        , div [ class "measure center" ]
            [ Form.viewErrors model.errors
            , viewForm
            ]
        ]


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input "Name" [ onInput SetName ] []
        , Form.input "Email" [ onInput SetEmail ] []
        , Form.password "Password" [ onInput SetPassword ] []
        , button [ class "b ph3 pv2 input-reset ba b--black bg-transparent grow pointer f6" ] [ text "Sign up" ]
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    { model | errors = [] }
                        => Http.send RegisterCompleted (register model)
                        => NoOp

                errors ->
                    { model | errors = errors }
                        => Cmd.none
                        => NoOp

        SetName name ->
            { model | name = name }
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

        RegisterCompleted (Err error) ->
            let
                errorMessages =
                    case error of
                        Http.BadStatus response ->
                            response.body
                                |> decodeString (field "errors" errorsDecoder)
                                |> Result.withDefault []

                        _ ->
                            [ "Unable to process registration" ]
            in
                { model | errors = List.map (\errorMessage -> Form => errorMessage) errorMessages }
                    => Cmd.none
                    => NoOp

        RegisterCompleted (Ok session) ->
            model
                => Route.modifyUrl Route.Home
                => SetSession session



-- VALIDATION --


type Field
    = Form
    | Name
    | Email
    | Password


type alias Error =
    ( Field, String )


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ ifBlank .name (Name => "name can't be blank.")
        , ifBlank .email (Email => "email can't be blank.")
        , ifBlank .password (Password => "password can't be blank.")
        ]



-- DECODERS --


errorsDecoder : Decoder (List String)
errorsDecoder =
    decode (\name email password error -> error :: List.concat [ name, email, password ])
        |> optionalFieldError "name"
        |> optionalFieldError "email"
        |> optionalFieldError "password"
        |> optionalError "error"
