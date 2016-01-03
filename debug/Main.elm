import Graphics.Element exposing (show)
import Debug
import Time

time : Signal Time.Time
time =
  Signal.map (Debug.watch "time") (Time.every Time.second)

main =
  Signal.map show time
