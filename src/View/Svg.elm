module View.Svg exposing (root, tileSize)

import Common.View exposing (..)
import Dict
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Types exposing (..)
import Narrative exposing (objectToString)
import String exposing (String)


tileSize : Int
tileSize =
    45


fst : ( a, b ) -> a
fst (a, b) = a


snd : ( a, b ) -> b
snd (a, b) = b


uncurry : (a -> b -> c) -> ( a, b ) -> c
uncurry f ( a, b ) =
    f a b


root : Model -> Html Msg
root model =
    svg
        [ width (px (18 * tileSize))
        , height (px (11 * tileSize))
        ]
        [ g []
            (model.world
                |> Dict.toList
                |> List.map (uncurry tile)
            )
        , tile model.player.position (Thing ThePlayer)
        ]


tile : Position -> Cell -> Svg Msg
tile position cell =
    let
        ( preamble, colours, maybeCommand ) =
            case cell of
                Path ->
                    ( defs [] []
                    , [ stroke "grey", fill "#fdfdfd" ]
                    , Just (InteractAt position Path)
                    )

                Block ->
                    ( defs [] []
                    , [ stroke "#0466da", fill "#04c9da" ]
                    , Just (InteractAt position Block)
                    )

                Thing ThePlayer ->
                    ( (patternDefs (objectToString ThePlayer))
                    , [ stroke "#8504da", fill "url(#ThePlayer)" ]
                    , Just (InteractAt position (Thing ThePlayer))
                    )

                Thing object ->
                    ( (patternDefs (objectToString object))
                    , [ stroke "black", fill ("url(#" ++ (objectToString object) ++ ")") ]
                    , Just (InteractAt position (Thing object))
                    )
    in
        g []
            [ preamble
            , rect
                ([ x (String.fromInt (fst position * tileSize))
                 , y (String.fromInt (snd position * tileSize))
                 , width (px tileSize)
                 , height (px tileSize)
                 ]
                    ++ colours
                    ++ (case maybeCommand of
                            Nothing ->
                                []

                            Just command ->
                                [ onClick (PlayerCommand command)
                                ]
                       )
                )
                []
            ]


patternDefs : String -> Svg msg
patternDefs objectName =
    defs []
        [ pattern
            [ id objectName
            , patternUnits "userSpaceOnUse"
            , width (px tileSize)
            , height (px tileSize)
            ]
            [ image
                [ xlinkHref ("../static/images/" ++ objectName ++ ".png")
                , x (px 0)
                , y (px 0)
                , width (px tileSize)
                , height (px tileSize)
                ]
                []
            ]
        ]
