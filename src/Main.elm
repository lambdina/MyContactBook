module Main exposing (..)

import Browser
import Contact exposing (init, viewRoot, updateWithStorage)
import Types exposing (Model, Msg)
import Json.Encode as E

main : Program E.Value Model Msg
main =
  Browser.element
    { init = init
    , view = viewRoot
    , update = updateWithStorage
    , subscriptions = \_ -> Sub.none
    }
