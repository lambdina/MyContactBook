module EditContact exposing (viewForm)
import Types as T exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (..)

viewForm : Model -> Html Msg
viewForm model = 
    Html.form 
        [ onSubmit T.SaveContact, class "flex flex-col bg-white shadow-md rounded-md w-full max-w-md" ] [
              viewHead model
            , viewFormContact model.currentContact
            , Html.div [class "flex justify-around bg-white py-2.5"] [
                button [onClick T.SaveContact, type_ "submit", class "px-8 text-purple-600 hover:bg-purple-100 text-lg rounded-full focus:ring-blue-500 focus:border-blue-500 p-2.5 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"]
                  [text "Save"]
            ]
        ]

viewHead : Model -> Html Msg
viewHead model =
      (Html.div [ class "p-4 bg-gray-100 border-t-2 border-purple-600 bg-opacity-5"] [
        Html.div [ class "max-w-sm mx-auto md:w-full md:mx-0" ] [
            Html.div [ class "flex justify-center items-center py-2" ] [
              Html.h1 [class "text-gray-900 text-2xl font-bold"] [ text "New contact" ]
          ]
        ]
    ])

viewInputField : String -> Html Msg -> Html Msg
viewInputField label input_ =
    Html.div [class "relative z-0 mb-6 w-full group"] [
        input_
      , Html.label [ class "absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-purple-600 peer-focus:dark:text-purple-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6" ]
          [ text label ]
      , p [ class "text-xs py-1.5 text-purple-600"] [ text "required" ]
    ]

viewFormContact : Contact -> Html Msg
viewFormContact contact =
    Html.div [class "space-y-6 bg-white divide-y-2"] [
        Html.div [class "px-12"] [
          viewInputField "Name"
            (input
            [ class "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-purple-500 focus:outline-none focus:ring-0 focus:border-purple-600 peer"
            , type_ "name"
            , placeholder ""
            , onInput T.NameChanged
            , value contact.name
            , required True ] [])
            , viewInputField "Email"
            (input
            [ class "block py-2.5 px-2.5 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-purple-500 focus:outline-none focus:ring-0 focus:border-purple-500 peer"
            , type_ "text"
            , placeholder ""
            , onInput T.EmailChanged
            , value contact.email
            , required True ] [])
        ]
        ,div [ class "text-gray-900 py-4 px-12" ] [
          Html.div [class "py-4 grid"] [
              viewFavorite contact
              , input
                [ class "block py-2.5 px-0 w-2/3 text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-purple-500 focus:outline-none focus:ring-0 focus:border-purple-600 peer"
                , type_ "phone"
                , id "phone"
                , placeholder "Phone number (optional)"
                , onInput T.PhoneNumberChanged
                , value contact.phoneNumber] []
            ]
          ]
    ]

viewFavorite : Contact -> Html Msg
viewFavorite contact =
    label [class "flex items-center cursor-pointer relative mb-4"] [
        button
            [ class ("h-4 w-4 rounded-full border border-gray-500" ++ if contact.isFavorite then " bg-gradient-to-r from-purple-500 via-purple-600 to-purple-700" else " bg-gradient-to-r from-gray-200 to-gray-300")
            , type_ "submit"
            , id "toggle-example"
            , checked False
            , onClick T.FavoriteChanged
            ] []
        , span [class "ml-3 text-gray-700 text-sm"] [text "Favorite contact"]
    ]
