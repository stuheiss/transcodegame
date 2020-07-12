module Common.View exposing (px, pct)


px : Int -> String
px n =
    String.fromInt n ++ "px"


pct : Int -> String
pct n =
    String.fromInt n ++ "%"
