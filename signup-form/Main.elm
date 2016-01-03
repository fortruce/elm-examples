import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
  { username : String
  , password : String
  }


init : Model
init =
  Model "" ""


view : Model -> Html
view model =
  Html.form
    [ id "signup-form" ]
    [ h1 [] [ text "Sensational Signup Form" ]
    , label [ for "username-field" ] [ text "username: " ]
    , input
        [ id "username-field"
        , type' "text"
        , value model.username
        ] []
    , label [ for "password" ] [ text "password: " ]
    , input
        [ id "password-field"
        , type' "password"
        , value model.password
        ] []
    , div [ class "signup-button" ] [ text "Sign Up!" ]
    ]

main =
  view init
