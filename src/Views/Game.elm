module Views.Game exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)
import String exposing (join)
import StoryElements exposing (..)
import StoryState exposing (..)
import Mechanics exposing (..)
import Views.CurrentSummary exposing (..)
import Views.Storyline exposing (..)
import Views.Locations exposing (..)
import Views.Inventory exposing (..)


view : DisplayInfo a b c -> StoryState a b c d e -> Html (Mechanics.Msg a b c)
view displayInfo storyState =
    let
        toCssColor : Color -> String
        toCssColor =
            toRgb >> \{ red, green, blue } -> String.join "" [ "rgb(", toString red, ",", toString green, ",", toString blue, ")" ]

        cssColor =
            toCssColor <| .color <| displayInfo.locations storyState.currentLocation

        itemMsg =
            Mechanics.Interact << Item

        locationMsg =
            Mechanics.Interact << Location

        characterMsg =
            Mechanics.Interact << Character
    in
        div [ class "GamePage" ]
            [ div [ class "Layout" ]
                [ div [ class "Layout__Main" ]
                    [ h1 [ class "Current-location", style [ ( "backgroundColor", cssColor ) ] ]
                        [ text <| .name <| displayInfo.locations storyState.currentLocation ]
                    , currentSummary itemMsg characterMsg displayInfo toCssColor (flip List.member storyState.familiarWith) storyState
                    , storyline storyState.storyLine
                    ]
                , div [ class "Layout__Sidebar" ]
                    [ locations locationMsg displayInfo.locations storyState.knownLocations storyState.currentLocation toCssColor (flip List.member storyState.familiarWith)
                    , inventory itemMsg displayInfo.items storyState.inventory (flip List.member storyState.familiarWith)
                    ]
                ]
            ]
