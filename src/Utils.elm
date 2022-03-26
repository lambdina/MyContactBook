module Utils exposing (..)
import Types exposing (..)
import Html.Attributes exposing (action, checked, class, id)
import Html.Events exposing (..)
import Html exposing (..)

checkBox : Msg -> Bool -> String -> Html Msg
checkBox action isChecked title =
    label [class "flex items-center cursor-pointer relative mb-4"] [
        div
            [ class ("h-4 w-4 rounded-full border border-gray-500" ++ if isChecked then " bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700" else " bg-gradient-to-r from-gray-200 to-gray-300")
            , id "toggle-example"
            , checked False
            , onClick action
            ] []
        , span [class "ml-3 text-gray-700 text-xs"] [text title]
    ]

tab : Bool -> String -> Html Msg
tab isCurrent title =
    li [ class "mr-2" ] [
        case isCurrent of
            True ->
                (p [ class ("text-xs inline-block p-4 text-purple-600 rounded-t-lg border-b-2 border-purple-600 active dark:text-purple-500 dark:border-purple-500")
                    , onClick FilterByFavoriteMode ] [ text title ])
            False ->
                (p [ class (" text-xs inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300")
                    , onClick FilterByFavoriteMode ] [ text title ])
        ]     