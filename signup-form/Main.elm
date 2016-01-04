import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, targetValue)
import String
import StartApp
import Effects
import Http
import Task
import Json.Decode exposing (succeed)


type alias Errors =
  { username : String
  , password : String
  }


type alias Model =
  { username : String
  , password : String
  , errors : Errors
  }


initialModel : Model
initialModel =
  Model "" "" initialErrors


initialErrors : Errors
initialErrors =
  { username = ""
  , password = ""
  }


view : Signal.Address Action -> Model -> Html
view address model =
  Html.form
    [ id "signup-form" ]
    [ h1 [] [ text "Sensational Signup Form" ]
    , label [ for "username-field" ] [ text "username: " ]
    , input
        [ id "username-field"
        , type' "text"
        , value model.username
        , on "input" targetValue (\v -> Signal.message address (SetUsername v))
        ] []

    , div [ class "validation-error" ] [ text model.errors.username ]

    , label [ for "password" ] [ text "password: " ]
    , input
        [ id "password-field"
        , type' "password"
        , value model.password
        , on "input" targetValue (\v -> Signal.message address (SetPassword v))
        ] []

    , div [ class "validation-error" ] [ text model.errors.password ]

    , div
        [ class "signup-button"
        , onClick address Validate ] [ text "Sign Up!" ]
    ]


getErrors : Model -> Errors
getErrors model =
  { username =
      if String.isEmpty(model.username) then
        "Please enter a username!"
      else
        ""
  , password =
      if String.isEmpty(model.password) then
        "Please enter a password!"
      else
        ""
  }


type Action
  = Validate
  | SetUsername String
  | SetPassword String
  | UsernameCheck (Maybe Bool)


withUsernameTaken : Bool -> Model -> ( Model, Effects.Effects Action )
withUsernameTaken isTaken model =
  if isTaken then
    let
      { errors } = model
      newErrors = { errors | username = "That username is already taken!" }
    in
      ( { model | errors = newErrors }, Effects.none )
  else
    ( model, Effects.none )


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    Validate ->
      let
        url = "https://api.github.com/users/" ++ model.username
        request =
          Http.get (succeed True) url
            |> Task.toMaybe
            |> Task.map UsernameCheck
            |> Effects.task
      in
        ( { model |
              errors = getErrors model
          }
        , request
        )

    SetUsername rawInput ->
      ( { model |
            username = rawInput
        }
      , Effects.none
      )

    SetPassword rawInput ->
      ( { model |
            password = rawInput
        }
      , Effects.none
      )

    UsernameCheck success ->
      case success of
        Just b ->
          withUsernameTaken True model

        Nothing ->
          withUsernameTaken False model


app =
  StartApp.start
    { init = ( initialModel, Effects.none )
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks
