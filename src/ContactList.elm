module ContactList exposing (viewContactList)
import Types as T exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (..)
    

viewSearchBar : Model -> Html Msg
viewSearchBar model =
  div [ class "flex justify-between items-center mb-4" ]
    [ h5 [ class "text-xl font-bold leading-none text-gray-900 dark:text-white" ]
        [ text "All Contacts" ]
    , button
      [ type_ "submit"
      , class "text-sm font-medium text-purple-600 hover:underline dark:text-purple-500"]
      [ text "Clear" ]
  ] --TODO search bar

viewContactList : Model -> Html Msg
viewContactList model =
  div [ class "h-screen border border-gray-200 w-1/4 bg-white sm:p-8 dark:bg-gray-800 dark:border-gray-700" ] [
      viewSearchBar model
    , div [ class "flow-root" ] [
        ul [ class "divide-y-2 divide-gray-200 dark:divide-gray-700"]
          (List.map (\contact -> viewContactCard contact) model.allContacts)
      ]
  ]

viewContactCard : Contact -> Html Msg
viewContactCard contact =
  li [ class "py-3 sm:py-4 hover:bg-gray-100"] [
      button
        [ class "flex items-center space-x-4"
        , onClick (T.ClickDetailContact contact)
        , value contact.contactId ]
          [ div [ class "flex-shrink-0" ] [
            img [ class "w-8 h-8 rounded-full", src "https://oahurcd.org/wp-content/uploads/2021/12/profile-avatar.jpg" ] []
          ]
        , div [ class "flex-1 min-w-0" ]
            [ p [ class "text-sm font-medium text-gray-900 truncate dark:text-white" ] [ text contact.name ]
            , p [ class "text-sm text-gray-500 truncate dark:text-gray-400" ] [ text contact.email ] ]
            , if contact.isFavorite then div [ class "inline-flex items-center text-base font-semibold text-gray-900 dark:text-white" ]
                [ viewFavoriteIcon ]
              else div [] []
        ]
  ]

viewFavoriteIcon : Html Msg
viewFavoriteIcon = 
  i [ class "fa fa-star" ] []
