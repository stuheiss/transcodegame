module Main exposing (..)

import Browser
import Html exposing (Html, text, pre)
import Http
import State
import View



-- MAIN


main =
  Browser.element
    { init = State.initialState
    , view = View.root
    , subscriptions = State.subscriptions
    , update = State.update
    }
