module View exposing (root)

import Common.View exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Narrative exposing (nameOf)
import Types exposing (..)
import View.Svg


root : Model -> Html Msg
root model =
    div
        [ id "main-content"
        , style "width" (px (19 * View.Svg.tileSize))
        , style "height" (px (12 * View.Svg.tileSize))
        , style "margin" "0 auto"
        ]
        [ div
            [ style "perspective" (px 1000)
            , style "margin-top" (px -50)
            , style "text-align" "center"
            ]
            [ div
                [ style "transform" "rotate3d(1,0,0,35deg)"
                , style "width" (pct 100)
                , style "height" (pct 100)
                ]
                [ View.Svg.root model ]
            ]
        , p [ class "dialogue" ]
            [ text (Maybe.withDefault "" model.dialogue) ]
        , div [ class "btn-group" ]
            (List.map commandButton
                [ ( PartialCommand PartialPickUp, "Pick up" )
                , ( PartialCommand PartialExamine, "Examine" )
                , ( PartialCommand PartialUse, "Use" )
                ]
            )
        , inventoryView model.player.inventory
        , partialCommandView model.partialCommand
        ]


inventoryView : List Object -> Html Msg
inventoryView inventory =
    div []
        [ h4 [] [ text "Inventory" ]
        , div [ class "inventory" ]
            (List.map inventoryObjectView inventory)
        ]


inventoryObjectView : Object -> Html Msg
inventoryObjectView object =
    button
        [ class "btn btn.info inventory-button"
        , onClick (PlayerCommand (Interact (Thing object)))
        , style "background-image" ("url(images/" ++ nameOf object ++ ".png")
        ]
        [ text (nameOf object) ]


partialCommandView : Maybe PartialCommand -> Html msg
partialCommandView partialCommand =
    div []
        [ text
            (case partialCommand of
                Nothing ->
                    ""

                Just PartialPickUp ->
                    "Pick up..."

                Just PartialExamine ->
                    "Examine..."

                Just PartialUse ->
                    "Use..."

                Just (PartialUseOne thing) ->
                    "Use " ++ Narrative.nameOf thing ++ " with..."
            )
        ]


commandButton : ( Command, String ) -> Html Msg
commandButton ( command, title ) =
    button
        [ class "btn btn-lg btn-info"
        , onClick (PlayerCommand command)
        ]
        [ text title ]
