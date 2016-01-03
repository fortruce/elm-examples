import Graphics.Element exposing (..)
import Mouse

type alias Coordinate = (Int, Int)
type alias Distance = Float


-- Constant signal of coordinate
point : Signal Coordinate
point =
  Signal.constant (20, 20)


-- Distance between two coordinate tuples
distance : Coordinate -> Coordinate -> Distance
distance (x1, y1) (x2, y2) =
  let
    deltax = (x2 - x1)^2
    deltay = (y2 - y1)^2
  in
    sqrt (deltax + deltay)


distanceSignal : Signal Distance
distanceSignal =
  Signal.map2 distance point Mouse.position


main : Signal Element
main =
  Signal.map show distanceSignal
