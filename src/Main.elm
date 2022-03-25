port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Json.Encode as E

main : Program E.Value Model Msg
main =
  Browser.element
    { init = init
    , view = viewRoot
    , update = updateWithStorage
    , subscriptions = \_ -> Sub.none
    }


-- MODEL
type alias Contact =
  { name : String
  , email : String
  , phoneNumber : String
  , isFavorite : Bool
  }

type alias Model =
    { currentContact : Contact
    , allContacts : List Contact}

type Msg
  = NameChanged String
  | EmailChanged String
  | PhoneNumberChanged String
  | FavoriteChanged
  | SaveContact


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NameChanged name ->
      ( {model | currentContact = setName name model.currentContact}
      , Cmd.none
      )

    EmailChanged email ->
      ( {model | currentContact = setEmail email model.currentContact}
      , Cmd.none
      )
    PhoneNumberChanged phoneNumber ->
        ( {model | currentContact = setPhoneNumber phoneNumber model.currentContact}
        , Cmd.none
        )
    FavoriteChanged ->
      ( {model | currentContact = setFavorite model.currentContact}
      , Cmd.none)
    SaveContact ->
        ( {model | allContacts = unique (model.currentContact :: model.allContacts) }
        , Cmd.none
        )
unique : List a -> List a
unique l = 
    let
        incUnique : a -> List a -> List a
        incUnique elem lst = 
            case List.member elem lst of
                True -> lst
                False -> elem :: lst
    in
        List.foldr incUnique [] l

setName : String -> Contact -> Contact
setName name contact = {contact | name = name}

setEmail : String -> Contact -> Contact
setEmail email contact = {contact | email = email}

setPhoneNumber : String -> Contact -> Contact
setPhoneNumber phoneNumber contact = {contact | phoneNumber = phoneNumber}

setFavorite : Contact -> Contact
setFavorite contact = {contact | isFavorite = not contact.isFavorite}


viewRoot : Model -> Html Msg
viewRoot model =
    Html.div [class "bg-gray-50 bg-opacity-50 divide-x-2"] [
      div [ class "flex" ] [
        viewContactList model,
        div [ class "flex justify-center items-center pr-12 w-full" ] [
          viewForm model
        ]
      ]
    ]

viewHead : Model -> Html Msg
viewHead model =
    Html.div [ class "p-4 bg-gray-100 border-t-2 border-purple-600 bg-opacity-5"] [
        Html.div [ class "max-w-sm mx-auto md:w-full md:mx-0" ] [
            Html.div [ class "inline-flex items-center space-x-4" ] [
                a [src "#", class "block relative"] [
                    Html.img [alt "profile", src "https://oahurcd.org/wp-content/uploads/2021/12/profile-avatar.jpg", class "mx-auto object-cover rounded-full h-16 w-16"] []
                ]
                , Html.h1 [class "text-gray-900 text-2xl font-bold"] [ text "New contact" ]
            ]
        ]
    ]

viewInputField : String -> Html Msg -> Html Msg
viewInputField label input_ =
    Html.div [class "relative z-0 mb-6 w-full group"] [
        input_
      , Html.label [ class "absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-purple-600 peer-focus:dark:text-purple-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6" ]
          [ text label ]
      , p [ class "text-xs py-1.5 text-purple-600"] [ text "required" ]
    ]

viewForm : Model -> Html Msg
viewForm model = 
    Html.form 
        [ onSubmit SaveContact, class "w-1/3 border border-gray-300" ] [
              viewHead model
            , viewContact model.currentContact
            , Html.div [class "flex justify-around bg-white py-2.5"] [
                button [onClick SaveContact, type_ "submit", class "px-8 text-purple-600 hover:bg-purple-100 text-lg rounded-full focus:ring-blue-500 focus:border-blue-500 p-2.5 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"]
                  [text "Save"]
            ]
        ]

viewContact : Contact -> Html Msg
viewContact contact =
    Html.div [class "space-y-6 bg-white divide-y-2"] [
        Html.div [class "px-12"] [
          viewInputField "Name"
            (input
            [ class "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-purple-500 focus:outline-none focus:ring-0 focus:border-purple-600 peer"
            , type_ "name"
            , placeholder ""
            , onInput NameChanged
            , value contact.name
            , required True ] [])
            , viewInputField "Email"
            (input
            [ class "block py-2.5 px-2.5 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-purple-500 focus:outline-none focus:ring-0 focus:border-purple-500 peer"
            , type_ "text"
            , placeholder ""
            , onInput EmailChanged
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
                , onInput PhoneNumberChanged
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
            , onClick FavoriteChanged
            ] []
        , span [class "ml-3 text-gray-700 text-sm"] [text "Favorite contact"]
    ]

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
          (List.map (\contact -> viewContactCard model contact) model.allContacts)
      ]
  ]

viewContactCard : Model -> Contact -> Html Msg
viewContactCard model contact =
  li [ class "py-3 sm:py-4 hover:bg-gray-100" ] [
      div [ class "flex items-center space-x-4" ]
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

getName : Contact -> String
getName contact = contact.name

getEmail : Contact -> String
getEmail contact = contact.email

getPhoneNumber : Contact -> String
getPhoneNumber contact = contact.phoneNumber

-- PORTS


port setStorage : E.Value -> Cmd msg


-- We want to `setStorage` on every update, so this function adds
-- the setStorage command on each step of the update function.
--
-- Check out index.html to see how this is handled on the JS side.


-- JSON ENCODE/DECODE


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg oldModel =
  let
    ( newModel, cmds ) = update msg oldModel
  in
  ( newModel
  , Cmd.batch [ setStorage (encode newModel), cmds ]
  )

encodeSingleContact : Contact -> E.Value
encodeSingleContact contact = E.object
    [ ("name", E.string contact.name)
    , ("email", E.string contact.email)
    , ("phoneNumber", E.string contact.phoneNumber)
    , ("isFavorite", E.bool contact.isFavorite)
    ]


encode : Model -> E.Value
encode model = E.object
    [ ("currentContact", (encodeSingleContact model.currentContact))
    , ("allContacts", E.list (\x -> encodeSingleContact x) model.allContacts)
    ]

decoder : D.Decoder Model
decoder =
  D.map2 Model
    (D.field "currentContact" decodeContact)
    (D.field "allContacts" (D.list decodeContact))

decodeContact : D.Decoder Contact
decodeContact = D.map4 Contact
    (D.field "name"        D.string)
    (D.field "email"       D.string)
    (D.field "phoneNumber" D.string)
    (D.field "isFavorite" D.bool)

init : E.Value -> ( Model, Cmd Msg )
init flags =
  (
    case D.decodeValue decoder flags of
      Ok model -> model
      Err _ -> { allContacts = [], currentContact = { name = "", email = "", phoneNumber = "", isFavorite = False} }
  ,
    Cmd.none
  )