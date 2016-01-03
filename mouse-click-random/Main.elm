import Html exposing (Html, div, text)
import Mouse
import Random exposing (..)

type alias Model =
  { seed : Seed
  , num : Int
  }


init : Model
init =
  { seed = initialSeed 0
  , num = 0
  }


-- Random number generator
randNum : Generator Int
randNum =
  int 0 10


-- Generate a new random number based on the prevous seed
update : () -> Model -> Model
update c { seed } =
  let
    (i, seed) = generate randNum seed
  in
    Model seed i


view : Model -> Html
view { num } =
  div []
    [ text (toString num) ]


-- Update the model on each Mouse.click
main : Signal Html
main =
  Signal.map view (Signal.foldp update init Mouse.clicks)
